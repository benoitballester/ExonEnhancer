#!/bin/bash

#TCGA 
grep Silent tcga_snp_exonhancers_raw_uniques_hg19.tsv > sil
grep Missense_Mutation tcga_snp_exonhancers_raw_uniques_hg19.tsv > miss

grep -v Silent tcga_snp_exonhancers_raw_uniques_hg19.tsv > tmp
grep -v Missense_Mutation tmp > others
rm tmp 

awk '{print $1,$2,$3,$1":"$3"_"$4">"$5"_"$7,"0",".",$2,$3,"4,255,0"}' OFS=$'\t' sil > sil_c
awk '{print $1,$2,$3,$1":"$3"_"$4">"$5"_"$7,"0",".",$2,$3,"247,189,0"}' OFS=$'\t' miss > miss_c
awk '{print $1,$2,$3,$1":"$3"_"$4">"$5"_"$7,"0",".",$2,$3,"207,181,59"}' OFS=$'\t' others > others_c

cat sil_c miss_c others_c > tmp
sort -k1,1 -k2,2n tmp > tmp1

~/UCSC_commands/bedToBigBed -type=bed tmp1 hg19.chrom.sizes tcga_snp_type_hg19.bb

rm tmp tmp1 sil miss others sil_c miss_c others_c