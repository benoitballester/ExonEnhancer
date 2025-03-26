#!/bin/bash
#
#SBATCH -p fast                      # partition
#SBATCH --cpus-per-task 8
#SBATCH --mem 150GB                   # mémoire vive pour l'ensemble des cœurs ; on met 250G pour les remap_all
#SBATCH -t 0-23:00                   # durée maximum du travail (D-HH:MM)
#SBATCH -o slurm.%N.%j.out           # STDOUT
#SBATCH -e slurm.%N.%j.err           # STDERR

# To call with the remap dataset first and exons dataset in second

source /shared/projects/exonhancer/venv/bin/activate

# Swap peaks coordinates columns with peak signal coordinate (potential TFBS)
awk -F $'\t' '{ x = $2; y = $3; $2 = $7; $3 = $8; $7 = x; $8 = y; print; }' OFS=$'\t' $1 > "flag_swapped_$1"

# We sort the file to handle the big data and make interesect faster with the --sorted option
sort -k 1,1 -k 2,2n "flag_swapped_$1" > "flag_sorted_swapped_$1"

rm "flag_swapped_$1"

# Get all peaks that overleap an exon 
bedtools intersect -sorted -a $2 -b "flag_sorted_swapped_$1" -wa -wb > "flag_swapped_filtered_$1" # we remove the -sorted option for droso

rm "flag_sorted_swapped_$1"

# Reswap columns
awk -F $'\t' '{ x = $11; y = $12; $11 = $16; $12 = $17; $16 = x; $17 = y; print; }' OFS=$'\t' "flag_swapped_filtered_$1" > "flag_filtered_$1" # We indicate entry (-F) and output delimiter (OFS)

rm "flag_swapped_filtered_$1"

# Resort the remap bed file
sort -k 1,1 -k 2,2n "flag_filtered_$1" > "exact_summit_overlap_$1"

# Clean
rm "flag_filtered_$1"