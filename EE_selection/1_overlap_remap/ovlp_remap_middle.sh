#!/bin/bash
# for all exons except TSS and TES

### Get TSS and TES exons
awk '{{if ($22!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
cat tmp > hg_remove

awk '{{if ($23!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
cat tmp >> hg_remove

awk '{{if ($22!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
cat tmp > mm_remove

awk '{{if ($23!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp
cat tmp >> mm_remove

awk '{{if ($18!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > tmp
cat tmp > dm_remove

awk '{{if ($19!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > tmp 
cat tmp >> dm_remove

awk '{{if ($18!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > tmp
cat tmp > tair_remove

awk '{{if ($19!="NA") print $4}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > tmp 
cat tmp >> tair_remove

### Expand exons
grep -vFf hg_remove /home/mouren/Data/final_files_tokeep/other_species/data/gencode/hg38/merge/coding_exons_50pb_merge_hg38.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > hg_middle
grep -vFf mm_remove /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > mm_middle
grep -vFf dm_remove /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > dm_middle
grep -vFf tair_remove /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' |sort -k1,1 -k2,2n - > tair_middle

###control -noOverlapping removed because too many coordiantes conflicts so not enough control elements
bedtools shuffle -maxTries 1000 -chrom -i hg_middle -g /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/hg38/merge/coding_exons_50pb_merge_hg38.tsv |sort -k1,1 -k2,2n - > hg_middle_control
bedtools shuffle -maxTries 1000 -chrom -i mm_middle -g /home/mouren/Data/final_files_tokeep/genomes_sizes/mm39.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |sort -k1,1 -k2,2n - > mm_middle_control
bedtools shuffle -maxTries 1000 -chrom -i dm_middle -g /home/mouren/Data/final_files_tokeep/genomes_sizes/dm6.chrom.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |sort -k1,1 -k2,2n - > dm_middle_control
bedtools shuffle -maxTries 1000 -chrom -i tair_middle -g /home/mouren/Data/final_files_tokeep/genomes_sizes/tair10.sizes -excl /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |sort -k1,1 -k2,2n - > tair_middle_control
 
#Special curation for plant control coordinates 
awk '{if ($2>0) print}' OFS=$'\t' tair_middle_control > tair_middle_control2

### Intersect  (we overlap with the chipseq summit peaks and not the full body peak)
bedtools intersect -sorted -a hg_middle -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed -wa -wb > hg_middle_ovlp
bedtools intersect -sorted -a hg_middle_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed -wa -wb > hg_middle_ovlp_ctrl

bedtools intersect -sorted -a mm_middle -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mm_middle_ovlp
bedtools intersect -sorted -a mm_middle_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mm_middle_ovlp_ctrl

bedtools intersect -sorted -a dm_middle -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dm_middle_ovlp
bedtools intersect -sorted -a dm_middle_control -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dm_middle_ovlp_ctrl

bedtools intersect -sorted -a tair_middle -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tair_middle_ovlp
bedtools intersect -sorted -a tair_middle_control2 -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tair_middle_ovlp_ctrl 

rm tmp mm_middle dm_middle tair_middle mm_middle_control dm_middle_control tair_middle_control tair_middle_control2 dm_remove mm_remove tair_remove
rm hg_middle hg_middle_control hg_remove