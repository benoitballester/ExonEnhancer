#!bin/bash
#do this for the three species 
cat treated_* >> tmp
sort -k 1,1 -k 2,2n tmp > coding_exons_50pb_merge_dm6.tsv
rm tmp

#### remove "chr" from tair10 file because plants it can be scaffolds
awk '{sub(/^chr/, "", $1); print}' OFS=$'\t' tair10_CodingExons_protein_coding.tsv > 1
awk '{sub(/^chr/, "", $1); print}' OFS=$'\t' tair10_noncoding1_UTR3.tsv > 2
awk '{sub(/^chr/, "", $1); print}' OFS=$'\t' tair10_noncoding1_UTR5.tsv > 3
awk '{sub(/^chr/, "", $1); print}' OFS=$'\t' tair10_UTR3_protein_coding.tsv > 4
awk '{sub(/^chr/, "", $1); print}' OFS=$'\t' tair10_UTR5_protein_coding.tsv > 5
mv 1 tair10_CodingExons_protein_coding.tsv
mv 2 tair10_noncoding1_UTR3.tsv
mv 3 tair10_noncoding1_UTR5.tsv
mv 4 tair10_UTR3_protein_coding.tsv
mv 5 tair10_UTR5_protein_coding.tsv

awk '{sub(/^chr/, "", $1); print}' OFS=$'\t' coding_exons_50pb_merge_tair10.tsv > 1
awk '{sub(/^chr/, "", $1); print}' OFS=$'\t' coding_exons_exact_merge_tair10.bed > 2
mv 1 coding_exons_50pb_merge_tair10.tsv
mv 2 coding_exons_exact_merge_tair10.bed

##### remove shitty chromosome from dm6
awk '$1 !~ /_/ { print }' OFS=$'\t' coding_exons_50pb_merge_dm6.tsv > tmp
mv tmp coding_exons_50pb_merge_dm6.tsv

awk '$1 !~ /_/ { print }' OFS=$'\t' dm6_CodingExons_protein_coding.tsv > tmp
mv tmp dm6_CodingExons_protein_coding.tsv

awk '$1 !~ /_/ { print }' OFS=$'\t' coding_exons_exact_merge_dm6.bed > tmp
mv tmp coding_exons_exact_merge_dm6.bed