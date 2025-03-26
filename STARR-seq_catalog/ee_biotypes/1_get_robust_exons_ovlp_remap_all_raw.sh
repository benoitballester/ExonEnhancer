#!/bin/bash

# To be called with hg38_EE.bed and exact_summit_overlap_remap2022_all_macs2_hg38_v1_0.bed
awk '{print $4}' $1 > id 
grep -F -f id $2 > only_robust_exact_summit_overlap_remap2022_all_macs2_hg38_v1_0.tsv
rm id

python /home/mouren/Data/repoexonhancer/biotype/2_robust_exons_allTF_bilan.py only_robust_exact_summit_overlap_remap2022_all_macs2_hg38_v1_0.tsv

rm only_robust_exact_summit_overlap_remap2022_all_macs2_hg38_v1_0.tsv   