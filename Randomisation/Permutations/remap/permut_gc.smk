import os

#launching command with no logs or errors
#snakemake --snakefile /shared/projects/exonhancer/repoexonhancer/revisions/permut/remap/permut_gc.smk --jobs 75 --cluster "sbatch --mem=10G --time=00:30:00 --cpus-per-task=1 --output=/dev/null --error=/dev/null" --latency-wait 30

# ---- Configuration section ----
PERMUTATIONS=10000
GENOME="data/mm39_noChr.sizes"
EXONS="data/mm39_EE_noChr.bed"
GC="gc_content/mm39/"
DHS="remap/data/mm39_nr_summit_gc.bed"
TOTAL_REGIONS=43739951 #hg 68622476 mm 43739951 dm 12961043 tair 3246543 ### EN FAIT hg 68655741 mm 43745118 dm 12965614 tair 3246543
OBSERVED_PERC=0.675547167 #hg 4.2 mm 3.3 dm 10.8 tair 21.8

# ---- Outputs ----  #Hardcoded file because for some obscure reasons _{SPECIES} doesnt work here
AGGREGATED_FILE="remap/results/aggregated_permutations_mm39_ee_gc.txt"
PVAL_FILE="remap/results/empirical_pvalue_mm39_ee_gc.txt"

# ---- Directories ---- 
os.makedirs("remap/results/overlap", exist_ok=True)

# ---- Workflow ----
rule all:
    input:
        PVAL_FILE

rule split_dhs_by_gc:
    input:
        dhs=DHS
    output:
        bins=expand("remap/temp_bins/bin_{i}.bed", i=range(10))
    shell:
        """
        mkdir -p remap/temp_bins

        # Pre-create all bin files to avoid missing output errors
        for i in {{0..9}}; do : > remap/temp_bins/bin_${{i}}.bed; done

        awk '{{ 
            score = $5;
            bin = int(score * 10);
            if (bin == 10) bin = 9;
            file = "remap/temp_bins/bin_" bin ".bed";
            print >> file
        }}' OFS='\\t' {input.dhs}
        """
        
rule shuffle_intersect_append_result: #LC_ALL=C sort -k1,1 -k2,2n make sort much faster by forcing byte-wise sorting #For mmus remap we add -noOverlapping
    input:
        bins=expand("remap/temp_bins/bin_{i}.bed", i=range(10)),
        genome=GENOME,
        exons=EXONS
    output:
        "remap/results/overlap/perm_done_{i}.flag"  # just a dummy marker
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
            if [[ -s remap/temp_bins/bin_${{i}}.bed ]]; then
                bedtools shuffle -i remap/temp_bins/bin_${{i}}.bed -g {input.genome} -incl {params.gc_dir}/bin_${{i}}_merged.bed -chrom > $TMPDIR/bin_${{i}}_shuffled.bed
            fi
        done

        # Combine all shuffled peaks
        cat $TMPDIR/bin_*_shuffled.bed > $TMPDIR/all_shuffled.bed

        # Intersect with exons
        count=$(LC_ALL=C sort -k1,1 -k2,2n $TMPDIR/all_shuffled.bed |bedtools intersect -sorted -u -a - -b {input.exons} |wc -l)

        # Append result
        percentage=$(awk -v c=$count -v t={params.total} 'BEGIN {{ printf "%.3f", (c*100)/t }}')

        (
        flock -x 200
        echo -e "perm_{params.i}\t$percentage" >> {params.outlog}
        ) 200>remap/results/overlap/.lockfile

        rm -rf $TMPDIR

        touch {output}
        """


rule wait_for_all_done_and_clean:
    input:
        expand("remap/results/overlap/perm_done_{i}.flag", i=range(PERMUTATIONS))
    output:
        "remap/results/permutations_ready.flag"
    shell:
        """
        rm -f remap/results/overlap/perm_done_*.flag
        rm -rf remap/temp_bins/
        rm -rf temp/
        touch {output}
        """

rule compute_empirical_pvalue: #here we want two side test
    input:
        "remap/results/permutations_ready.flag",
    output:
        PVAL_FILE
    params:
        observed=OBSERVED_PERC,
        aggregated=AGGREGATED_FILE
    shell:
        """
        python /shared/projects/exonhancer/repoexonhancer/revisions/permut/remap/compute_pvalue_two_sided.py {params.observed} {params.aggregated} {output}
        rm "remap/results/permutations_ready.flag"
        """