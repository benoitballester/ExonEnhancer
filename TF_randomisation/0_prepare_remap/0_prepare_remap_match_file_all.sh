#!/bin/bash 

###### EE
## HG
#step 1 : Get id of all hg ee 
awk '{print $4}' /home/mouren/Data/final_files_tokeep/final_catalogs/hg38_EE.bed > ee_id

grep -Ff ee_id /home/mouren/Data/final_files_tokeep/overlap_remap_result/exact_summit_overlap_remap2022_all_macs2_hg38_v1_0.bed > ee_overlap_remap_all
rm ee_id

LC_ALL=C awk '{if ($14>=5.13449) print}' OFS='\t' ee_overlap_remap_all > ee_overlap_remap_all_filtered #Filter the score based on the median of the catalog 

python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py ee_overlap_remap_all_filtered hg ee_peak_remap_all_jaspar_to_match_hg38.bed ee all
rm ee_overlap_remap_all ee_overlap_remap_all_filtered

## MM
awk '{print $4}' /home/mouren/Data/final_files_tokeep/other_species/mm39_EE.bed > ee_id

grep -Ff ee_id /home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_all_macs2_mm39_v1_0.bed > ee_overlap_remap_all
rm ee_id

LC_ALL=C awk '{if ($14>=8.69695) print}' OFS='\t' ee_overlap_remap_all > ee_overlap_remap_all_filtered #Filter the score based on the median of the catalog 

python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py ee_overlap_remap_all_filtered mm ee_peak_remap_all_jaspar_to_match_mm39.bed ee all
rm ee_overlap_remap_all ee_overlap_remap_all_filtered

## DM
awk '{print $4}' /home/mouren/Data/final_files_tokeep/other_species/dm6_EE.bed > ee_id

grep -Ff ee_id /home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_all_macs2_dm6_v1_0.bed > ee_overlap_remap_all
rm ee_id

LC_ALL=C awk '{if ($14>=7.9002) print}' OFS='\t' ee_overlap_remap_all > ee_overlap_remap_all_filtered #Filter the score based on the median of the catalog 

python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py ee_overlap_remap_all_filtered dm ee_peak_remap_all_jaspar_to_match_dm6.bed ee all
rm ee_overlap_remap_all ee_overlap_remap_all_filtered

## TAIR10
awk '{print $4}' /home/mouren/Data/final_files_tokeep/other_species/tair10_EE.bed > ee_id

grep -Ff ee_id /home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_all_macs2_TAIR10_v1_0.bed.bed > ee_overlap_remap_all
rm ee_id 

LC_ALL=C awk '{if ($14>=7.65697) print}' OFS='\t' ee_overlap_remap_all > ee_overlap_remap_all_filtered #Filter the score based on the median of the catalog 

python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py ee_overlap_remap_all_filtered tair ee_peak_remap_all_jaspar_to_match_tair10.bed ee all
rm ee_overlap_remap_all ee_overlap_remap_all_filtered

###### EE RANDOMIZED
bedtools shuffle -i ee_peak_remap_all_jaspar_to_match_hg38.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38_sizes.genome -chrom > ee_peak_remap_all_jaspar_to_match_hg38_shuffled.bed
bedtools shuffle -i ee_peak_remap_all_jaspar_to_match_mm39.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/mm39.sizes -chrom > ee_peak_remap_all_jaspar_to_match_mm39_shuffled.bed
bedtools shuffle -i ee_peak_remap_all_jaspar_to_match_dm6.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/dm6.chrom.sizes -chrom > ee_peak_remap_all_jaspar_to_match_dm6_shuffled.bed
bedtools shuffle -i ee_peak_remap_all_jaspar_to_match_tair10.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/tair10.sizes -chrom > ee_peak_remap_all_jaspar_to_match_tair10_shuffled.bed

sort -k1,1 -k2,2n ee_peak_remap_all_jaspar_to_match_hg38_shuffled.bed > ee_peak_remap_all_jaspar_to_match_hg38_shuffled_sorted.bed
sort -k1,1 -k2,2n ee_peak_remap_all_jaspar_to_match_mm39_shuffled.bed > ee_peak_remap_all_jaspar_to_match_mm39_shuffled_sorted.bed
sort -k1,1 -k2,2n ee_peak_remap_all_jaspar_to_match_dm6_shuffled.bed > ee_peak_remap_all_jaspar_to_match_dm6_shuffled_sorted.bed
sort -k1,1 -k2,2n ee_peak_remap_all_jaspar_to_match_tair10_shuffled.bed > ee_peak_remap_all_jaspar_to_match_tair10_shuffled_sorted.bed

bedtools merge -i ee_peak_remap_all_jaspar_to_match_hg38_shuffled_sorted.bed > hg38_shuffled_to_dl_jaspar_tfbs
bedtools merge -i ee_peak_remap_all_jaspar_to_match_mm39_shuffled_sorted.bed > mm39_shuffled_to_dl_jaspar_tfbs
bedtools merge -i ee_peak_remap_all_jaspar_to_match_dm6_shuffled_sorted.bed > dm6_shuffled_to_dl_jaspar_tfbs
bedtools merge -i ee_peak_remap_all_jaspar_to_match_tair10_shuffled_sorted.bed > tair10_shuffled_to_dl_jaspar_tfbs

