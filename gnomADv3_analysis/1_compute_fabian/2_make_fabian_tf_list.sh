#!/bin/bash

#do the same with enhd_fabian

source_directory="/home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tf_lists"
target_directory="/home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tfbs_lists"

# Iterate over the files in the source directory
for source_file in "${source_directory}"/*; do
  # Extract the prefix before the "_" character
  prefix="$(basename "$source_file" |rev |cut -d'_' -f3- |rev)"

  awk 'NR==FNR{a[$7];next} $1 in a' ${target_directory}/${prefix}_* $source_file > tmp
  awk 'NR==FNR{a[$1];next} $1 in a' tmp /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/fabian_tf_accepted.txt| tr '\n' ' ' > /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tf_tfbs_fabian/${prefix}_tf_tfbs_fabian.txt
  rm tmp

done

mkdir /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tf_tfbs_fabian/empty
find /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tf_tfbs_fabian/ -type f -empty -exec mv {} /home/mouren/Data/variants/gnomad/exons_fabian/pipeline/tf_tfbs_fabian/empty \;
