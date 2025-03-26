#!/bin/bash

#mm39
awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_peaks_overlap_remap2022_all_macs2_mm39_v1_0.bed |sort -u > exons_remap
awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv > all_exons
grep -Fvf exons_remap all_exons > no_remap
grep -Ff no_remap /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > no_remap_bilan
awk '{if ($18=="NA" && $22=="NA" && $23=="NA") print $1,$2,$3,$4,$5,$6,$17}' OFS=$'\t' no_remap_bilan > tmp 
awk '{if ($7!="prom") print $1,$2,$3,$4,$5,$6}' OFS=$'\t' tmp > mm39_control_neg_NoTF_NoTSS_TES_prom.tsv

#dm6
awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_peaks_overlap_remap2022_all_macs2_dm6_v1_0.bed |sort -u > exons_remap
awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv > all_exons
grep -Fvf exons_remap all_exons > no_remap
grep -Ff no_remap /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > no_remap_bilan
awk '{if ($16=="NA" && $18=="NA" && $19=="NA") print $1,$2,$3,$4,$5,$6}' OFS=$'\t' no_remap_bilan > dm6_control_neg_NoTF_NoTSS_TES.tsv 

#tair10
awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_peaks_overlap_remap2022_all_macs2_TAIR10_v1_0.bed |sort -u > exons_remap
awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv > all_exons
grep -Fvf exons_remap all_exons > no_remap
grep -Ff no_remap /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > no_remap_bilan
awk '{if ($16=="NA" && $18=="NA" && $19=="NA") print "chr"$1,$2,$3,$4,$5,$6}' OFS=$'\t' no_remap_bilan > tair10_control_neg_NoTF_NoTSS_TES.tsv 

rm exons_remap all_exons no_remap no_remap_bilan tmp


