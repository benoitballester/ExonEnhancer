#!/bin/bash

# Define input and output file paths

#samtools faidx Drosophila_melanogaster.BDGP6.46.primary_assembly.fa
#awk '{sum += $3 - $2; count++} END {print sum / count}' coding_exons_50pb_merge_dm6.tsv # mean size of exons -> 399.569

genome_fasta="Arabidopsis_thaliana.TAIR10.dna.chromosome.all.fa"
genome_fai="Arabidopsis_thaliana.TAIR10.dna.chromosome.all.fa.fai"
bin_size=200 #Mean size of exons or dnase # 400 dm6 (exons and dnase) #200 hsap  (exons and dnase) #200 mmus  (exons and dnase) #200 tair  (240 exons and 150 dnase)
output_bed="tair10_${bin_size}bp_bins.bed"
output_bedgraph="tair10_${bin_size}bp_gc_percent.bedgraph"

# Create genome bins using bedtools makewindows
bedtools makewindows -g ${genome_fai} -w ${bin_size} > ${output_bed}

# Calculate GC content for each bin using bedtools nuc and awk  ### header: #1_usercol      2_usercol       3_usercol       4_pct_at        5_pct_gc
bedtools nuc -fi ${genome_fasta} -bed ${output_bed} -seq |awk 'OFS="\t" {print $1, $2, $3, $5 }' > ${output_bedgraph}

# Remove the first row of the bedgraph file
tail -n +2 ${output_bedgraph} > tmp && mv tmp ${output_bedgraph}

# Divide into ten bins
awk '{
    score = $4;
    bin = int(score * 10);
    if (bin == 10) bin = 9;
    print > ("bin_" bin ".bed")
}' OFS=$'\t' "${output_bedgraph}"

# Merge overlapping features in each bin
for i in {0..9}; do
    if [[ -f bin_${i}.bed ]]; then
        bedtools sort -i bin_${i}.bed | bedtools merge -i - > bin_${i}_merged.bed
    fi
done

# Remove intermediate files
rm ${output_bed} ${output_bedgraph} bin_[0-9].bed

# Find the last existing merged file
last_existing=""
for i in {9..0}; do
    if [[ -f bin_${i}_merged.bed ]]; then
        last_existing=$i
        break
    fi
done

# Create missing merged files by copying the last existing one
for i in {0..9}; do
    if [[ ! -f bin_${i}_merged.bed && -n "$last_existing" ]]; then
        echo "Creating missing bin_${i}_merged.bed by copying bin_${last_existing}_merged.bed"
        cp bin_${last_existing}_merged.bed bin_${i}_merged.bed
    fi
done