#!/bin/bash

merged_dir="merged_results"

files_to_merge=("$merged_dir"/*.bw)

~/UCSC_commands/bigWigMerge "${files_to_merge[@]}" ENCFF449RRV.bigWig out.bedGraph
  
LC_COLLATE=C sort -k1,1 -k2,2n out.bedGraph > allENCODE_STARR_signal_A-549_sorted_raw.bedGraph

python /home/mouren/Data/repoexonhancer/starrseq/plots/A549_encode_normalize_3.5.py allENCODE_STARR_signal_A-549_sorted_raw.bedGraph

~/UCSC_commands/bedGraphToBigWig allENCODE_STARR_signal_A-549_sorted_normalized.bedGraph /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38_sizes.genome allENCODE_STARR_signal_A-549_normalized.bw

rm out.bedGraph
