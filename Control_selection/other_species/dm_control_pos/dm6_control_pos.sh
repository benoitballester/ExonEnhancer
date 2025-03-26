#!/bin/bash

# 1 : Treat datasets
cat /home/mouren/Data/final_files_tokeep/other_species/control/dm_pos/* >> tmp

sort -u tmp |sort -k1,1 -k2,2n - |awk '{print $1,$2,$3,"dm6_CtrlPos_"NR}' OFS=$'\t' > tmp1

# 1.5 : Prepare file for 50bp merge
cp tmp1 copy
bedtools intersect -a tmp1 -b copy -wa -wb > ovlp
awk '{print>$1}' OFS=$'\t' ovlp

python /home/mouren/Data/repoexonhancer/other_species/control/dm_control_pos/50bp_diff_merge.py chr2L tmp1
python /home/mouren/Data/repoexonhancer/other_species/control/dm_control_pos/50bp_diff_merge.py chr2R tmp1
python /home/mouren/Data/repoexonhancer/other_species/control/dm_control_pos/50bp_diff_merge.py chr3L tmp1
python /home/mouren/Data/repoexonhancer/other_species/control/dm_control_pos/50bp_diff_merge.py chr3R tmp1
python /home/mouren/Data/repoexonhancer/other_species/control/dm_control_pos/50bp_diff_merge.py chr4 tmp1
python /home/mouren/Data/repoexonhancer/other_species/control/dm_control_pos/50bp_diff_merge.py chrM tmp1
python /home/mouren/Data/repoexonhancer/other_species/control/dm_control_pos/50bp_diff_merge.py chrX tmp1

cat chr2L_treated chr2R_treated chr3L_treated chr3R_treated chr4_treated chrM_treated chrX_treated >> tmp2
sort -k1,1 -k2,2n tmp2 > data

rm tmp tmp1 tmp2 copy ovlp chr2L chr2R chr3L chr3R chr4 chrM chrX chr2L_treated chr2R_treated chr3L_treated chr3R_treated chr4_treated chrM_treated chrX_treated chr2LHet chr2RHet chr3LHet chr3RHet chrU chrUextra chrXHet chrYHet

# 2: gencode tss and tes
awk '{if ($2>=100) $2=$2-100; $3=$3+100; print;}' OFS=$'\t' data > expand

bedtools intersect -a expand -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_TSS_coord.tsv -c > tmp

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tmp > tmp1
        
bedtools intersect -a tmp1 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_TES_coord.tsv -c > tmp2

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' tmp2 > tmp3

# 3: overlap with tss and filter

bedtools intersect -a tmp3 -b /home/mouren/Data/final_files_tokeep/other_species/data/TSS_CAGE/dm6_CAGE_TSS_combinedModEncode.bed -c > tss_fantom1

awk '{if ($5==0) print $4}' OFS=$'\t' tss_fantom1 > tss_fantom2

grep -Ff tss_fantom2 data > tss_fantom3

# 4: remove all the ones that overlap with exons
bedtools intersect -a tss_fantom3 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/raw/dm6_CodingExons_raw.tsv -c > exons

awk '{if ($5==0) print $1,$2,$3,$4}' OFS=$'\t' exons > exons1

# 5: get the ones that overlap 10 tf minimum 
awk '{print $1,$7,$8}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_all_macs2_dm6_v1_0.bed > swap

sort -k1,1 -k2,2n exons1 > exons1_sorted

sort -k1,1 -k2,2n swap > swap_sorted

bedtools intersect -sorted -a exons1_sorted -b swap_sorted -c > ovlp

awk '{if ($5>=10) print $1,$2,$3,$4}' OFS=$'\t' ovlp > dm6_control_pos_NoTSS_TES_10TFmin.tsv

#clean
rm data expand tmp tmp1 tmp2 tmp3 tss_fantom1 tss_fantom2 tss_fantom3 exons exons1 exons1_sorted swap swap_sorted ovlp