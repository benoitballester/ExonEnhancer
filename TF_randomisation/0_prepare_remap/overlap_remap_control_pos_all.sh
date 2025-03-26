#!/bin/bash

#bash /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/remap/overlap_remap_control_pos_all.sh /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_all_macs2_hg38_v1_0.bed /home/mouren/Data/final_files_tokeep/control/control_pos_enhD_NoTSS_TES_10TFmin.tsv ctrlpos_remap_all_hg38_overlap.tsv hg
#bash /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/remap/overlap_remap_control_pos_all.sh /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_all_macs2_mm39_v1_0.bed /home/mouren/Data/final_files_tokeep/other_species/control/mm39_control_pos_enhD_NoTSS_TES_10TFmin.tsv ctrlpos_remap_all_mm39_overlap.tsv mm
#bash /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/remap/overlap_remap_control_pos_all.sh /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_all_macs2_dm6_v1_0.bed /home/mouren/Data/final_files_tokeep/other_species/control/dm6_control_pos_NoTSS_TES_10TFmin.tsv ctrlpos_remap_all_dm6_overlap.tsv dm
#bash /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/remap/overlap_remap_control_pos_all.sh /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_all_macs2_TAIR10_v1_0.bed /home/mouren/Data/final_files_tokeep/other_species/control/tair10_control_pos_NoTSS_TES_10TFmin_noCHR.tsv ctrlpos_remap_all_tair10_overlap.tsv tair

# Swap peaks coordinates columns with peak signal coordinate (potential TFBS)
awk -F $'\t' '{ x = $2; y = $3; $2 = $7; $3 = $8; $7 = x; $8 = y; print; }' OFS=$'\t' $1 > swap_$4

# We sort the file to handle the big data and make interesect faster with the --sorted option
sort -k 1,1 -k 2,2n swap_$4 > swap_sorted_$4

rm swap_$4

# Get all peaks that overleap an exon 
bedtools intersect -sorted -a $2 -b swap_sorted_$4 -wa -wb > res_$4 # we remove the -sorted option for droso

rm swap_sorted_$4

# Reswap columns
awk -F $'\t' '{ x = $11; y = $12; $11 = $6; $12 = $7; $6 = x; $7 = y; print; }' OFS=$'\t' res_$4 > res2_$4 # We indicate entry (-F) and output delimiter (OFS)

rm res_$4

# Resort the remap bed file
sort -k 1,1 -k 2,2n res2_$4 > $3

# Clean
rm res2_$4