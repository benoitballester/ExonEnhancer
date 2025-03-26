#!/bin/bash
#
#SBATCH -p long                      # partition
#SBATCH --cpus-per-task 12
#SBATCH --mem 150GB                   # mémoire vive pour l'ensemble des cœurs
#SBATCH -t 29-24:00                   # durée maximum du travail (D-HH:MM)
#SBATCH -o slurm.%N.%j.out           # STDOUT
#SBATCH -e slurm.%N.%j.err           # STDERR

source /shared/projects/exonhancer/venv/bin/activate

srun python /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/IFB_workflow_pydeseq2_by_exons_allall.py $1

# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/ACC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/BLCA_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/BRCA_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/CESC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/CHOL_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/COAD_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/DLBC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/ESCA_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/GBM_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/HNSC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/KICH_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/KIRC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/KIRP_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/LAML_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/LGG_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/LIHC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/LUAD_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/LUSC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/MESO_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/OV_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/PAAD_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/PCPG_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/PRAD_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/READ_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/SARC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/SKCM_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/STAD_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/TGCT_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/THCA_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/THYM_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/UCEC_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/UCS_TumorGeneCounts.tsv
# sbatch /shared/projects/exonhancer/repoexonhancer/variants/tcga/expression_analysis/all_variants/launcher_ifb_workflow_pydeseq2_by_exons.sh normal_barcodes/bilan_files/only_tumor/UVM_TumorGeneCounts.tsv
