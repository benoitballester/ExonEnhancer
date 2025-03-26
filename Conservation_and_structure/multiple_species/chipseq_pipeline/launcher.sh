#!/bin/bash
#
#SBATCH -p long                      # partition
#SBATCH --cpus-per-task 25
#SBATCH --mem 250GB                  # mémoire vive pour l'ensemble des cœurs
#SBATCH -t 7-00:00                   # durée maximum du travail (D-HH:MM)
#SBATCH -o slurm.%N.%j.out           # STDOUT
#SBATCH -e slurm.%N.%j.err           # STDERR

module load snakemake fastp bowtie2 samtools sambamba macs2

snakemake -j 25 -s /shared/projects/exonhancer/repoexonhancer/conservation/pipeline_elife_chipSeq.smk
