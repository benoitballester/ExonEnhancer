#!/bin/bash

rm /home/mouren/Data/variants/fabian_pipeline/exons/SNP_annot_allExons_fabian_gnomadV3_chr20.tsv
touch /home/mouren/Data/variants/fabian_pipeline/exons/SNP_annot_allExons_fabian_gnomadV3_chr20.tsv

folder="/home/mouren/Data/variants/fabian_pipeline/exons/fabian_result_bilan/chr20"

for file in "$folder"/*; do
    if [[ -f "$file" ]]; then

        first_line=$(head -n 1 "$file")

        # Split the values into an array
        IFS=$'\t' read -ra fields <<< "$first_line"

        # Print each field
        for field in "${fields[@]}"; do
            chr=$(echo $field |cut -d":" -f1)
            end=$(echo $field |cut -d":" -f2 |cut -d">" -f1 |grep -o '[0-9]\+')
            start="$((end-1))"
            ref=$(echo $field |cut -d":" -f2 |cut -d">" -f1 |grep -o '[a-zA-Z]\+')
            alt=$(echo $field |cut -d">" -f2 |cut -d"." -f1)

            #get ucsc format
            ~/UCSC_commands/bigBedToBed https://hgdownload.soe.ucsc.edu/gbdb/hg38/gnomAD/v3.1.1/genomes.bb tmp20.bed -chrom=$chr -start=$start -end=$end

            while IFS= read -r line; do
                new_ref=$(echo $line |awk '{print $10}')
                new_alt=$(echo $line |awk '{print $11}')

                if [ "$new_alt" == "$alt" ]; then
                    annot=$(echo "$line" |awk -F'\t' '{print $20}')
                    echo $field$'\t'$annot >> /home/mouren/Data/variants/fabian_pipeline/exons/SNP_annot_allExons_fabian_gnomadV3_chr20.tsv
                    break
                fi

            done < tmp20.bed 
        done
    fi
done