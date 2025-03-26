#!/bin/bash

#convert remap density big wig to bedgraph using ucsc tools (kent utilities)

#coord to overlap
awk '{if ($8=="None") exact="No"; if ($8!="None") exact="Yes"; if ($9=="None") $10="No"; if ($9!="None") $10="Yes"; sum=$3-$2; print $1,$2,$3,$4,$5,$6,$7,sum,exact,$10}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv > coord
awk '{$2=$2-100; $3=$3+100; print;}' OFS=$'\t' coord > coord_100
awk '{$2=$2-50; $3=$3+50; print;}' OFS=$'\t' coord > coord_50

#overlap with different datasets
bedtools intersect -a coord_100 -b /home/mouren/Data/final_files_tokeep/other_species/data/TSS_CAGE/dm6_CAGE_TSS_combinedModEncode.bed -wa -wb > tss_dm6
bedtools intersect -a coord_100 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_noncoding1_UTR3.tsv -wa -wb > nc1_3_dm6
bedtools intersect -a coord_100 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_noncoding1_UTR5.tsv -wa -wb > nc1_5_dm6
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_UTR3_protein_coding.tsv -wa -wb > utr3_dm6
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_UTR5_protein_coding.tsv -wa -wb > utr5_dm6
bedtools intersect -sorted -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/remap_density/dm6_remap_density.bedGraph -wa -wb > dm6_density
bedtools intersect -sorted -a coord_50 -b /home/mouren/Data/final_files_tokeep/other_species/data/remap_density/dm6_remap_density.bedGraph -wa -wb > dm6_density_50
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ChipAtlas/dm6/dm6_DNase_ChipAtlas_sorted.bed -wa -wb > dm6_dnase_chipatlas
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ChipAtlas/dm6/dm6_ATAC_ChipAtlas_sorted.bed -wa -wb > tmp
awk '{print $4,$14,$15}' OFS=$'\t' tmp > dm6_atac_chipatlas

#tss
awk '{if ($5=="+") $3=$3+100; if ($5=="-") $2=$2-100; print;}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_TSS_coord.tsv > dm6_TSS_expanded
awk '{if ($5=="+") $2=$2-100; if ($5=="-") $3=$3+100; print;}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/dm6_TES_coord.tsv > dm6_TES_expanded
bedtools intersect -a coord -b dm6_TSS_expanded -wa -wb > TSS_dm6
bedtools intersect -a coord -b dm6_TES_expanded -wa -wb > TES_dm6

#clean
rm tmp coord_50 coord_100 dm6_TSS_expanded dm6_TES_expanded