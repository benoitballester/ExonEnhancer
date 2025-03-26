#!/bin/bash

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /mnt/project/exonhancer/jaspar_files/JASPAR2024_mm39.bb /mnt/project/exonhancer/jaspar_files/tmp_pos_mm39
    awk -v a="$name" '{print a,$5,$7}' OFS=$'\t' /mnt/project/exonhancer/jaspar_files/tmp_pos_mm39 >> overlap/ctrlpos_ovlp_jaspar_mm39_2024

done < /home/mouren/Data/final_files_tokeep/other_species/control/mm39_control_pos_enhD_NoTSS_TES_10TFmin.tsv


rm /mnt/project/exonhancer/jaspar_files/tmp_pos_mm39
