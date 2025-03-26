#!/bin/bash

awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/tls1/overlap_remap_result/exact_peaks_overlap_remap2022_all_macs2_hg38_v1_0.bed |sort -u > exons_remap

awk '{print $4}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/tls1/merge/coding_exons_50pb_merge_Hsap_tls1.tsv > all_exons

grep -Fvf exons_remap all_exons > no_remap

grep -Ff no_remap /home/mouren/Data/final_files_tokeep/tls1/final_catalogs/coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb_AllSummitsPeaksDensitySum_correl_TLS1.bed > no_remap_bilan

awk '{if ($18=="NA" && $22=="NA" && $23=="NA") print $1,$2,$3,$4,$17}' OFS=$'\t' no_remap_bilan > tmp

awk '{if ($5!="prom") print}' OFS=$'\t' tmp > control_neg_NoTF_NoTSS_TES_prom.tsv

rm exons_remap all_exons no_remap no_remap_bilan