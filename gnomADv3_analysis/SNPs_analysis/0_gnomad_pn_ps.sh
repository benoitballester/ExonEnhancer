#!/bin/bash

input_file="hg38_EE.bed"
vcf_file="allExons_gnomAD_v3_sorted.vcf.gz"
output_file="hg38_ee_gnomAD_pNpS.tsv"

# Make sure output is empty
> "$output_file"

# Initialize totals
total_pN=0
total_pS=0

# Write header
echo -e "ExonID\tLength\tpN\tpS\tpN/pS" >> "$output_file"

# Process each exon
while IFS=$'\t' read -r chr start end id; do
    
    region_size=$(( end - start ))

    # Extract SNPs overlapping the exon
    tabix "$vcf_file" "${chr}:${start}-${end}" | grep PASS > tmp

    # Count synonymous and nonsynonymous variants
    pS=$(grep -c "synonymous_variant" tmp)
    pN=$(grep -c "missense_variant" tmp)

    # Handle division by zero
    if [ "$pS" -eq 0 ]; then
        if [ "$pN" -eq 0 ]; then
            ratio="NA"
        else
            ratio="Inf"
        fi
    else
        ratio=$(awk -v pn="$pN" -v ps="$pS" 'BEGIN { printf "%.6f", pn / ps }')
    fi

    # Save per-exon values
    echo -e "${id}\t${region_size}\t${pN}\t${pS}\t${ratio}" >> "$output_file"

    # Accumulate totals
    total_pN=$(( total_pN + pN ))
    total_pS=$(( total_pS + pS ))

done < "$input_file"

# Compute total pN/pS
if [ "$total_pS" -eq 0 ]; then
    if [ "$total_pN" -eq 0 ]; then
        total_ratio="NA"
    else
        total_ratio="Inf"
    fi
else
    total_ratio=$(awk -v pn="$total_pN" -v ps="$total_pS" 'BEGIN { printf "%.6f", pn / ps }')
fi

# Append total row
echo -e "TOTAL\tNA\t${total_pN}\t${total_pS}\t${total_ratio}" >> "$output_file"
