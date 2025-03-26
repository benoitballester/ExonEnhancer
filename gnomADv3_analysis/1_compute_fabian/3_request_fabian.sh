#!/bin/bash

#do the same with enhd_fabian

target_directory="/home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tf_tfbs_fabian"

mkdir /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tmp

input_file="hg38_EE.bed" #list of exons you xant to treat, here normally all the robust 
while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    if [ -e "${target_directory}/${name}_"* ]; then
      echo "$chr $start $end" > tmp_coord
      tabix -R tmp_coord allExons_gnomAD_v3_sorted.vcf.gz > ${name}.vcf
      rm tmp_coord

      bash fabian_curl_pipeline.sh ${name}.vcf < ${target_directory}/${name}_*
      rm ${name}.vcf
    fi

done < "$input_file"

rm -r /home/mouren/Data/variants/fabian/fabian_pipeline/tmp

find /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/fabian_result/ -type f -empty -exec mv {} /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/fabian_result/empty \;