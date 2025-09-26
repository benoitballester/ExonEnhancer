#!/bin/bash

# Give your job a name, so you can recognize it in the queue overview
#SBATCH --job-name=Hsap
# Turn on mail notification. There are many possible self-explaining values:
# NONE, BEGIN, END, FAIL, ALL (including all aforementioned)
# For more values, check "man sbatch"
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=50GB


# awk '{print $1,$2,$3,$4,$5,$6}' coding_exons_50pb_merge_Hsap_tls1.tsv > coding_exons_merged_hg_lastz_formatted.bed

##-- 
## sbatch 0_runWgaEnsemblHsap.sbatch 
##-- 
# >>> Conda initialize >>>
eval "$(conda shell.bash hook)"
# <<< Conda initialize <<<
conda activate my_perl_env

#module load  perl/5.26.2

# The "benformated" format is simply the bed file with spaces instead of tabulations. Also the 6 fields of bed are needed (so strand and score may be added)

##-- Doing human > mouse
srun perl /shared/projects/exonhancer/repoexonhancer/revisions/permut/conservation/wgaEnsembl.pl human /shared/projects/exonhancer/data/revisions/permut_test/conservation/coding_exons_merged_hg_lastz_formatted.bed > /shared/projects/exonhancer/data/revisions/permut_test/conservation/lastznet_hg38_all_exons_merged.bed 


#export PERL5LIB=/shared/projects/exonhancer/repoexonhancer/revisions/permut/conservation/ensembl/modules:/shared/projects/exonhancer/repoexonhancer/revisions/permut/conservation/ensembl-compara/modules:/shared/projects/exonhancer/repoexonhancer/revisions/permut/conservation/ensembl-io/modules:$PERL5LIB
