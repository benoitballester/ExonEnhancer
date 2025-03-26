#!/bin/bash
touch tmpf4

input_file="/home/mouren/Data/variants/gnomad/enhd_fabian/chr4" #list of exons you xant to treat, here normally all the robust 
while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')

    ~/UCSC_commands/bigBedToBed https://hgdownload.soe.ucsc.edu/gbdb/hg38/gnomAD/v3.1.1/genomes.bb tmp4 -chrom=$chr -start=$start -end=$end

    cat tmp4 >> tmpf4

done < "$input_file"