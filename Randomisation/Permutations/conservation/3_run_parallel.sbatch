#!/bin/bash
#SBATCH --job-name=perm_test
#SBATCH --output=logs/output_%A_%a.out
#SBATCH --error=logs/error_%A_%a.err
#SBATCH --array=0-249
#SBATCH -t 0-23:00                   # durée maximum du travail (D-HH:MM)
#SBATCH --cpus-per-task=1
#SBATCH --mem=3G

START=$((40 * SLURM_ARRAY_TASK_ID))
END=$((START + 40))
OUTFILE="/shared/projects/exonhancer/data/revisions/permut_test/conservation/results/results_${SLURM_ARRAY_TASK_ID}.txt"

module load python  # or conda activate yourenv if needed

python /shared/projects/exonhancer/repoexonhancer/revisions/permut/conservation/3_conservation_parallel.py $START $END $OUTFILE
