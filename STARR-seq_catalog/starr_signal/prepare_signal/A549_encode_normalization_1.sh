#!/bin/bash

# most of the bigwig in encode are unique reads signal inpu, we need the control normalized signal, meanin the log2 fc 

# Directories
signal_input_dir="/home/mouren/Data/starrseq/starr_distribution/bigwig/a549/signal_input"
signal_output_dir="/home/mouren/Data/starrseq/starr_distribution/bigwig/a549/signal_output"
result_dir="/home/mouren/Data/starrseq/starr_distribution/bigwig/a549/result"

# Iterate over each file in the signal_output directory
for output_file in "$signal_output_dir"/*.bigWig; do
  # Get the base name of the output file (without directory and extension)
  output_base=$(basename "$output_file" .bigWig)

  # Iterate over each file in the signal_input directory
  for input_file in "$signal_input_dir"/*.bigWig; do
    # Get the base name of the input file (without directory and extension)
    input_base=$(basename "$input_file" .bigWig)

    # Construct the output filename
    output_filename="${output_base}_${input_base}_log2.bigWig"

    # Run the bigwigCompare command
    bigwigCompare -b1 "$output_file" -b2 "$input_file" --numberOfProcessors 8 --outFileName "$result_dir/$output_filename" --outFileFormat bigwig

    # Print a message indicating the operation is done for the current pair
    echo "Processed $output_file and $input_file to $result_dir/$output_filename"
  done
  gzip "$output_file"
done
