#!/bin/bash

# $1 is coords file $2 is type $3 is gnomad file
# bash ~/Data/repoexonhancer/variants/gnomad/analysis2/get_vcf.sh hg38_EE.bed ee allExons_gnomAD_v3_sorted.vcf.gz
# bash ~/Data/repoexonhancer/variants/gnomad/analysis2/get_vcf.sh control_pos_enhD_NoTSS_TES_10TFmin.tsv pos allVariants_enhD.vcf.gz
# bash ~/Data/repoexonhancer/variants/gnomad/analysis2/get_vcf.sh control_neg_NoTF_NoTSS_TES_prom.tsv neg allExons_gnomAD_v3_sorted.vcf.gz

input_file="$1"
data_type="$2"
tabix_file="$3"

export data_type tabix_file # Export variables for GNU Parallel

parallel_process() {
    line="$1"
    chr=$(echo "$line" | awk '{print $1}')
    start=$(echo "$line" | awk '{print $2}')
    end=$(echo "$line" | awk '{print $3}')
    name=$(echo "$line" | awk '{print $4}')
    
    echo "$chr $start $end" > coords_"$data_type"
    tabix -R coords_"$data_type" "/mnt/project/exonhancer/gnomad_analysis2/$tabix_file" | \
    cut -f1,2,3,4,5,6,7 | \
    grep PASS | \
    sort -u > "/mnt/project/exonhancer/gnomad_analysis2/${data_type}_result/${name}.vcf"
}

export -f parallel_process

# Run parallel with input file
cat "$input_file" | parallel --no-notice parallel_process