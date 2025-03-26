#!/bin/bash

### Overlap
bedtools intersect -a /home/mouren/Data/final_files_tokeep/final_catalogs/hg38_EE.bed -b treated_files/hg38_g_quadruplex.bed -wa -wb > overlap/ee_hg38_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/dm6_EE.bed -b treated_files/dm6_g_quadruplex.bed -wa -wb > overlap/ee_dm6_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/mm39_EE.bed -b treated_files/mm39_g_quadruplex.bed -wa -wb > overlap/ee_mm39_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/tair10_EE.bed -b treated_files/tair10_g_quadruplex.bed -wa -wb > overlap/ee_tair10_overlapping_no_strand

bedtools intersect -a /home/mouren/Data/final_files_tokeep/control/control_neg_NoTF_NoTSS_TES_prom.tsv -b treated_files/hg38_g_quadruplex.bed -wa -wb > overlap/neg_hg38_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/control/dm6_control_neg_NoTF_NoTSS_TES.tsv -b treated_files/dm6_g_quadruplex.bed -wa -wb > overlap/neg_dm6_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/control/mm39_control_neg_NoTF_NoTSS_TES_prom.tsv -b treated_files/mm39_g_quadruplex.bed -wa -wb > overlap/neg_mm39_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/control/tair10_control_neg_NoTF_NoTSS_TES.tsv -b treated_files/tair10_g_quadruplex.bed -wa -wb > overlap/neg_tair10_overlapping_no_strand

bedtools intersect -a /home/mouren/Data/final_files_tokeep/control/control_pos_enhD_NoTSS_TES_10TFmin.tsv -b treated_files/hg38_g_quadruplex.bed -wa -wb > overlap/pos_hg38_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/control/dm6_control_pos_NoTSS_TES_10TFmin.tsv -b treated_files/dm6_g_quadruplex.bed -wa -wb > overlap/pos_dm6_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/control/mm39_control_pos_enhD_NoTSS_TES_10TFmin.tsv -b treated_files/mm39_g_quadruplex.bed -wa -wb > overlap/pos_mm39_overlapping_no_strand
bedtools intersect -a /home/mouren/Data/final_files_tokeep/other_species/control/tair10_control_pos_NoTSS_TES_10TFmin.tsv -b treated_files/tair10_g_quadruplex.bed -wa -wb > overlap/pos_tair10_overlapping_no_strand

### Compute percentages of overlap between EE and G-quadruplex data
#ee
nb_h=$(awk '{print $4}' overlap/ee_hg38_overlapping_no_strand |sort -u |wc -l)
nb_d=$(awk '{print $4}' overlap/ee_dm6_overlapping_no_strand |sort -u |wc -l)
nb_m=$(awk '{print $4}' overlap/ee_mm39_overlapping_no_strand |sort -u |wc -l)
nb_t=$(awk '{print $4}' overlap/ee_tair10_overlapping_no_strand |sort -u |wc -l)

res_h=$(( nb_h * 100 / 13481 ))
res_d=$(( nb_d * 100 / 13688 ))
res_m=$(( nb_m * 100 / 12244 ))
res_t=$(( nb_t * 100 / 7138 ))

echo "EE hg ovlp g-quadruplex (no strand): $res_h %"
echo "EE dm ovlp g-quadruplex (no strand): $res_d %"
echo "EE mm ovlp g-quadruplex (no strand): $res_m %"
echo "EE tair ovlp g-quadruplex (no strand): $res_t %"

#neg
nb_h=$(awk '{print $4}' overlap/neg_hg38_overlapping_no_strand |sort -u |wc -l)
nb_d=$(awk '{print $4}' overlap/neg_dm6_overlapping_no_strand |sort -u |wc -l)
nb_m=$(awk '{print $4}' overlap/neg_mm39_overlapping_no_strand |sort -u |wc -l)
nb_t=$(awk '{print $4}' overlap/neg_tair10_overlapping_no_strand |sort -u |wc -l)

res_h=$(( nb_h * 100 / 13253 ))
res_d=$(( nb_d * 100 / 903 ))
res_m=$(( nb_m * 100 / 18457 ))
res_t=$(( nb_t * 100 / 7862 ))

echo "neg hg ovlp g-quadruplex (no strand): $res_h %"
echo "neg dm ovlp g-quadruplex (no strand): $res_d %"
echo "neg mm ovlp g-quadruplex (no strand): $res_m %"
echo "neg tair ovlp g-quadruplex (no strand): $res_t %"

#pos
nb_h=$(awk '{print $4}' overlap/pos_hg38_overlapping_no_strand |sort -u |wc -l)
nb_d=$(awk '{print $4}' overlap/pos_dm6_overlapping_no_strand |sort -u |wc -l)
nb_m=$(awk '{print $4}' overlap/pos_mm39_overlapping_no_strand |sort -u |wc -l)
nb_t=$(awk '{print $4}' overlap/pos_tair10_overlapping_no_strand |sort -u |wc -l)

res_h=$(( nb_h * 100 / 404325 ))
res_d=$(( nb_d * 100 / 133253 ))
res_m=$(( nb_m * 100 / 149241 ))
res_t=$(( nb_t * 100 / 9025 ))

echo "pos hg ovlp g-quadruplex (no strand): $res_h %"
echo "pos dm ovlp g-quadruplex (no strand): $res_d %"
echo "pos mm ovlp g-quadruplex (no strand): $res_m %"
echo "pos tair ovlp g-quadruplex (no strand): $res_t %"