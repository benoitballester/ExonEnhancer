#!/bin/bash

###Lollypop
#TCGA 
~/UCSC_commands/bedToBigBed -as=bigLolly.as -type=bed9+1 tcga_snpFabian_Jaspar_for_lollypop.bed hg19.chrom.sizes tcga_snpFabian_Jaspar_for_lollypop_hg19.bb
~/UCSC_commands/bedToBigBed -as=bigLolly.as -type=bed9+1 tcga_snpFabian_ReMap_Jaspar_for_lollypop.bed hg19.chrom.sizes tcga_snpFabian_ReMap_Jaspar_for_lollypop_hg19.bb

#Gnomad
~/UCSC_commands/bedToBigBed -as=bigLolly.as -type=bed9+1 gnomad_snpFabian_ReMap_Jaspar_for_lollypop.bed hg38.chrom.sizes gnomad_snpFabian_ReMap_Jaspar_for_lollypop_hg38.bb

### EE
~/UCSC_commands/bedToBigBed -type=bed9 EE_hg19_track.bed hg19.chrom.sizes EE_hg19_track.bb
~/UCSC_commands/bedToBigBed -type=bed9 EE_hg38_track.bed hg38.chrom.sizes EE_hg38_track.bb

awk '{print $1,$2,$3,$4,$5,$6,$2,$3,"189,183,107"}' OFS=$'\t' /mnt/project/exonhancer/ZENODO_REPO/EE_selection/mm39_EE.bed > tmp
~/UCSC_commands/bedToBigBed -type=bed9 tmp /mnt/project/exonhancer/ZENODO_REPO/UCSC_trackhub/files/mm39.chrom.sizes mm39_EE_track.bb

awk '{print $1,$2,$3,$4,$5,$6,$2,$3,"189,183,107"}' OFS=$'\t' /mnt/project/exonhancer/ZENODO_REPO/EE_selection/dm6_EE.bed > tmp
~/UCSC_commands/bedToBigBed -type=bed9 tmp /mnt/project/exonhancer/ZENODO_REPO/UCSC_trackhub/files/dm6.chrom.sizes dm6_EE_track.bb

awk '{print $1,$2,$3,$4,$5,$6,$2,$3,"189,183,107"}' OFS=$'\t' /mnt/project/exonhancer/ZENODO_REPO/EE_selection/tair10_EE.bed > tmp
~/UCSC_commands/bedToBigBed -type=bed9 tmp /mnt/project/exonhancer/ZENODO_REPO/UCSC_trackhub/files/tair10_chr.sizes tair10_EE_track.bb
rm tmp

#Get list of tfbs name in jaspar (download file from website -> download -> single file PFM jaspar
grep ">" JASPAR2022_CORE_insects_non-redundant_pfms_jaspar.txt |awk -F'\t' '{print $2}' |sort -u |tr "\n" ,
grep ">" JASPAR2022_CORE_plants_non-redundant_pfms_jaspar.txt |awk -F'\t' '{print $2}' |sort -u |tr "\n" ,