#!/bin/bash
#SBATCH --job-name=EPO_EE
#SBATCH --mem=30G
#SBATCH --array=1-3

data_dir=/shared/home/bballester/2.exons/ensembl_alnmt/datasets
result_dir=/shared/home/bballester/2.exons/ensembl_alnmt/epo_sbatcharray
param_store=/shared/home/bballester/2.exons/ensembl_alnmt/wgaEnsemblEPO.args 
### wgaEnsembl2.args contains 12 lines with 2 arguments per line.
###    Line <i> contains arguments for run <i>
param_spe1=$(cat $param_store | awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $1}')
param_infile=$(cat $param_store | awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $2}')
param_outfile=$(cat $param_store | awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $3}')
param_mem=$(cat $param_store | awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $4}')
param_partition=$(cat $param_store | awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $5}')


##-- 
## sbatch runWgaEnsemblEPOarray.sbatch 
##-- 

module load  perl/5.26.2

echo "parsing args: "$(cat $param_store | awk -v var=$SLURM_ARRAY_TASK_ID 'NR==var {print $0}')


##-- Doing Pairwise
##srun perl wgaEnsembl2.pl homo_sapiens datasets/hg38_exonhancers_candidates.bed > lastznet_hg38_exonhancers_candidates.bed 
##srun perl wgaEnsembl2.pl homo_sapiens datasets/control_pos_enhD_NoTSS_TES_10TFmin_benformated.bed >  lastznet_control_pos_enhD_NoTSS_TES_10TFmin_benformated.bed 
##srun perl wgaEnsembl2.pl homo_sapiens datasets/control_neg_NoTF_NoTSS_TES_prom_benformated.bed > lastznet_control_neg_NoTF_NoTSS_TES_prom_benformated.bed 


srun perl wgaEnsemblEPOhelpdesk.pl $param_spe1 ${data_dir}/$param_infile > ${result_dir}/$param_outfile

##srun ./foo -c $param_a -p $param_b -i ${data_dir}/input_run_${n}.txt -o ${result_dir}/result_run_${n}.txt


