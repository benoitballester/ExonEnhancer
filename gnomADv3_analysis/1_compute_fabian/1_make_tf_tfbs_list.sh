#!/bin/bash

input_file="hg38_EE.bed" # or control_pos_enhD_NoTSS_TES_10TFmin.tsv

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    tf_list=$(echo "$line" |awk '{gsub(",", "\n", $9); print $9}')
    echo "$tf_list" >> /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tf_lists/${name}_tf_list.txt

    ~/UCSC_commands/bigBedToBed -chrom=$chr -start=$start -end=$end /home/mouren/Data/jaspar_files/JASPAR2022_upd_hg38.bb /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tfbs_lists/${name}_tfbs_list.txt

done < "$input_file"