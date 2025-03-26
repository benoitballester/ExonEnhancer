#!/bin/bash
#
#SBATCH -p fast                      # partition
#SBATCH --cpus-per-task 8
#SBATCH --mem 200GB                   # mémoire vive pour l'ensemble des cœurs ; on met 250G pour les remap_all
#SBATCH -t 0-23:00                   # durée maximum du travail (D-HH:MM)
#SBATCH -o slurm.%N.%j.out           # STDOUT
#SBATCH -e slurm.%N.%j.err           # STDERR


# To call with the remap dataset first and exons dataset in second

source /shared/projects/exonhancer/venv/bin/activate

# Get all peaks that overleap an exon 
bedtools intersect -sorted -a $2 -b $1 -wa -wb > "exact_peaks_overlap_$1" # we remove the -sorted option for droso