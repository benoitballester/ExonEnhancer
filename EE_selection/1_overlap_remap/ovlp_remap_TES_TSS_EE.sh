#!/bin/bash

### Get TSS and TES exons
awk '{{if ($22!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/hg38/merge/coding_exons_50pb_merge_hg38.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > hgtss

awk '{{if ($23!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/hg38/merge/coding_exons_50pb_merge_hg38.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > hgtes

awk '{{if ($22!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > mmtss

awk '{{if ($23!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > mmtes

awk '{{if ($18!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > tmp
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > dmtss

awk '{{if ($19!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > tmp 
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > dmtes

awk '{{if ($18!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > tmp
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > tairtss

awk '{{if ($19!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > tmp 
grep -Ff tmp /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > tairtes

### Expand exons enhancers
awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/EE_summary_hg38.tsv |sort -k1,1 -k2,2n - > hgee
awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/EE_summary_mm39.tsv |sort -k1,1 -k2,2n - > mmee
awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/EE_summary_dm6.tsv |sort -k1,1 -k2,2n - > dmee
awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/EE_summary_tair10.tsv |sort -k1,1 -k2,2n - > tairee

###control -noOverlapping removed because too many coordiantes conflicts so not enough control elements
bedtools shuffle -maxTries 1000 -chrom -i mmtss -g /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/hg38/merge/coding_exons_50pb_merge_hg38.tsv |sort -k1,1 -k2,2n - > hgtss_control
bedtools shuffle -maxTries 1000 -chrom -i mmtes -g /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/hg38/merge/coding_exons_50pb_merge_hg38.tsv |sort -k1,1 -k2,2n - > hgtes_control
bedtools shuffle -maxTries 1000 -chrom -i mmee -g /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/hg38/merge/coding_exons_50pb_merge_hg38.tsv |sort -k1,1 -k2,2n - > hgee_control

bedtools shuffle -maxTries 1000 -chrom -i mmtss -g /home/mouren/Data/final_files_tokeep/genomes_sizes/mm39.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |sort -k1,1 -k2,2n - > mmtss_control
bedtools shuffle -maxTries 1000 -chrom -i mmtes -g /home/mouren/Data/final_files_tokeep/genomes_sizes/mm39.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |sort -k1,1 -k2,2n - > mmtes_control
bedtools shuffle -maxTries 1000 -chrom -i mmee -g /home/mouren/Data/final_files_tokeep/genomes_sizes/mm39.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |sort -k1,1 -k2,2n - > mmee_control

bedtools shuffle -maxTries 1000 -chrom -i dmtss -g /home/mouren/Data/final_files_tokeep/genomes_sizes/dm6.chrom.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |sort -k1,1 -k2,2n - > dmtss_control
bedtools shuffle -maxTries 1000 -chrom -i dmtes -g /home/mouren/Data/final_files_tokeep/genomes_sizes/dm6.chrom.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |sort -k1,1 -k2,2n - > dmtes_control
bedtools shuffle -maxTries 1000 -chrom -i dmee -g /home/mouren/Data/final_files_tokeep/genomes_sizes/dm6.chrom.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |sort -k1,1 -k2,2n - > dmee_control

bedtools shuffle -maxTries 1000 -chrom -i tairtss -g /home/mouren/Data/final_files_tokeep/genomes_sizes/tair10.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |sort -k1,1 -k2,2n - > tairtss_control
bedtools shuffle -maxTries 1000 -chrom -i tairtes -g /home/mouren/Data/final_files_tokeep/genomes_sizes/tair10.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |sort -k1,1 -k2,2n - > tairtes_control
bedtools shuffle -maxTries 1000 -chrom -i tairee -g /home/mouren/Data/final_files_tokeep/genomes_sizes/tair10.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |sort -k1,1 -k2,2n - > tairee_control

#Special curation for plant control coordinates 
awk '{if ($2>0) print}' OFS=$'\t' tairtss_control > tairtss_control2
awk '{if ($2>0) print}' OFS=$'\t' tairtes_control > tairtes_control2
awk '{if ($2>0) print}' OFS=$'\t' tairee_control > tairee_control2

### Intersect (we overlap with the chipseq summit peaks and not the full body peak)
bedtools intersect -sorted -a mmee -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmee_ovlp
bedtools intersect -sorted -a mmee_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmee_ovlp_ctrl

bedtools intersect -sorted -a dmee -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dmee_ovlp
bedtools intersect -sorted -a dmee_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dmee_ovlp_ctrl

bedtools intersect -sorted -a tairee -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tairee_ovlp
bedtools intersect -sorted -a tairee_control2 -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tairee_ovlp_ctrl

bedtools intersect -sorted -a mmtss -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmtss_ovlp
bedtools intersect -sorted -a mmtss_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmtss_ovlp_ctrl

bedtools intersect -sorted -a dmtss -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dmtss_ovlp
bedtools intersect -sorted -a dmtss_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dmtss_ovlp_ctrl

bedtools intersect -sorted -a tairtss -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tairtss_ovlp
bedtools intersect -sorted -a tairtss_control2 -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tairtss_ovlp_ctrl

bedtools intersect -sorted -a mmtes -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmtes_ovlp
bedtools intersect -sorted -a mmtes_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmtes_ovlp_ctrl

bedtools intersect -sorted -a dmtes -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dmtes_ovlp
bedtools intersect -sorted -a dmtes_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dmtes_ovlp_ctrl

bedtools intersect -sorted -a tairtes -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tairtes_ovlp
bedtools intersect -sorted -a tairtes_control2 -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tairtes_ovlp_ctrl

bedtools intersect -sorted -a mmee -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmee_ovlp
bedtools intersect -sorted -a mmee_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mmee_ovlp_ctrl

bedtools intersect -sorted -a hgtss -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed -wa -wb > hgtss_ovlp
bedtools intersect -sorted -a hgtss_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed -wa -wb > hgtss_ovlp_ctrl

bedtools intersect -sorted -a hgtes -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed -wa -wb > hgtes_ovlp
bedtools intersect -sorted -a hgtes_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed -wa -wb > hgtes_ovlp_ctrl

rm tmp mmtss mmtes mmee dmtss dmtes dmee tairtss tairtes tairee mmee_control dmee_control tairee_control tairee_control2 mmtss_control dmtss_control tairtss_control tairtss_control2 mmtes_control dmtes_control tairtes_control tairtes_control2
rm hgtss hgtes hgee hgtss_control hgtess_control hgees_control 