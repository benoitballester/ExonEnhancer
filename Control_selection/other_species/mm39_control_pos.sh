#!/bin/bash

###Control pos are ENCODE enhD with no TSS/TES/Cage TSS dataset proximity

# 1: list of enhD
grep "enhD" EncodecCREs_mm39_annotation.bed |awk '{print $1,$2,$3,$4}' OFS=$'\t' > enhd

# 2: gencode tss and tes
awk '{$2=$2-1000; $3=$3+1000; print;}' OFS=$'\t' enhd > expand

bedtools intersect -a expand -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_TSS_coord.tsv -c > tmp

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tmp > tmp1
        
bedtools intersect -a tmp1 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_TES_coord.tsv -c > tmp2

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tmp2 > tmp3

# 3: overlap with tss and filter
awk '{$2=$2+500; $3=$3-500; print;}' OFS=$'\t' tmp3 > tss_fantom

bedtools intersect -a tss_fantom -b /home/mouren/Data/final_files_tokeep/other_species/data/TSS_CAGE/mm39_fantomTSS_bilan.tsv -c > tss_fantom1

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tss_fantom1 > tss_fantom2

awk '{$2=$2+500; $3=$3-500; print;}' OFS=$'\t' tss_fantom2 > tss_fantom3

# 4: remove all the ones that overlap with exons
bedtools intersect -a tss_fantom3 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/raw/mm39_CodingExons_raw.tsv -c > exons

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' exons > exons1

# 5: get the ones that overlap 10 tf minimum 
awk '{print $1,$7,$8}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_all_macs2_mm39_v1_0.bed > swap

sort -k1,1 -k2,2n exons1 > exons1_sorted

sort -k1,1 -k2,2n swap > swap_sorted

bedtools intersect -sorted -a exons1_sorted -b swap_sorted -c > ovlp

awk '{if ($5>=10) print $1,$2,$3,$4}' OFS=$'\t' ovlp > mm39_control_pos_enhD_NoTSS_TES_10TFmin.tsv

#clean
rm enhd expand tmp tmp1 tmp2 tmp3 tss_fantom tss_fantom1 tss_fantom2 tss_fantom3 exons exons1 exons1_sorted swap swap_sorted ovlp