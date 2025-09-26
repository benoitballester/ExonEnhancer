import os

#launching command with no logs or errors
#snakemake --snakefile /shared/projects/exonhancer/repoexonhancer/revisions/permut/histone/permut_gc.smk --jobs 75 --cluster "sbatch --mem=10G --time=00:45:00 --cpus-per-task=1 --output=/dev/null --error=/dev/null" --latency-wait 30

# ---- Configuration section ----
PERMUTATIONS=10000
GENOME="data/hg38_sizes_noChr.genome"
EXONS="data/hg38_EE_noChr.bed"
GC="gc_content/hg38/"
DHS="histone/data/gtex_h3k27ac_peaks_catalog_hg38_gc.bed"
TOTAL_REGIONS=981986 
OBSERVED_PERC=0.639112981 #ee_ovlp_h3k27ac_encode 0.90264234 ee_ovlp_h3k27ac_gtex 0.639112981 ee_ovlp_h3k4me1_encode 0.884739421 ee_ovlp_h3k4me2_encode 8.072111008

    # 514306 ee_ovlp_h3k27ac_encode.tsv
    #   6276 ee_ovlp_h3k27ac_gtex.tsv
    # 372710 ee_ovlp_h3k4me1_encode.tsv
    #  79267 ee_ovlp_h3k4me2_encode.tsv

#   56977828 histone/data/encode_hg38_h3k27ac_gc.bed
#    7716199 histone/data/encode_hg38_h3k4me2_gc.bed
#   42126528 encode_hg38_h3k4me1_gc.bed
#     981986 histone/data/gtex_h3k27ac_peaks_catalog_hg38_gc.bed

## TRUE DIVIDER
#   56978584 encode_hg38_h3k27ac.bed
#   7719012 encode_hg38_h3k4me2.bed
#   42128210 encode_hg38_h3k4me1.bed
#     982340 gtex_h3k27ac_peaks_catalog_hg38.bed


# ---- Outputs ----  #Hardcoded file because for some obscure reasons _{SPECIES} doesnt work here
AGGREGATED_FILE="histone/results/aggregated_permutations_hg38_gtex_h3k27ac_ee_gc.txt"
PVAL_FILE="histone/results/empirical_pvalue_hg38_gtex_h3k27ac_ee_gc.txt"

# ---- Directories ---- 
os.makedirs("histone/results/overlap", exist_ok=True)

# ---- Workflow ----
rule all:
    input:
        PVAL_FILE

rule split_dhs_by_gc:
    input:
        dhs=DHS
    output:
        bins=expand("histone/temp_bins/bin_{i}.bed", i=range(10))
    shell:
        """
        mkdir -p histone/temp_bins

        # Pre-create all bin files to avoid missing output errors
        for i in {{0..9}}; do : > histone/temp_bins/bin_${{i}}.bed; done

        awk '{{ 
            score = $5;
            bin = int(score * 10);
            if (bin == 10) bin = 9;
            file = "histone/temp_bins/bin_" bin ".bed";
            print >> file
        }}' OFS='\\t' {input.dhs}
        """
        
rule shuffle_intersect_append_result: #LC_ALL=C sort -k1,1 -k2,2n make sort much faster by forcing byte-wise sorting #For mmus histone we add -noOverlapping
    input:
        bins=expand("histone/temp_bins/bin_{i}.bed", i=range(10)),
        genome=GENOME,
        exons=EXONS
    output:
        "histone/results/overlap/perm_done_{i}.flag"  # just a dummy marker
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
            if [[ -s histone/temp_bins/bin_${{i}}.bed ]]; then
                bedtools shuffle -i histone/temp_bins/bin_${{i}}.bed -g {input.genome} -incl {params.gc_dir}/bin_${{i}}_merged.bed -chrom > $TMPDIR/bin_${{i}}_shuffled.bed
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
        ) 200>histone/results/overlap/.lockfile

        rm -rf $TMPDIR

        touch {output}
        """


rule wait_for_all_done_and_clean:
    input:
        expand("histone/results/overlap/perm_done_{i}.flag", i=range(PERMUTATIONS))
    output:
        "histone/results/permutations_ready.flag"
    shell:
        """
        rm -f histone/results/overlap/perm_done_*.flag
        rm -rf histone/temp_bins/
        rm -rf temp/
        touch {output}
        """

rule compute_empirical_pvalue: #here we want two side test
    input:
        "histone/results/permutations_ready.flag",
    output:
        PVAL_FILE
    params:
        observed=OBSERVED_PERC,
        aggregated=AGGREGATED_FILE
    shell:
        """
        python /shared/projects/exonhancer/repoexonhancer/revisions/permut/histone/compute_pvalue_two_sided.py {params.observed} {params.aggregated} {output}
        rm "histone/results/permutations_ready.flag"
        """