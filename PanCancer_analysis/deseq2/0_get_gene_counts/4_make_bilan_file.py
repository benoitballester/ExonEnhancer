import pandas as pd 
import os 

#cancer id to full name dic
tiss_dic={}
with open("/home/mouren/Data/variants/tcga_MC3/raw_and_notes/tissue_source_sites_codes_dictionnay.tsv") as file:
    for line in file: 
        tiss_dic[line.strip().split("\t")[0]] = line.strip().split("\t")[2]

#abrv_dic id to full name dic
abrv_dic={}
with open("/home/mouren/Data/variants/tcga_MC3/raw_and_notes/tcga_cancer_abrev_dic.tsv") as file:
    for line in file: 
        abrv_dic[line.strip().split("\t")[1]] = line.strip().split("\t")[0]

#list file of gene counts 
list_file_gene_count = []
with open("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/list_name_files") as f:
    for line in f:
        list_file_gene_count.append(line.strip())

#list of gene in a file to use as index 
index_genes = []
with open("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/list_genes_in_a_gene_count_file_without_PAR-Y") as f:
    for line in f:
        index_genes.append(line.strip())

#get list of file per cancer 
dic_files_cancer = {}
list_files_normal = []

for name in list_file_gene_count:
    cancer_id = name.split("-")[1] #we get the Tissue Source Site in the tumor barcode number 
    cancer_name = tiss_dic[cancer_id]
    cancer_abrv = abrv_dic[cancer_name]

    tmp = (name.split("-")[3])[:-1] #we get the Sample:  Tumor types range from 01 - 09, normal types from 10 - 19
    if int(tmp) <= 9 :
        tumor = True
    else:
        tumor = False

    if tumor:
        if cancer_abrv not in dic_files_cancer:
            dic_files_cancer[cancer_abrv] = [name]
        else:
            dic_files_cancer[cancer_abrv].append(name)
    else:
        list_files_normal.append(name[:12])
    
for key,val in dic_files_cancer.items():
    df = pd.DataFrame(index=index_genes)

    for filename in val:
        with open("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/renamed/"+filename+"_RNA_Gene_Counts.tsv") as file:
            for line in file:
                if "ENSG" in line.strip().split("\t")[0] and "_PAR_Y" not in line.strip().split("\t")[0]:
                    df.at[(line.strip().split("\t")[0]).split(".")[0], filename] = line.strip().split("\t")[3]
    
    df.to_csv("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/bilan_files/only_tumor/"+key+"_TumorGeneCounts.tsv",sep="\t",header=True,index=True)

### For samples with matching normal tissues 
dic_files_normal_cancer = {}

for name in list_file_gene_count:
    if name[:12] in list_files_normal:
        cancer_id = name.split("-")[1] #we get the Tissue Source Site in the tumor barcode number 
        cancer_name = tiss_dic[cancer_id]
        cancer_abrv = abrv_dic[cancer_name]

        if cancer_abrv not in dic_files_normal_cancer:
            dic_files_normal_cancer[cancer_abrv] = [name]
        else:
            dic_files_normal_cancer[cancer_abrv].append(name)

for key,val in dic_files_normal_cancer.items():
    df = pd.DataFrame(index=index_genes)
    for filename in val:
        with open("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/renamed/"+filename+"_RNA_Gene_Counts.tsv") as file:
            if int((filename.split("-")[3])[:-1]) <= 9 :
                name_file = filename+"_T"
            else:
                name_file = filename+"_NS"

            for line in file:
                if "ENSG" in line.strip().split("\t")[0] and "_PAR_Y" not in line.strip().split("\t")[0]:
                    df.at[(line.strip().split("\t")[0]).split(".")[0], name_file] = line.strip().split("\t")[3]

    df.to_csv("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/bilan_files/tumor_and_normalTissues/"+key+"_TumorAndNS_GeneCounts.tsv",sep="\t",header=True,index=True)


