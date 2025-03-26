#!/bin/bash

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /mnt/project/exonhancer/jaspar_files/JASPAR2024_araTha1.bb /mnt/project/exonhancer/jaspar_files/tmp_neg_tair10
    awk -v a="$name" '{print a,$5,$7}' OFS=$'\t' /mnt/project/exonhancer/jaspar_files/tmp_neg_tair10 >> overlap/ctrlneg_ovlp_jaspar_tair10_2024

done < /home/mouren/Data/final_files_tokeep/other_species/control/tair10_control_neg_NoTF_NoTSS_TES.tsv


rm /mnt/project/exonhancer/jaspar_files/tmp_neg_tair10
