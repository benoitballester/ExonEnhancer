#!/bin/bash
touch tmpfY

input_file="/home/mouren/Data/variants/gnomad/enhd_fabian/chrY" #chr 22; X and Y
while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')

    ~/UCSC_commands/bigBedToBed https://hgdownload.soe.ucsc.edu/gbdb/hg38/gnomAD/v3.1.1/genomes.bb tmpY -chrom=$chr -start=$start -end=$end

    cat tmpY >> tmpfY

done < "$input_file"