import pandas as pd

### Data and functions
# Get dictionnary of cells lines 
tissue_dic={}
with open("/home/mouren/Data/article_repo_data/Interaction_data/GTEx_eQTLs/raw/gTEXBiotypes_Cut_normalized.csv") as file:
    for line in file:            
        tissue_dic[line.strip().split('\t')[0]] = line.strip().split('\t')[1]

def compute_interaction(df):
    grouped_df = df.groupby(3)
    
    header = list(sorted(set(tissue_dic.values())))
    header.insert(0, "ExonID")

    content = [header]

    for group_name, group_data in grouped_df:
        ## create dictionnary 
        cells = {}
        for i in list(sorted(set(tissue_dic.values()))):
            cells[i] = []

        for index, row in group_data.iterrows():
            gene = row[10].split(".")[0]
            tissue = tissue_dic[(row[9].split("_")[0])]

            if gene not in cells[tissue]:
                cells[tissue].append(gene)
            else:
                continue

        entry = [group_name]
        for key,value in cells.items():
            if value:
                entry.append((",").join(map(str, value)))
            else:
                entry.append("0")
        
        content.append(entry)

    df1 = pd.DataFrame(content)
    return(df1)

######## Compute
### Iterate on interaction file
content = []
with open("/home/mouren/Data/article_repo_data/Interaction_data/GTEx_eQTLs/ee_overlap_gtexSNP.tsv") as f: 
    for line in f:
        content.append(line.strip().split("\t"))
df_ee = pd.DataFrame(content)

df_ee_f = compute_interaction(df_ee)
df_ee_f.to_csv("/home/mouren/Data/article_repo_data/Interaction_data/GTEx_eQTLs/bilan_GTExeQTLs_EE_normalized.tsv",sep="\t",header=False,index=False)


content = []
with open("/home/mouren/Data/article_repo_data/Interaction_data/GTEx_eQTLs/ctrlneg_overlap_gtexSNP.tsv") as f: 
    for line in f:
        content.append(line.strip().split("\t"))
df_neg = pd.DataFrame(content)

df_neg_f = compute_interaction(df_neg)
df_neg_f.to_csv("/home/mouren/Data/article_repo_data/Interaction_data/GTEx_eQTLs/bilan_GTExeQTLs_neg_normalized.tsv",sep="\t",header=False,index=False)        
        
        
content = []
with open("/home/mouren/Data/article_repo_data/Interaction_data/GTEx_eQTLs/ctrlpos_overlap_gtexSNP.tsv") as f: 
    for line in f:
        entry = line.strip().split("\t") #fix format 
        entry.insert(4, "0")
        entry.insert(5, ".")
        content.append(entry)
df_pos = pd.DataFrame(content)

df_pos_f = compute_interaction(df_pos)
df_pos_f.to_csv("/home/mouren/Data/article_repo_data/Interaction_data/GTEx_eQTLs/bilan_GTExeQTLs_pos_normalized.tsv",sep="\t",header=False,index=False)        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        



        

