#!/bin/bash
 
awk '{print $1,$3,$12,$5,$6,$2,".",".","GT:DP","0/1:154"}' OFS=$'\t' tcga_snp_exonhancers_hg19.tsv > fabian/vcf_raw

#we need to iterate 10 000 variant by 10 000 (limit of fabian)
cd fabian

awk '{if ($4!="-") print}' OFS=$'\t' vcf_raw > vcf_raw1

split -l 9999 vcf_raw1
rm vcf_raw vcf_raw1

input_directory="/home/mouren/Data/variants/tcga_MC3/fabian"

# Loop through each file in the directory
for file in "$input_directory"/*
do
    if [ -f "$file" ]; then
        bash /home/mouren/Data/repoexonhancer/variants/tcga/scripts_formatting_fabian/fabian_curl_script.sh "$file"
        rm $file
    fi
done

