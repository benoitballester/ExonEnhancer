#!/bin/bash

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /mnt/project/exonhancer/jaspar_files/JASPAR2022_upd_hg38.bb stdout |awk '$5 >= 400' >> /mnt/project/exonhancer/jaspar_files/revisions/hg38_tfbs_all_exons.bed

done < /mnt/project/exonhancer/jaspar_files/revisions/all_exons_merged_hg38

#bash ~/Data/repoexonhancer/revisions/permut/tfbs/0_tfbs_all_exons