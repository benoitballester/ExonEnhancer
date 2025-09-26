#!/bin/bash
#
#SBATCH -p fast                      # partition
#SBATCH --cpus-per-task 10            # normally here its 6 
#SBATCH --mem 50GB                   # mémoire vive pour l'ensemble des cœurs (normally here is 30)
#SBATCH -t 00-23:00                  # durée maximum du travail (D-HH:MM)
#SBATCH -o slurm.%N.%j.out           # STDOUT
#SBATCH -e slurm.%N.%j.err           # STDERR

source /shared/projects/exonhancer/venv/bin/activate
# $1 is remap $2 is match tfbs $3 is dic tf per elements
srun python /shared/projects/exonhancer/repoexonhancer/divers/matching_jaspar_remap/pipeline_ifb_randomized_v2/4_check_matching_ifb.py $1 $2 $3
