#!/bin/bash

# Directories
result_dir="result"
merged_dir="merged_results"

# Initialize an array to keep track of processed output bases
processed_output_bases=()

# Iterate over each unique base name of the output files
for output_file in "$result_dir"/*_log2.bigWig; do
  # Get the base name prefix (without the input part and extension)
  output_base=$(basename "$output_file" | cut -d '_' -f 1)

  if [[ " ${processed_output_bases[@]} " =~ " ${output_base} " ]]; then
    continue
  fi

  processed_output_bases+=("$output_base")
  
  # Find all files with the same output base name
  files_to_merge=("$result_dir"/${output_base}_*_log2.bigWig)

  # Construct the merged filename
  merged_filename="${output_base}_log2_merged.bw"

  # At this step we are merging the bigwig of one replicate withs its five controls, so we keep the best signal with the -max option, later when we merge the signal between different replicates we will use the "sum" option (by default)
  ~/UCSC_commands/bigWigMerge -max "${files_to_merge[@]}" out.bedGraph
  
  # sort 
  LC_COLLATE=C sort -k1,1 -k2,2n out.bedGraph > out_sorted.bedGraph
  
  #Transform back into signal
  ~/UCSC_commands/bedGraphToBigWig out_sorted.bedGraph /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38_sizes.genome "$merged_dir/$merged_filename"

  rm out.bedGraph out_sorted.bedGraph
done
