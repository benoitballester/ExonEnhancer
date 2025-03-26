#!/bin/bash

awk '(NR>1)' OFS=$'\t' gtex_all_signif_variant_gene_pairs.tsv |sort -k1,1 -k2,2n - > tmp

bedtools intersect -sorted -a hg38_EE.bed -b tmp -wa -wb > exonhancers_overlap_gtexSNP.tsv
 
bedtools intersect -sorted -a control_neg_NoTF_NoTSS_TES_prom.tsv -b tmp -wa -wb > ctrlneg_overlap_gtexSNP.tsv

bedtools intersect -sorted -a control_pos_enhD_NoTSS_TES_10TFmin.tsv -b tmp -wa -wb > ctrlpos_overlap_gtexSNP.tsv
