### Some infos:

# if tumor_id in list_file_gene_count or normal_id in list_file_gene_count:
#                     print("pihp") 
# no full tumor id or normal id in the list of files downloaded              

# no snp in chrY in tcga 

import pandas as pd 
import os 
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import matplotlib
matplotlib.rcParams['pdf.fonttype'] = 42
from pydeseq2.dds import DeseqDataSet
from pydeseq2.ds import DeseqStats
import copy
import sys 

def map_color(a):
    log2FoldChange, padj = a
    if log2FoldChange > 0.5 and padj < 0.05 :
        return 'sig+'
    elif log2FoldChange < -0.5 and padj < 0.05 :
        return 'sig-'
    else:
        return 'ns'

#Get associations across all tissues
dic_asso = {}
with open("./annot_files/robust_associations_exons_genes.txt") as f:
    for line in f:
        if line.strip().split('\t')[0] not in dic_asso:
            dic_asso[line.strip().split('\t')[0]] = [line.strip().split('\t')[1]]
        else:
            dic_asso[line.strip().split('\t')[0]].append(line.strip().split('\t')[1])

###charge tcga all snp 
dic_all_snp_patient_by_exons = {}
with open("./snp_files/tcga_snp_exonhancers_allall.tsv") as f:
    for line in f:
        if line.strip().split('\t')[17] not in dic_all_snp_patient_by_exons:
            dic_all_snp_patient_by_exons[line.strip().split('\t')[17]] = {}
        
        if line.strip().split('\t')[3] not in dic_all_snp_patient_by_exons[line.strip().split('\t')[17]]:
            dic_all_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]] = [(line.strip().split('\t')[14])[:16]]
        else:
            dic_all_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]].append((line.strip().split('\t')[14])[:16])

### do a list of patient that have only silent into the exons
dic_only_syn_snp_patient_by_exons = {}
dic_bad_only_syn_snp_patient_by_exons = {}
    
with open("./snp_files/tcga_snp_exonhancers_allall.tsv") as f:
    for line in f:
        if line.strip().split('\t')[17] not in dic_only_syn_snp_patient_by_exons:
            dic_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]] = {}
            dic_bad_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]] = {}
        
        if line.strip().split('\t')[3] not in dic_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]]:
            dic_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]] = []
            dic_bad_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]] = []
        
        if line.strip().split('\t')[12] == "Silent" and (line.strip().split('\t')[14])[:16] not in dic_bad_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]]:
            dic_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]].append((line.strip().split('\t')[14])[:16])
        else:
            dic_bad_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]].append((line.strip().split('\t')[14])[:16])

            if (line.strip().split('\t')[14])[:16] in dic_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]]:
                dic_only_syn_snp_patient_by_exons[line.strip().split('\t')[17]][line.strip().split('\t')[3]].remove((line.strip().split('\t')[14])[:16])

###
cancer_file = sys.argv[1]

cancer_file_name = os.path.basename(cancer_file)
cancer_type = cancer_file_name.split("_")[0]

df_geneCounts_tmp = pd.read_csv("/shared/projects/exonhancer/data/tcga_deseq/normal_barcodes/bilan_files/only_tumor/"+cancer_file_name, sep="\t", index_col=0)
df_geneCounts_tmp = df_geneCounts_tmp[df_geneCounts_tmp.sum(axis = 1) > 0] #we need to remove rows where all samples are at 0
df_geneCounts_tmp = df_geneCounts_tmp.T #we need the genes as columns 

snpfile_type = "allsyn"

if os.path.exists("/shared/projects/exonhancer/data/tcga_deseq/file_result/"+cancer_type+"_"+snpfile_type+"_by_exons.tsv"): 
    continue

df_snp_raw = pd.read_csv("./snp_files/tcga_snp_exonhancers_allsyn.tsv", sep="\t", header=None)

df_snp = df_snp_raw[df_snp_raw.iloc[:, 17] == cancer_type] #filter snp on cancer 

df_snp_grouped = df_snp.groupby(3)

df_final = pd.DataFrame(columns=["index","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","nlog10","exon","patients","color"])

for group_name, group_data in df_snp_grouped: #FOR EACH EXON IN SNP FILE 

    if not dic_only_syn_snp_patient_by_exons[cancer_type][group_name]: # the exon doesnt have patient with only silent snps in that exon
        continue

    try:
        list_of_target = dic_asso[group_name]
    except KeyError: #The exon don't have predicted interactions
        continue
    
    df_geneCounts = copy.deepcopy(df_geneCounts_tmp)
    for i in dic_bad_only_syn_snp_patient_by_exons[cancer_type][group_name]: #drop patient that have a snp not silent in the exon
        try:
            df_geneCounts = df_geneCounts.drop(i)
        except KeyError:
            continue

    metadata = pd.DataFrame(zip(df_geneCounts.index, ['C']*len(df_geneCounts.index)), columns=['Sample','Condition']) #Create dataframe where all sample are annotated as control

    for patient in dic_only_syn_snp_patient_by_exons[cancer_type][group_name]:
        metadata.loc[metadata['Sample'] == patient, 'Condition'] = "T" #T for tested C for control
        
    metadata = metadata.set_index('Sample')
    try:
        dds = DeseqDataSet(counts=df_geneCounts, metadata=metadata, design_factors="Condition", quiet=True, n_cpus=12)
    except ValueError: #No gene count values available for those patient 
        continue
    
    dds.deseq2()
    stat_res = DeseqStats(dds, contrast=('Condition', 'T', 'C'), quiet=True) #no n_cpus in latest version
    stat_res.summary() #mandatory to run to create a results_df attribute
    res = stat_res.results_df
    res = res[res.baseMean >= 10]

    res["exon"] = group_name
    res["patients"] = ",".join(dic_only_syn_snp_patient_by_exons[cancer_type][group_name])
    res["color"] = res[['log2FoldChange','padj']].apply(map_color, axis = 1)#get color annot on significant
    res = res[res['color'] != 'ns']
    res = res.reset_index()
    df_final = pd.concat([df_final, res], ignore_index=True)

try:
    df_final['nlog10'] = -np.log10(df_final.padj) #get -log10 FDR
except AttributeError:
    pass

df_final.to_csv("/shared/projects/exonhancer/data/tcga_deseq/file_result/"+cancer_type+"_"+snpfile_type+"_by_exons.tsv",sep="\t",header=True,index=True)
