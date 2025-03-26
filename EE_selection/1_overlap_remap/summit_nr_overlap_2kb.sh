#!/bin/bash
#
#SBATCH -p fast                      # partition
#SBATCH --cpus-per-task 8
#SBATCH --mem 200GB                   # mémoire vive pour l'ensemble des cœurs ; on met 250G pour les remap_all
#SBATCH -t 0-23:00                   # durée maximum du travail (D-HH:MM)
#SBATCH -o slurm.%N.%j.out           # STDOUT
#SBATCH -e slurm.%N.%j.err           # STDERR


# To call with the remap dataset first and exons dataset in second and genome sizes in third

source /shared/projects/exonhancer/venv/bin/activate

# Expand exon file to 2kb on sides
awk '{if ($2>2000) $2=$2-2000; $3=$3+2000; print;}' OFS=$'\t' $2 > "2kflag_exons_expand_$1"

# Swap peaks coordinates columns with peak signal coordinate (potential TFBS)
awk -F $'\t' '{ x = $2; y = $3; $2 = $7; $3 = $8; $7 = x; $8 = y; print; }' OFS=$'\t' $1 > "2kflag_swapped_$1"

# We sort the file to handle the big data and make interesect faster with the --sorted option
sort -k 1,1 -k 2,2n "2kflag_swapped_$1" > "2kflag_sorted_swapped_$1"

rm "2kflag_swapped_$1"

# Get all peaks that overleap an exon 
bedtools intersect -sorted -a "2kflag_exons_expand_$1" -b "2kflag_sorted_swapped_$1" -wa -wb > "2kflag_swapped_filtered_$1" # "-sorted" option removed for droso

rm "2kflag_exons_expand_$1"
rm "2kflag_sorted_swapped_$1"

# Reswap columns
awk -F $'\t' '{ x = $11; y = $12; $11 = $16; $12 = $17; $16 = x; $17 = y; print; }' OFS=$'\t' "2kflag_swapped_filtered_$1" > "2kflag_filtered_$1" # We indicate entry (-F) and output delimiter (OFS)
#awk -F $'\t' '{ x = $9; y = $10; $9 = $14; $10 = $15; $14 = x; $15 = y; print; }' OFS=$'\t' "2kflag_swapped_filtered_$1" > "2kflag_filtered_$1" # This one is for the control set

rm "2kflag_swapped_filtered_$1"

# Reduire le slope des exons dans le fichier flagged
awk '{if ($2>2000)$2 = $2+2000; $3 = $3-2000; print;}' OFS=$'\t' "2kflag_filtered_$1" > "2kflag_full_flagged_$1"

rm "2kflag_filtered_$1"

# Resort the flag bed file
sort -k 1,1 -k 2,2n "2kflag_full_flagged_$1" > "2kb_summit_overlap_$1"

# Clean
rm "2kflag_full_flagged_$1"