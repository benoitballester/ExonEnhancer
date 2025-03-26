#!/bin/bash

#convert remap density big wig to bedgraph using ucsc tools (kent utilities)

#coord to overlap
awk '{if ($8=="None") exact="No"; if ($8!="None") exact="Yes"; if ($9=="None") $10="No"; if ($9!="None") $10="Yes"; sum=$3-$2; print $1,$2,$3,$4,$5,$6,$7,sum,exact,$10}' OFS=$'\t' coding_exons_50pb_merge_Hsap_tls1.tsv > coord
awk '{$2=$2-500; $3=$3+500; print;}' OFS=$'\t' coord > coord_500
awk '{$2=$2-50; $3=$3+50; print;}' OFS=$'\t' coord > coord_50

#overlap with different datasets
bedtools intersect -a coord -b EncodecCREs_hg38_annotation.bed -wa -wb > encode_ccre_hg38
bedtools intersect -a coord_500 -b hg38_fantomTSS_bilan.tsv -wa -wb > fantom_tss_hg38
bedtools intersect -a coord -b F5.hg38.enhancers.bed -wa -wb > fantom_enh_hg38
bedtools intersect -a coord_500 -b hg38_nc1_tls1_no_prob.tsv -wa -wb > nc1_5_hg38
bedtools intersect -a coord -b GencodeV41_UTR3_UCSC_noProb_CompSet_TLS1.tsv -wa -wb > utr3_hg38
bedtools intersect -a coord -b GencodeV41_UTR5_UCSC_noProb_CompSet_TLS1.tsv -wa -wb > utr5_hg38
bedtools intersect -sorted -a coord -b reMapDensity2022.bedGraph -wa -wb > hg38_density
bedtools intersect -sorted -a coord_50 -b reMapDensity2022.bedGraph -wa -wb > hg38_density_50

awk '{print $2,$3,$4,$5,$6,$7,$8,$9}' OFS=$'\t' $wgEncodeRegDnaseClustered > dnase
bedtools intersect -sorted -a coord -b dnase -wa -wb > hg38_dnase_encode
rm dnase
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ChipAtlas/hg38/DNase_chipAtlas_hg38.bed -wa -wb > hg38_dnase_chipatlas
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ChipAtlas/hg38/ATAC_chipAtlas_hg38.bed -wa -wb > tmp
awk '{print $4,$14,$15}' OFS=$'\t' tmp > hg38_atac_chipatlas

#tss
awk '{if ($5=="+") $3=$3+1000; if ($5=="-") $2=$2-1000; print;}' OFS=$'\t' coding_transcript_TSS_TLS1.tsv > hg38_TSS_expanded
awk '{if ($5=="+") $2=$2-1000; if ($5=="-") $3=$3+1000; print;}' OFS=$'\t' coding_transcript_TES_TLS1.tsv > hg38_TES_expanded
bedtools intersect -a coord -b hg38_TSS_expanded -wa -wb > TSS_hg38
bedtools intersect -a coord -b hg38_TES_expanded -wa -wb > TES_hg38

#clean
rm tmp coord_50 coord_500 hg38_TSS_expanded hg38_TES_expanded