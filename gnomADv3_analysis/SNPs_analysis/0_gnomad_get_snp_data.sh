#!/bin/bash

input_file="hg38_ctrlNeg.bed"
vcf_file="allExons_gnomAD_v3_sorted.vcf.gz"
output_file="hg38_ctrlNeg_gnomAD_AF.tsv"

# Make sure output is empty
> "$output_file"

# Process each line
while IFS=$'\t' read -r chr start end id; do
    
    # Compute region size
    region_size=$(( end - start ))

    # Query the VCF with tabix
    tabix "$vcf_file" "${chr}:${start}-${end}" |grep PASS > tmp

    # Count total and synonymous variants
    total=$(wc -l < tmp)
    synonymous=$(grep -c "synonymous_variant" tmp)

    # Calculate ratio (protect against division by zero)
    if [ "$total" -eq 0 ]; then
        ratio="0"
    else
        ratio=$(awk -v syn="$synonymous" -v tot="$total" 'BEGIN { printf "%.6f", syn / tot }')
    fi

    # Extract AF values — safer and POSIX-compliant version
    af_values=$(grep -o 'AF=[^;]*' tmp | cut -d= -f2 | paste -sd ';' -)

    echo -e "${id}\t${region_size}\t${synonymous}\t${ratio}\t${af_values}" >> "$output_file"

done < "$input_file"