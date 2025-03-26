#!/bin/bash

#convert remap density big wig to bedgraph using ucsc tools (kent utilities)

#coord to overlap
awk '{if ($8=="None") exact="No"; if ($8!="None") exact="Yes"; if ($9=="None") $10="No"; if ($9!="None") $10="Yes"; sum=$3-$2; print $1,$2,$3,$4,$5,$6,$7,sum,exact,$10}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv > coord
awk '{$2=$2-500; $3=$3+500; print;}' OFS=$'\t' coord > coord_500
awk '{$2=$2-50; $3=$3+50; print;}' OFS=$'\t' coord > coord_50

#overlap with different datasets
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/encode_cCREs/EncodecCREs_mm39_annotation.bed -wa -wb > encode_ccre_mm39
bedtools intersect -a coord_500 -b /home/mouren/Data/final_files_tokeep/other_species/data/TSS_CAGE/mm39_fantomTSS_bilan.tsv -wa -wb > fantom_tss_mm39
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/fantom_enh_mm10/F5.mm39.enhancers.bed -wa -wb > fantom_enh_mm39
bedtools intersect -a coord_500 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_noncoding1_UTR3.tsv -wa -wb > nc1_3_mm39
bedtools intersect -a coord_500 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_noncoding1_UTR5.tsv -wa -wb > nc1_5_mm39
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_UTR3_protein_coding.tsv -wa -wb > utr3_mm39
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_UTR5_protein_coding.tsv -wa -wb > utr5_mm39
bedtools intersect -sorted -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/remap_density/mm39_remap_density.bedGraph -wa -wb > mm39_density
bedtools intersect -sorted -a coord_50 -b /home/mouren/Data/final_files_tokeep/other_species/data/remap_density/mm39_remap_density.bedGraph -wa -wb > mm39_density_50
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ENCODE_DNAse/mm39/ENCFF910SRW_mm39_DHS_ENCODE_treated_sorted.tsv -wa -wb > mm39_dnase_encode
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ChipAtlas/mm39/mm39_DNase_ChipAtlas_sorted.bed -wa -wb > mm39_dnase_chipatlas
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ChipAtlas/mm39/mm39_ATAC_ChipAtlas_sorted.bed -wa -wb > tmp
awk '{print $4,$14,$15}' OFS=$'\t' tmp > mm39_atac_chipatlas


#tss
awk '{if ($5=="+") $3=$3+1000; if ($5=="-") $2=$2-1000; print;}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_TSS_coord.tsv > mm39_TSS_expanded
awk '{if ($5=="+") $2=$2-1000; if ($5=="-") $3=$3+1000; print;}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/mm39_TES_coord.tsv > mm39_TES_expanded
bedtools intersect -a coord -b mm39_TSS_expanded -wa -wb > TSS_mm39
bedtools intersect -a coord -b mm39_TES_expanded -wa -wb > TES_mm39

#clean
rm tmp coord_50 coord_500 mm39_TSS_expanded mm39_TES_expanded