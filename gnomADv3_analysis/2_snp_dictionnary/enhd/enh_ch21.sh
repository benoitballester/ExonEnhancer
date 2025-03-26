#!/bin/bash
touch tmpf21

input_file="/home/mouren/Data/variants/gnomad/enhd_fabian/chr21" #list of exons you xant to treat, here normally all the robust 
while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')

    ~/UCSC_commands/bigBedToBed https://hgdownload.soe.ucsc.edu/gbdb/hg38/gnomAD/v3.1.1/genomes.bb tmp21 -chrom=$chr -start=$start -end=$end

    cat tmp21 >> tmpf21

done < "$input_file"