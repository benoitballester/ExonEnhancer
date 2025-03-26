#!/bin/bash

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /mnt/project/exonhancer/jaspar_files/JASPAR2022_mm39.bb /mnt/project/exonhancer/jaspar_files/tmp_ee_mm_random
    awk '{print $1,$2,$3,$7,$5}' OFS=$'\t' /mnt/project/exonhancer/jaspar_files/tmp_ee_mm_random >> overlap_tfbs2/ee_ovlp_jaspar_mm39_2022_full_shuffled

done < /home/mouren/Data/matching_jaspar_remap/remap_overlap_all/mm39_shuffled_to_dl_jaspar_tfbs

rm /mnt/project/exonhancer/jaspar_files/tmp_ee_mm_random
