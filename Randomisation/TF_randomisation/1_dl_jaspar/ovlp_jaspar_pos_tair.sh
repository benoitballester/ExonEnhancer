#!/bin/bash

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /mnt/project/exonhancer/jaspar_files/JASPAR2022_araTha1.bb /mnt/project/exonhancer/jaspar_files/tmp_pos_tair
    awk -v a="$name" '{print $1,$2,$3,a"_"$7,$5}' OFS=$'\t' /mnt/project/exonhancer/jaspar_files/tmp_pos_tair >> overlap_tfbs2/pos_ovlp_jaspar_tair10_2022_full

done < /home/mouren/Data/final_files_tokeep/other_species/control/tair10_control_pos_NoTSS_TES_10TFmin.tsv

rm /mnt/project/exonhancer/jaspar_files/tmp_pos_tair
