#!/bin/bash
# To call with the remap dataset first and exons dataset in second and genome sizes in third

# source /shared/projects/exonhancer/venv/bin/activate

# Expand exon file to 2kb on sides
awk '{if ($2>2000)$2 = $2-2000; $3 = $3+2000; print;}' OFS=$'\t' $2 > "tmp"

# Swap peaks coordinates columns with peak signal coordinate (potential TFBS)
awk -F $'\t' '{ x = $2; y = $3; $2 = $7; $3 = $8; $7 = x; $8 = y; print; }' OFS=$'\t' $1 > "tmp1"

# We sort the file to handle the big data and make interesect faster with the --sorted option
sort -k 1,1 -k 2,2n "tmp1" > "tmp2"

rm "tmp1"

# Get all peaks that overleap an exon 
bedtools intersect -a "tmp" -b "tmp2" -wa -wb > "tmp3" # "-sorted" option removed for droso

rm "tmp"
rm "tmp2"

# Reswap columns
awk -F $'\t' '{ x = $11; y = $12; $11 = $16; $12 = $17; $16 = x; $17 = y; print; }' OFS=$'\t' "tmp3" > "tmp4" # We indicate entry (-F) and output delimiter (OFS)

rm "tmp3"

# Reduire le slope des exons dans le fichier flagged
awk '{if ($2>2000)$2 = $2+2000; $3 = $3-2000; print;}' OFS=$'\t' "tmp4" > "tmp5"

rm "tmp4"

# Resort the flag bed file
sort -k 1,1 -k 2,2n "tmp5" > "control_2Kb_NoCDS_NoTF_flag_NR_hg38.tsv"

# Clean
rm "tmp5"