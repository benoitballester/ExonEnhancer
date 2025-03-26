#!/bin/bash

### Download data
xargs -L 1 curl -O -J -L < ./files/dl_file_encode.txt
gunzip *.gz

### Prepare data
for file in ./files/*.bed; do awk '(NR>1)' $file |awk -F'\t' '{print $1,$2,$3,$7,$10}' OFS=$'\t' >> tmp ;done 
sort -u tmp |sort -k1,1 -k2,2n - > tmp1
awk 'BEGIN{OFS=FS="\t"} {gsub(" ", "_", $5); print}' OFS='\t' tmp1 > encode_re2g_enhancers_raw.tsv
rm tmp tmp1

### Overlap
bedtools intersect -sorted -f 0.50 -a hg38_EE.bed -b encode_re2g_enhancers_raw.tsv -wa -wb > ee_encode_re2g_overlap_raw.tsv
bedtools intersect -sorted -f 0.50 -a control_neg_NoTF_NoTSS_TES_prom.tsv -b encode_re2g_enhancers_raw.tsv -wa -wb > neg_encode_re2g_overlap_raw.tsv
bedtools intersect -sorted -f 0.50 -a control_pos_enhD_NoTSS_TES_10TFmin.tsv -b encode_re2g_enhancers_raw.tsv -wa -wb > pos_encode_re2g_overlap_raw.tsv
