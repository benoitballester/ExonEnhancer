import os

#launching command with no logs or errors
#snakemake --snakefile /shared/projects/exonhancer/repoexonhancer/revisions/permut/dnase/permut_gc.smk --jobs 250 --cluster "sbatch --mem=2G --time=00:10:00 --cpus-per-task=1 --output=/dev/null --error=/dev/null" --latency-wait 30

#Middle of peaks 
# awk 'BEGIN{OFS="\t"} {mid = int(($2 + $3) / 2); print $1,mid,mid+1,$4}' dm6_DNase_ChipAtlas_simplified.bed |sort -k1,1 -k2,2n > dm6_DNase_ChipAtlas_simplified_midpoint.bed
# bedtools intersect -u -a dm6_DNase_ChipAtlas_simplified_midpoint.bed -b ../../data/coding_exons_50pb_merge_dm6.tsv > ovlp_midpoint_dnase_all_exons_dm6.tsv
#wc -l ovlp_midpoint_dnase_all_exons_dm6.tsv # 32569   -> 4,557% dnase midpoint cover exons 

# ---- Configuration section ----
PERMUTATIONS=10000
GENOME="data/genomeDm_BDGP6_sizes_sorted_noChr.txt"
EXONS="data/dm6_EE_noChr.bed"
GC="gc_content/dm6/"
DHS="dnase/data/dm6_DNase_ChipAtlas_gc.bed"
TOTAL_REGIONS=714638 #hg 1744401 mm 1639428 dm 714638 tair 806019
OBSERVED_PERC=1.418620336 #hg 3.9 mm 3.7 dm 4.2 tair 9.6

# ---- Outputs ----  #Hardcoded file because for some obscure reasons _{SPECIES} doesnt work here
AGGREGATED_FILE="dnase/results/aggregated_permutations_dm6_ee_gc.txt"
PVAL_FILE="dnase/results/empirical_pvalue_dm6_ee_gc.txt"

# ---- Directories ---- 
os.makedirs("dnase/results/overlap", exist_ok=True)

# ---- Workflow ----
rule all:
    input:
        PVAL_FILE

rule split_dhs_by_gc:
    input:
        dhs=DHS
    output:
        bins=expand("dnase/temp_bins/bin_{i}.bed", i=range(10))
    shell:
        """
        mkdir -p dnase/temp_bins

        # Pre-create all bin files to avoid missing output errors
        for i in {{0..9}}; do : > dnase/temp_bins/bin_${{i}}.bed; done

        awk '{{ 
            score = $5;
            bin = int(score * 10);
            if (bin == 10) bin = 9;
            file = "dnase/temp_bins/bin_" bin ".bed";
            print >> file
        }}' OFS='\\t' {input.dhs}
        """
        
rule shuffle_intersect_append_result: #LC_ALL=C sort -k1,1 -k2,2n make sort much faster by forcing byte-wise sorting #For mmus dnase we add -noOverlapping
    input:
        bins=expand("dnase/temp_bins/bin_{i}.bed", i=range(10)),
        genome=GENOME,
        exons=EXONS
    output:
        "dnase/results/overlap/perm_done_{i}.flag"  # just a dummy marker
    params:
        total=TOTAL_REGIONS,
        i=lambda wildcards: wildcards.i,
        outlog=AGGREGATED_FILE,
        gc_dir=GC
    shell:
        r"""
        TMPDIR=temp/perm_{params.i}
        mkdir -p $TMPDIR

        # Shuffle each pre-split bin using matching GC region file
        for i in {{0..9}}; do
            if [[ -s dnase/temp_bins/bin_${{i}}.bed ]]; then
                bedtools shuffle -i dnase/temp_bins/bin_${{i}}.bed -g {input.genome} -incl {params.gc_dir}/bin_${{i}}_merged.bed -chrom > $TMPDIR/bin_${{i}}_shuffled.bed
            fi
        done

        # Combine all shuffled peaks
        cat $TMPDIR/bin_*_shuffled.bed > $TMPDIR/all_shuffled.bed

        # Intersect with exons
        count=$(LC_ALL=C sort -k1,1 -k2,2n $TMPDIR/all_shuffled.bed |bedtools intersect -sorted -u -a - -b {input.exons} |wc -l)

        # Append result
        percentage=$(awk -v c=$count -v t={params.total} 'BEGIN {{ printf "%.6f", (c*100)/t }}')

        (
        flock -x 200
        echo -e "perm_{params.i}\t$percentage" >> {params.outlog}
        ) 200>dnase/results/overlap/.lockfile

        rm -rf $TMPDIR

        touch {output}
        """


rule wait_for_all_done_and_clean:
    input:
        expand("dnase/results/overlap/perm_done_{i}.flag", i=range(PERMUTATIONS))
    output:
        "dnase/results/permutations_ready.flag"
    shell:
        """
        rm -f dnase/results/overlap/perm_done_*.flag
        rm -rf dnase/temp_bins/
        rm -rf temp/
        touch {output}
        """

rule compute_empirical_pvalue: #here we want two side test
    input:
        "dnase/results/permutations_ready.flag",
    output:
        PVAL_FILE
    params:
        observed=OBSERVED_PERC,
        aggregated=AGGREGATED_FILE
    shell:
        """
        python /shared/projects/exonhancer/repoexonhancer/revisions/permut/dnase/compute_pvalue_two_sided.py {params.observed} {params.aggregated} {output}
        rm "dnase/results/permutations_ready.flag"
        """