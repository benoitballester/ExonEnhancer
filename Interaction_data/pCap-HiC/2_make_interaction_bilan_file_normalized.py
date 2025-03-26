import pandas as pd

### Data and functions
# Get dictionnary of cells lines 
cells_dic={}
with open("/home/mouren/Data/article_repo_data/Interaction_data/pCap-HiC/raw/cells_lines_dic_TableS1.tsv") as file:
    for line in file:            
        cells_dic[line.strip().split('\t')[0]] = line.strip().split('\t')[1]

def compute_interaction(df):
    grouped_df = df.groupby(3)

    content = [["ExonID", "B lymphocytes","cardiomyocytes","embryonic stem cells","endothelial precursors","erythroblasts","fetal thymus","hematopoietic progenitors","keratinocytes",
        "lymphoblastoid cell line","macrophages","megakaryocytes","monocytes","neuroepithelial cells","neutrophils","pre-adipocytes","T lymphocytes","embryonic stem cells, Nanog KO",
        "epiblast stem cells","ES-derived hematopoietic progenitors","fetal liver","trophoblast stem cells"]]

    for group_name, group_data in grouped_df:
        cells =  {"B lymphocytes": "0","cardiomyocytes": "0","embryonic stem cells": "0","endothelial precursors": "0","erythroblasts": "0","fetal thymus": "0","hematopoietic progenitors": "0",
        "keratinocytes": "0","lymphoblastoid cell line": "0","macrophages": "0","megakaryocytes": "0","monocytes": "0","neuroepithelial cells": "0","neutrophils": "0","pre-adipocytes": "0",
        "T lymphocytes": "0","embryonic stem cells, Nanog KO": "0","epiblast stem cells": "0","ES-derived hematopoietic progenitors": "0","fetal liver": "0","trophoblast stem cells": "0",}

        for index, row in group_data.iterrows():
            gene_list = []
            
            for gene in row[14].split(","):
                if gene != "NA" and gene != "":
                    gene_list.append(gene)

            list_cells_exons = []
            for cell_id in row[13].split(","):
                if cells_dic[cell_id] not in list_cells_exons:
                    list_cells_exons.append(cells_dic[cell_id])
                else:
                    continue

            for i in list_cells_exons:
                if gene_list:
                    if cells[i] == "0":
                        cells[i] = gene_list
                    else:
                        for aaa in gene_list:
                            if aaa not in cells[i]:
                                cells[i].append(aaa)

        entry = [group_name]
        for key,value in cells.items():
            entry.append((",").join(map(str, value)))
        
        content.append(entry)

    df1 = pd.DataFrame(content)
    return(df1)

######## Compute
### Iterate on interaction file
content = []
with open("/home/mouren/Data/article_repo_data/Interaction_data/pCap-HiC/promHiC_allEE_interactions.tsv") as f: 
    for line in f:
        content.append(line.strip().split("\t"))
df_ee = pd.DataFrame(content)

df_ee_f = compute_interaction(df_ee)
df_ee_f.to_csv("/home/mouren/Data/article_repo_data/Interaction_data/pCap-HiC/bilan_promHiC_EE_allInteractions_normalized.tsv",sep="\t",header=False,index=False)


content = []
with open("/home/mouren/Data/article_repo_data/Interaction_data/pCap-HiC/promHiC_allctrlneg_interactions.tsv") as f: 
    for line in f:
        content.append(line.strip().split("\t"))
df_neg = pd.DataFrame(content)

df_neg_f = compute_interaction(df_neg)
df_neg_f.to_csv("/home/mouren/Data/article_repo_data/Interaction_data/pCap-HiC/bilan_promHiC_neg_allInteractions_normalized.tsv",sep="\t",header=False,index=False)        
        
        
content = []
with open("/home/mouren/Data/article_repo_data/Interaction_data/pCap-HiC/promHiC_allctrlpos_interactions.tsv") as f: 
    for line in f:
        content.append(line.strip().split("\t"))
df_pos = pd.DataFrame(content)

df_pos_f = compute_interaction(df_pos)
df_pos_f.to_csv("/home/mouren/Data/article_repo_data/Interaction_data/pCap-HiC/bilan_promHiC_pos_allInteractions_normalized.tsv",sep="\t",header=False,index=False)        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        



        

