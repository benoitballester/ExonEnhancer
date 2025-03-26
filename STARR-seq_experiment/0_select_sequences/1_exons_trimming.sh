#!/bin/bash
# $1 is A549_GM12878_Uniques_id and K562_id
grep -Ff $1 EE_summary_hg38.tsv |awk '{print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' > bilan

awk '{if ($7<=220) print $1,$2,$3,$4,$5,$6}' OFS=$'\t' bilan > $1_coords_GoodSizes.tsv

awk '{if ($7>220) print $4}' OFS=$'\t' bilan > trim

grep -Ff trim remap_density_ee_hg38.tsv > $1_coords

python /home/mouren/Data/repoexonhancer/experimental_validation/1_5_exons_trimming.py $1_coords

sort -k1,1 -k2,2n $1_coords_TrimmedSizes.tsv > tmp

mv tmp $1_coords_TrimmedSizes.tsv

rm bilan trim $1_coords