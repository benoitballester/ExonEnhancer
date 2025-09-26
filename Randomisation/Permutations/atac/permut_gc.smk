import os

#launching command with no logs or errors
#snakemake --snakefile /shared/projects/exonhancer/repoexonhancer/revisions/permut/atac/permut_gc.smk --jobs 10 --cluster "sbatch --mem=100G --time=03:00:00 --cpus-per-task=1 --output=/dev/null --error=/dev/null" --latency-wait 30

# ---- Configuration section ----
PERMUTATIONS=10000
GENOME="data/mm39_noChr.sizes"
EXONS="data/mm39_EE_noChr.bed"
GC="gc_content/mm39/"
DHS="atac/data/mm39_ATAC_ChipAtlas_sorted_gc.bed"
TOTAL_REGIONS=354064167 #hg 557502645 mm 354025633 dm 7001430 tair 1383977  ### TRUE hg 560011008 mm 354064167 dm 7005346 tair 1383977
OBSERVED_PERC=0.458164 #hg 0.36927197 mm 0.458164 dm 1.405455743 tair 4.031858911

### ee 
#     98402 dm6_ee_atac_ovlp.tsv
#   2058701 hg38_ee_atac_ovlp.tsv
#   1622018 mm39_ee_atac_ovlp.tsv
#     55800 tair10_ee_atac_ovlp.tsv

# ---- Outputs ----  #Hardcoded file because for some obscure reasons _{SPECIES} doesnt work here
AGGREGATED_FILE="atac/results/aggregated_permutations_mm39_ee_gc.txt"
PVAL_FILE="atac/results/empirical_pvalue_mm39_ee_gc.txt"

# ---- Directories ---- 
os.makedirs("atac/results/overlap", exist_ok=True)

# ---- Workflow ----
rule all:
    input:
        PVAL_FILE

rule split_dhs_by_gc:
    input:
        dhs=DHS
    output:
        bins=expand("atac/temp_bins/bin_{i}.bed", i=range(10))
    shell:
        """
        mkdir -p atac/temp_bins

        # Pre-create all bin files to avoid missing output errors
        for i in {{0..9}}; do : > atac/temp_bins/bin_${{i}}.bed; done

        awk '{{ 
            score = $4;
            bin = int(score * 10);
            if (bin == 10) bin = 9;
            file = "atac/temp_bins/bin_" bin ".bed";
            print >> file
        }}' OFS='\\t' {input.dhs}
        """
        
rule shuffle_intersect_append_result: #LC_ALL=C sort -k1,1 -k2,2n make sort much faster by forcing byte-wise sorting #For mmus atac we add -noOverlapping
    input:
        bins=expand("atac/temp_bins/bin_{i}.bed", i=range(10)),
        genome=GENOME,
        exons=EXONS
    output:
        "atac/results/overlap/perm_done_{i}.flag"  # just a dummy marker
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
            if [[ -s atac/temp_bins/bin_${{i}}.bed ]]; then
                bedtools shuffle -i atac/temp_bins/bin_${{i}}.bed -g {input.genome} -incl {params.gc_dir}/bin_${{i}}_merged.bed -chrom > $TMPDIR/bin_${{i}}_shuffled.bed
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
        ) 200>atac/results/overlap/.lockfile

        rm -rf $TMPDIR

        touch {output}
        """


rule wait_for_all_done_and_clean:
    input:
        expand("atac/results/overlap/perm_done_{i}.flag", i=range(PERMUTATIONS))
    output:
        "atac/results/permutations_ready.flag"
    shell:
        """
        rm -f atac/results/overlap/perm_done_*.flag
        rm -rf atac/temp_bins/
        rm -rf temp/
        touch {output}
        """

rule compute_empirical_pvalue: #here we want two side test
    input:
        "atac/results/permutations_ready.flag",
    output:
        PVAL_FILE
    params:
        observed=OBSERVED_PERC,
        aggregated=AGGREGATED_FILE
    shell:
        """
        python /shared/projects/exonhancer/repoexonhancer/revisions/permut/atac/compute_pvalue_two_sided.py {params.observed} {params.aggregated} {output}
        rm "atac/results/permutations_ready.flag"
        """