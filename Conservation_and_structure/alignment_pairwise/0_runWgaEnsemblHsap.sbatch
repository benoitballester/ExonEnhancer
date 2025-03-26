#!/bin/bash

# Give your job a name, so you can recognize it in the queue overview
#SBATCH --job-name=Hsap
# Turn on mail notification. There are many possible self-explaining values:
# NONE, BEGIN, END, FAIL, ALL (including all aforementioned)
# For more values, check "man sbatch"
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=30GB


##-- 
## sbatch 0_runWgaEnsemblHsap.sbatch 
##-- 

module load  perl/5.26.2

# The "benformated" format is simply the bed file with spaces instead of tabulations. Also the 6 fields of bed are needed (so strand and score may be added)

##-- Doing human > mouse
srun perl wgaEnsembl.pl human datasets/hg38_exonhancers_candidates.bed > lastznet_hg38_exonhancers_candidates.bed 
srun perl wgaEnsembl.pl human datasets/control_pos_enhD_NoTSS_TES_10TFmin_benformated.bed >  lastznet_control_pos_enhD_NoTSS_TES_10TFmin_benformated.bed 
srun perl wgaEnsembl.pl human datasets/control_neg_NoTF_NoTSS_TES_prom_benformated.bed > lastznet_control_neg_NoTF_NoTSS_TES_prom_benformated.bed 