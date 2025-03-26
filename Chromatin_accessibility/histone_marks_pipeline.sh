#!/bin/bash

### Data formatting
##ENCODE H3K27ac
xargs -L 1 curl -O -J -L < files_hg19_only.txt 
gunzip *.gz
cat *.bed | sort -k1,1 -k2,2n > tmp 
~/UCSC_commands/liftOver tmp hg19ToHg38.over.chain.gz tmpf unmapped
rm tmp unmapped ENC*.bed

xargs -L 1 curl -O -J -L < files_hg38_only.txt 
gunzip *.gz
cat *.bed  >> tmpf 
sort -k1,1 -k2,2n tmpf > h3k27ac_encode_hsap_hg38.bed
rm tmpf ENC*.bed

##GTEx H3K27ac
cat h3k27ac_gtex_hsap_hg38/* >> h3k27ac_gtex_hsap_hg38/gtex_h3k27ac_peaks_catalog_hg38.bed

##ENCODE h3k4me1
cat h3k4me1_encode_hsap_hg38/raw/* >> h3k4me1_encode_hsap_hg38/encode_hg38_h3k4me1.bed.gz
gzip -d h3k4me1_encode_hsap_hg38/encode_hg38_h3k4me1.bed.gz

##ENCODE h3k4me2
cat h3k4me2_encode_hsap_hg38/raw/* >> h3k4me2_encode_hsap_hg38/encode_hg38_h3k4me2.bed.gz
gzip -d h3k4me2_encode_hsap_hg38/encode_hg38_h3k4me2.bed.gz

### Overlap
bedtools intersect -a control_neg_NoTF_NoTSS_TES_prom.tsv -b ../h3k27ac_gtex_hsap_hg38/gtex_h3k27ac_peaks_catalog_hg38.bed -wa -wb > neg_ovlp_h3k27ac_gtex.tsv 
bedtools intersect -a control_pos_enhD_NoTSS_TES_10TFmin.tsv -b ../h3k27ac_gtex_hsap_hg38/gtex_h3k27ac_peaks_catalog_hg38.bed -wa -wb > pos_ovlp_h3k27ac_gtex.tsv 
bedtools intersect -a hg38_EE.bed -b ../h3k27ac_gtex_hsap_hg38/gtex_h3k27ac_peaks_catalog_hg38.bed -wa -wb > ee_ovlp_h3k27ac_gtex.tsv 

bedtools intersect -a control_neg_NoTF_NoTSS_TES_prom.tsv -b ../h3k4me1_encode_hsap_hg38/encode_hg38_h3k4me1.bed -wa -wb > neg_ovlp_h3k4me1_encode.tsv 
bedtools intersect -a control_pos_enhD_NoTSS_TES_10TFmin.tsv -b ../h3k4me1_encode_hsap_hg38/encode_hg38_h3k4me1.bed -wa -wb > pos_ovlp_h3k4me1_encode.tsv 
bedtools intersect -a hg38_EE.bed -b ../h3k4me1_encode_hsap_hg38/encode_hg38_h3k4me1.bed -wa -wb > ee_ovlp_h3k4me1_encode.tsv 

bedtools intersect -a control_neg_NoTF_NoTSS_TES_prom.tsv -b ../h3k4me2_encode_hsap_hg38/encode_hg38_h3k4me2.bed -wa -wb > neg_ovlp_h3k4me2_encode.tsv 
bedtools intersect -a control_pos_enhD_NoTSS_TES_10TFmin.tsv -b ../h3k4me2_encode_hsap_hg38/encode_hg38_h3k4me2.bed -wa -wb > pos_ovlp_h3k4me2_encode.tsv 
bedtools intersect -a hg38_EE.bed -b ../h3k4me2_encode_hsap_hg38/encode_hg38_h3k4me2.bed -wa -wb > ee_ovlp_h3k4me2_encode.tsv 

bedtools intersect -a control_neg_NoTF_NoTSS_TES_prom.tsv -b ../h3k27ac_encode_hsap_hg38/encode_hg38_h3k27ac.bed -wa -wb > neg_ovlp_h3k27ac_encode.tsv 
bedtools intersect -a control_pos_enhD_NoTSS_TES_10TFmin.tsv -b ../h3k27ac_encode_hsap_hg38/encode_hg38_h3k27ac.bed -wa -wb > pos_ovlp_h3k27ac_encode.tsv 
bedtools intersect -a hg38_EE.bed -b ../h3k27ac_encode_hsap_hg38/encode_hg38_h3k27ac.bed -wa -wb > ee_ovlp_h3k27ac_encode.tsv 