#!/bin/bash

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /mnt/project/exonhancer/jaspar_files/JASPAR2024_hg38.bb /mnt/project/exonhancer/jaspar_files/tmp_pos
    awk -v a="$name" '{print a,$5,$7}' OFS=$'\t' /mnt/project/exonhancer/jaspar_files/tmp_pos >> overlap/ctrlpos_ovlp_jaspar_hg38_2024

done < /home/mouren/Data/jaspar_files/ctrlpos

rm /mnt/project/exonhancer/jaspar_files/tmp_pos
