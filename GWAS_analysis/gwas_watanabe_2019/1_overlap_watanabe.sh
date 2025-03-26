#!/bin/bash
#awk '(NR==1)' OFS=$'\t' watanabe2019_pleiotropy_TS12_hg38_sorted.bed > header_ovlp
#manually add the new fields of header
awk '(NR>1)' OFS=$'\t' watanabe2019_pleiotropy_TS12_hg38_sorted.bed > tmp

bedtools intersect -a /home/mouren/Data/final_files_tokeep/final_catalogs/hg38_EE.bed -b tmp -wa -wb > ee_tmp
bedtools intersect -a /home/mouren/Data/final_files_tokeep/control/hg38_neg.bed -b tmp -wa -wb > neg_tmp

cat header_ovlp ee_tmp > ee_ovlp_gwas2019_hg38
cat header_ovlp neg_tmp > neg_ovlp_gwas2019_hg38

rm tmp ee_tmp neg_tmp