rm ee_peak_remap_all_jaspar_to_match_hg38_shuffled_sorted.bed
rm ee_peak_remap_all_jaspar_to_match_mm39_shuffled_sorted.bed
rm ee_peak_remap_all_jaspar_to_match_dm6_shuffled_sorted.bed
rm ee_peak_remap_all_jaspar_to_match_tair10_shuffled_sorted.bed

###### CTRL POS
LC_ALL=C awk '{if ($9>=5.13449) print}' OFS='\t' /mnt/project/exonhancer/jaspar_files/remap_control_pos/ctrlpos_remap_all_hg38_overlap.tsv > hg_filtered #Filter the score based on the median of the catalog 
python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py hg_filtered hg pos_peak_remap_all_jaspar_to_match_hg38.bed pos all

LC_ALL=C awk '{if ($9>=8.69695) print}' OFS='\t' /mnt/project/exonhancer/jaspar_files/remap_control_pos/ctrlpos_remap_all_mm39_overlap.tsv > mm_filtered #Filter the score based on the median of the catalog 
python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py mm_filtered mm pos_peak_remap_all_jaspar_to_match_mm39.bed pos all

LC_ALL=C awk '{if ($9>=7.9002) print}' OFS='\t' /mnt/project/exonhancer/jaspar_files/remap_control_pos/ctrlpos_remap_all_dm6_overlap.tsv > dm_filtered #Filter the score based on the median of the catalog 
python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py dm_filtered dm pos_peak_remap_all_jaspar_to_match_dm6.bed pos all

LC_ALL=C awk '{if ($9>=7.65697) print}' OFS='\t' /mnt/project/exonhancer/jaspar_files/remap_control_pos/ctrlpos_remap_all_tair10_overlap.tsv > tair_filtered #Filter the score based on the median of the catalog 
python /home/mouren/Data/repoexonhancer/divers/matching_jaspar_remap/0_5_prepare_remap_file.py tair_filtered tair pos_peak_remap_all_jaspar_to_match_tair10.bed pos all

rm hg_filtered mm_filtered dm_filtered tair_filtered

###### CTRL POS RANDOMIZED
bedtools shuffle -i pos_peak_remap_all_jaspar_to_match_hg38.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38_sizes.genome -chrom > pos_peak_remap_all_jaspar_to_match_hg38_shuffled.bed
bedtools shuffle -i pos_peak_remap_all_jaspar_to_match_mm39.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/mm39.sizes -chrom > pos_peak_remap_all_jaspar_to_match_mm39_shuffled.bed
bedtools shuffle -i pos_peak_remap_all_jaspar_to_match_dm6.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/dm6.chrom.sizes -chrom > pos_peak_remap_all_jaspar_to_match_dm6_shuffled.bed
bedtools shuffle -i pos_peak_remap_all_jaspar_to_match_tair10.bed -g /home/mouren/Data/final_files_tokeep/genomes_sizes/tair10.sizes -chrom > pos_peak_remap_all_jaspar_to_match_tair10_shuffled.bed

sort -k1,1 -k2,2n pos_peak_remap_all_jaspar_to_match_hg38_shuffled.bed > pos_peak_remap_all_jaspar_to_match_hg38_shuffled_sorted.bed
sort -k1,1 -k2,2n pos_peak_remap_all_jaspar_to_match_mm39_shuffled.bed > pos_peak_remap_all_jaspar_to_match_mm39_shuffled_sorted.bed
sort -k1,1 -k2,2n pos_peak_remap_all_jaspar_to_match_dm6_shuffled.bed > pos_peak_remap_all_jaspar_to_match_dm6_shuffled_sorted.bed
sort -k1,1 -k2,2n pos_peak_remap_all_jaspar_to_match_tair10_shuffled.bed > pos_peak_remap_all_jaspar_to_match_tair10_shuffled_sorted.bed

bedtools merge -i pos_peak_remap_all_jaspar_to_match_hg38_shuffled_sorted.bed > hg38_shuffled_to_dl_jaspar_tfbs_pos
bedtools merge -i pos_peak_remap_all_jaspar_to_match_mm39_shuffled_sorted.bed > mm39_shuffled_to_dl_jaspar_tfbs_pos
bedtools merge -i pos_peak_remap_all_jaspar_to_match_dm6_shuffled_sorted.bed > dm6_shuffled_to_dl_jaspar_tfbs_pos
bedtools merge -i pos_peak_remap_all_jaspar_to_match_tair10_shuffled_sorted.bed > tair10_shuffled_to_dl_jaspar_tfbs_pos

rm pos_peak_remap_all_jaspar_to_match_hg38_shuffled_sorted.bed
rm pos_peak_remap_all_jaspar_to_match_mm39_shuffled_sorted.bed
rm pos_peak_remap_all_jaspar_to_match_dm6_shuffled_sorted.bed
rm pos_peak_remap_all_jaspar_to_match_tair10_shuffled_sorted.bed