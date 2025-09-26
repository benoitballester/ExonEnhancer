#!/bin/bash

# bash /shared/projects/exonhancer/repoexonhancer/revisions/permut/compute_gc/compute_gc_data.sh

genome_fasta="/shared/projects/exonhancer/data/revisions/permut_test/gc_content/hg38/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
genome_fai="/shared/projects/exonhancer/data/revisions/permut_test/gc_content/hg38/Homo_sapiens.GRCh38.dna.primary_assembly.fa.fai"
peak_file="/shared/projects/exonhancer/data/revisions/permut_test/atac/data/raw/ATAC_chipAtlas_hg38_sorted.bed"
output_bed="/shared/projects/exonhancer/data/revisions/permut_test/atac/data/ATAC_chipAtlas_hg38_sorted_gc.bed"

# # DNASE remove chr because genome file dont have it 
# awk '{sub(/^chr/, "", $1); print $1,$2,$3,$4}' OFS='\t' ${peak_file} > tmp

# # DNASE Calculate GC content for each bin using bedtools nuc and awk  ### header: #1_usercol      2_usercol       3_usercol       4_usercol       5_pct_at        6_pct_gc 
# bedtools nuc -fi ${genome_fasta} -bed tmp -seq |awk 'OFS="\t" {print $1, $2, $3, $4, $6 }' > ${output_bed}

# # Remap
# awk '{sub(/^chr/, "", $1); print $1,$2,$3,$4,$7,$8}' OFS='\t' ${peak_file} > tmp

# # Remap #1_usercol      2_usercol       3_usercol       4_usercol   5_usercol   6_usercol       7_pct_at        8_pct_gc 
# bedtools nuc -fi ${genome_fasta} -bed tmp -seq |awk 'OFS="\t" {print $1, $5, $6, $4, $8 }' > ${output_bed}

# # HISTONE remove chr because genome file dont have it 
# awk '{sub(/^chr/, "", $1); print $1,$2,$3,$4}' OFS='\t' ${peak_file} > tmp

# # HISTONE Calculate GC content for each bin using bedtools nuc and awk  ### header: #1_usercol      2_usercol       3_usercol       4_usercol       5_pct_at        6_pct_gc 
# bedtools nuc -fi ${genome_fasta} -bed tmp -seq |awk 'OFS="\t" {print $1, $2, $3, $4, $6 }' > ${output_bed}

# # Remove the first row of the bedgraph file
# tail -n +2 ${output_bed} |sort -k1,1 -k2,2n > tmp && mv tmp ${output_bed}

# ATAC remove chr because genome file dont have it 
awk '{sub(/^chr/, "", $1); print $1,$2,$3}' OFS='\t' ${peak_file} > tmp

# ATAC Calculate GC content for each bin using bedtools nuc and awk  ### header: #1_usercol      2_usercol       3_usercol       4_pct_at        5_pct_gc 
bedtools nuc -fi ${genome_fasta} -bed tmp -seq |awk 'OFS="\t" {print $1, $2, $3, $5 }' > ${output_bed}

# Remove the first row of the bedgraph file
#tail -n +2 ${output_bed} |sort -k1,1 -k2,2n > tmp && mv tmp ${output_bed}
tail -n +2 ${output_bed} > tmp && mv tmp ${output_bed}