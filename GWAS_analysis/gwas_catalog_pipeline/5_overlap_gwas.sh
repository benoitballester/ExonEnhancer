#!/bin/bash

sort -k1,1 -k2,2n all_LD_snps_merged_formatted.bed > data

bedtools intersect -a /home/mouren/Data/article_repo_data/EE_selection/hg38_EE.bed -b data -wa -wb > ee_gwas.tsv
bedtools intersect -a /home/mouren/Data/article_repo_data/Control_selection/control_neg_NoTF_NoTSS_TES_prom.tsv -b data -wa -wb > neg_gwas.tsv
bedtools intersect -a /home/mouren/Data/article_repo_data/Control_selection/control_pos_enhD_NoTSS_TES_10TFmin.tsv -b data -wa -wb > pos_gwas.tsv

rm data