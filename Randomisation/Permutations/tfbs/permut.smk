import os

#launching command with no logs or errors
#snakemake --snakefile /shared/projects/exonhancer/repoexonhancer/revisions/permut/tfbs/permut.smk --jobs 275 --cluster "sbatch --mem=3G --time=00:15:00 --cpus-per-task=1  --output=/dev/null --error=/dev/null" --latency-wait 30

# Total TFBS in all exons (score > 400)
# dm6 962554
# tair10 5803389
# hg38 6077439
# mm39 7447939

# Total TFBS in ee (score > 400)
# dm6 427430 = 44.405820349
# tair10 841832 = 14.5059
# hg38 950514 = 15.640041801
# mm39 889918 = 11.948513542
#bedtools shuffle -i dm6_tfbs_all_exons_coords.bed -incl all_exons_merged_dm6 -g dm6.sizes

# ---- Configuration section ----
PERMUTATIONS=10000
GENOME="tair10.sizes"
DHS="tair10_tfbs_all_exons_coords.bed"
UNIVERSE="all_exons_merged_tair10"
EXONS="tair10_EE.bed"
TOTAL_REGIONS=5803389 
OBSERVED_PERC=14.5059

# ---- Outputs ----  #Hardcoded file because for some obscure reasons _{SPECIES} doesnt work here
AGGREGATED_FILE="results/aggregated_permutations_tair.txt"
PVAL_FILE="results/empirical_pvalue_tair.txt"

# ---- Directories ---- 
os.makedirs("results/overlap", exist_ok=True)

# ---- Workflow ----
rule all:
    input:
        PVAL_FILE
        
rule shuffle_intersect_append_result: #LC_ALL=C sort -k1,1 -k2,2n make sort much faster by forcing byte-wise sorting #flock for overwriting safety for the aggregated file
    input:
        dhs=DHS,
        universe=UNIVERSE,
        genome=GENOME,
        exons=EXONS
    output:
       "results/overlap/perm_done_{i}.flag"  # just a dummy marker
    params:
        total=TOTAL_REGIONS,
        i=lambda wildcards: wildcards.i,
        outlog=AGGREGATED_FILE
    shell:
        """
        count=$(bedtools shuffle -i {input.dhs} -incl {input.universe} -g {input.genome} -chrom |LC_ALL=C sort -k1,1 -k2,2n |bedtools intersect -sorted -u -a - -b {input.exons} |wc -l)

        percentage=$(awk -v c=$count -v t={params.total} 'BEGIN {{ printf "%.3f", (c*100)/t }}')

        (
        flock -x 200
        echo -e "perm_{params.i}\t$percentage" >> {params.outlog}
        ) 200>results/overlap/.lockfile

        touch {output}
        """

rule wait_for_all_done_and_clean:
    input:
        expand("results/overlap/perm_done_{i}.flag", i=range(PERMUTATIONS))
    output:
        "results/permutations_ready.flag"
    shell:
        """
        rm -f results/overlap/perm_done_*.flag
        touch {output}
        """

rule compute_empirical_pvalue: #here we want two side test
    input:
        "results/permutations_ready.flag",
    output:
        PVAL_FILE
    params:
        observed=OBSERVED_PERC,
        aggregated=AGGREGATED_FILE
    shell:
        """
        python /shared/projects/exonhancer/repoexonhancer/revisions/permut/tfbs/compute_pvalue_two_sided.py {params.observed} {params.aggregated} {output}
        rm "results/permutations_ready.flag"
        """