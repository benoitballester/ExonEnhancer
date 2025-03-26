#!/bin/bash

#convert remap density big wig to bedgraph using ucsc tools (kent utilities)

#coord to overlap
awk '{if ($8=="None") exact="No"; if ($8!="None") exact="Yes"; if ($9=="None") $10="No"; if ($9!="None") $10="Yes"; sum=$3-$2; print $1,$2,$3,$4,$5,$6,$7,sum,exact,$10}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv > coord
awk '{$2=$2-100; $3=$3+100; print;}' OFS=$'\t' coord > coord_100
awk '{$2=$2-50; $3=$3+50; print;}' OFS=$'\t' coord > coord_50

#overlap with different datasets
bedtools intersect -a coord_100 -b /home/mouren/Data/final_files_tokeep/other_species/data/TSS_CAGE/tair10_TSS_catalog.bed -wa -wb > tss_tair10
bedtools intersect -a coord_100 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_noncoding1_UTR3.tsv -wa -wb > nc1_3_tair10
bedtools intersect -a coord_100 -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_noncoding1_UTR5.tsv -wa -wb > nc1_5_tair10
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_UTR3_protein_coding.tsv -wa -wb > utr3_tair10
bedtools intersect -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_UTR5_protein_coding.tsv -wa -wb > utr5_tair10
bedtools intersect -sorted -a coord -b /home/mouren/Data/final_files_tokeep/other_species/data/remap_density/TAIR10_remap_density.bedGraph -wa -wb > tair10_density
bedtools intersect -sorted -a coord_50 -b /home/mouren/Data/final_files_tokeep/other_species/data/remap_density/TAIR10_remap_density.bedGraph -wa -wb > tair10_density_50
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/DNAse_ATAC_TAIR10/tair10_DNase_PlantRegMap.bed -wa -wb > tair10_dnase_plantregmap
bedtools intersect -sorted -a coord -b /mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/DNAse_ATAC_TAIR10/tair10_ATAC_Geo.bed -wa -wb > tmp
awk '{print $4,$14,$15}' OFS=$'\t' tmp > tair10_atac_geo

#tss
awk '{if ($5=="+") $3=$3+100; if ($5=="-") $2=$2-100; print;}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_TSS_coord.tsv > tair10_TSS_expanded
awk '{if ($5=="+") $2=$2-100; if ($5=="-") $3=$3+100; print;}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/tair10_TES_coord.tsv > tair10_TES_expanded
bedtools intersect -a coord -b tair10_TSS_expanded -wa -wb > TSS_tair10
bedtools intersect -a coord -b tair10_TES_expanded -wa -wb > TES_tair10

#clean
rm tmp coord_50 coord_100 tair10_TSS_expanded tair10_TES_expanded