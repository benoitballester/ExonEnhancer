#!/bin/bash

# 1 : Treat datasets
awk '(NR>4)' OFS=$'\t' Zhu2015_TableS1_common.csv |awk '{print $1,$2,$3}' OFS=$'\t' > tmp
awk '(NR>4)' OFS=$'\t' Zhu2015_TableS1_leaf.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp
awk '(NR>4)' OFS=$'\t' Zhu2015_TableS1_flower.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp

awk '(NR>5)' OFS=$'\t' Wang2019_TableS1.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp

awk '{split($1,a,"r"); $1=a[2]; print $1,$2,$3}' OFS=$'\t' tmp > tmp1

awk '(NR>2)' OFS=$'\t' TableS1_Zhang2022.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp1
awk '(NR>2)' OFS=$'\t' TableS2_ATAC_Zhang2022.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp1
awk '(NR>1)' OFS=$'\t' TableS2_DNase_Zhang2022.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp1
awk '(NR>3)' OFS=$'\t' TableS3_ATAC_Zhang2022.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp1
awk '(NR>2)' OFS=$'\t' TableS3_DNase_Zhang2022.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp1

awk '(NR>2)' OFS=$'\t' TableS1_Zhao2022.csv |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp1

awk '(NR>2)' OFS=$'\t' TableS1_Tan2023.csv |awk '{if ($1==1 || $1==2 || $1==3 || $1==4 || $1==5) print}' OFS=$'\t' |awk '{print $1,$2,$3}' OFS=$'\t' >> tmp1

sort -u tmp1 |sort -k1,1 -k2,2n - |awk '{print $1,$2,$3,"CtrlPos_"NR}' OFS=$'\t' > tmp2

# 1.5 : Prepare file for 50bp merge
cp tmp2 copy
bedtools intersect -a tmp2 -b copy -wa -wb > ovlp
python /home/mouren/Data/repoexonhancer/other_species/control/tair_control_pos/50bp_diff_merge.py ovlp tmp2
sort -k1,1 -k2,2n merged50 > data

rm tmp tmp1 tmp2 copy ovlp merged50

# 2: gencode tss and tes
awk '{$2=$2-100; $3=$3+100; print;}' OFS=$'\t' data > expand

bedtools intersect -a expand -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_TSS_coord.tsv -c > tmp

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tmp > tmp1
        
bedtools intersect -a tmp1 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_TES_coord.tsv -c > tmp2

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tmp2 > tmp3

# 3: overlap with tss and filter

bedtools intersect -a tmp3 -b /home/mouren/Data/final_files_tokeep/other_species/data/TSS_CAGE/tair10_TSS_catalog.bed -c > tss_fantom1

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tss_fantom1 > tss_fantom2

awk '{$2=$2+100; $3=$3-100; print;}' OFS=$'\t' tss_fantom2 > tss_fantom3

# 4: remove all the ones that overlap with exons
awk '{split($1,a,"r"); $1=a[2]; print $1,$2,$3}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/raw/tair10_CodingExons_raw.tsv > tmp
bedtools intersect -a tss_fantom3 -b tmp -c > exons

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' exons > exons1

# 5: get the ones that overlap 10 tf minimum 
awk '{print $1,$7,$8}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_all_macs2_TAIR10_v1_0.bed > swap #6784

sort -k1,1 -k2,2n exons1 > exons1_sorted

sort -k1,1 -k2,2n swap > swap_sorted

bedtools intersect -sorted -a exons1_sorted -b swap_sorted -c > ovlp

awk '{if ($5>=10) print "chr"$1,$2,$3,$4}' OFS=$'\t' ovlp > tair10_control_pos_NoTSS_TES_10TFmin.tsv

#clean
rm data expand tmp tmp1 tmp2 tmp3 tss_fantom1 tss_fantom2 tss_fantom3 exons exons1 exons1_sorted swap swap_sorted ovlp