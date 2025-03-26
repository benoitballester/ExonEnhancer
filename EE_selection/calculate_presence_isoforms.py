### MAKE FILES HG38 TLS1
import pandas as pd

dic={}
with open("/home/mouren/Data/final_files_tokeep/gencode/raw/list_transript_gene_id_gencodeV41_tls1.tsv") as file:
    for line in file:           
        dic[line.strip().split()[0]] = line.strip().split()[1]

dic_nb={}
with open("/home/mouren/Data/final_files_tokeep/gencode/raw/nb_transcrit_per_genes_v41_tls1.txt") as file:
    for line in file:           
        dic_nb[line.strip().split()[1]] = line.strip().split()[0]

### EE
content=[]
with open("/home/mouren/Data/final_files_tokeep/gencode/raw/overlap_ee_all_exons") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    gene_ee = dic[group_name.split("_")[0]]
    
    for index, row in group_data.iterrows():
        try:
            if dic[row[7].split("_")[0]] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a tls1
            continue

    entry = [group_name, counter_presence, dic_nb[gene_ee], (counter_presence*100)/int(dic_nb[gene_ee])]
    res.append(entry)

df2 = pd.DataFrame(res)

df2.to_csv("/home/mouren/Data/final_files_tokeep/gencode/raw/ee_abundance_hg38.tsv",sep="\t",header=False,index=False)

### CTRL NEG
content=[]
with open("/home/mouren/Data/final_files_tokeep/gencode/raw/overlap_ctrlneg_all_exons") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    gene_ee = dic[group_name.split("_")[0]]
    
    for index, row in group_data.iterrows():
        try:
            if dic[row[7].split("_")[0]] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a tls1
            continue

    entry = [group_name, counter_presence, dic_nb[gene_ee], (counter_presence*100)/int(dic_nb[gene_ee])]
    res.append(entry)

df2 = pd.DataFrame(res)
df2.to_csv("/home/mouren/Data/final_files_tokeep/gencode/raw/neg_abundance_hg38.tsv",sep="\t",header=False,index=False)


### MAKE FILES MM39
dic={}
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/mm39/raw/mm39_codingtranscript_geneid.tsv") as file:
    for line in file:           
        dic[line.strip().split()[1]] = line.strip().split()[0]

dic_nb={}
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/mm39/raw/nb_transcript_coding_per_gene_mm39.txt") as file:
    for line in file:           
        dic_nb[line.strip().split()[1]] = line.strip().split()[0]

import pandas as pd

### EE
content=[]
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/mm39/raw/ovlp_ee_all") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    try:
        gene_ee = dic[group_name.split("_")[0]]
    except KeyError: #not protein_coding/no_data in emsembl . but in ucsc is protein coding
        continue
    
    for index, row in group_data.iterrows():
        try:
            if dic[row[7].split("_")[0]] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a protein coding 
            continue

    entry = [group_name, counter_presence, dic_nb[gene_ee], (counter_presence*100)/int(dic_nb[gene_ee])]
    res.append(entry)

df2 = pd.DataFrame(res)

df2.to_csv("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/mm39/raw/ee_abundance_mm39.tsv",sep="\t",header=False,index=False)

### CTRL
content=[]
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/mm39/raw/ovlp_ctrlneg_all") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    try:
        gene_ee = dic[group_name.split("_")[0]]
    except KeyError: #not protein_coding/no_data in emsembl . but in ucsc is protein coding
        continue
    
    for index, row in group_data.iterrows():
        try:
            if dic[row[7].split("_")[0]] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a protein coding 
            continue

    entry = [group_name, counter_presence, dic_nb[gene_ee], (counter_presence*100)/int(dic_nb[gene_ee])]
    res.append(entry)

df2 = pd.DataFrame(res)

df2.to_csv("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/mm39/raw/neg_abundance_mm39.tsv",sep="\t",header=False,index=False)


### DM6 and TAIR10 files
# awk '{print $2}' dm6_transcrit_genes_protein_coding |sort |uniq -c > nb_transcript_coding_per_gene_dm6.txt
# cut -d. -f1 tair10_protein_coding_id_list.txt |sort |uniq -c > nb_transcript_coding_per_gene_tair10.txt

# awk '{print $1,$2,$3,$4}' OFS=$'\t' ~/Data/final_files_tokeep/other_species/dm6_EE.bed > dm_ee
# awk '{print $1,$2,$3,$4}' OFS=$'\t' ~/Data/final_files_tokeep/other_species/control/dm6_control_neg_NoTF_NoTSS_TES.tsv > dm_neg

# awk '{print $1,$2,$3,$4}' OFS=$'\t' ~/Data/final_files_tokeep/other_species/tair10_EE_nochr.bed > tair_ee
# awk '{print $1,$2,$3,$4}' OFS=$'\t' ~/Data/final_files_tokeep/other_species/control/tair10_control_neg_NoTF_NoTSS_TES.tsv > tair_neg
# cut -c 4- tair_neg > tair_neg_nochr

# bedtools intersect -a tair_ee -b ../merge/tair10_CodingExons_protein_coding.tsv -wa -wb > ovlp_ee_all_tair
# bedtools intersect -a tair_neg_nochr -b ../merge/tair10_CodingExons_protein_coding.tsv -wa -wb > ovlp_neg_all_tair

# bedtools intersect -a dm_ee -b ../merge/dm6_CodingExons_protein_coding.tsv -wa -wb > ovlp_ee_all_dm
# bedtools intersect -a dm_neg -b ../merge/dm6_CodingExons_protein_coding.tsv -wa -wb > ovlp_neg_all_dm

import pandas as pd

###### DM
dic_gene_dm={}
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/dm6/raw/dm6_transcrit_genes_protein_coding") as file:
    for line in file:           
        dic_gene_dm[line.strip().split()[0]] = line.strip().split()[1]

dic_nb_dm={}
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/dm6/raw/nb_transcript_coding_per_gene_dm6.txt") as file:
    for line in file:           
        dic_nb_dm[line.strip().split()[1]] = line.strip().split()[0]

### EE
content=[]
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/dm6/raw/ovlp_ee_all_dm") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    try:
        gene_ee = dic_gene_dm[group_name.split("_")[0]]
    except KeyError: #not protein_coding/no_data in emsembl . but in ucsc is protein coding
        continue
    
    for index, row in group_data.iterrows():
        try:
            if dic_gene_dm[row[7].split("_")[0]] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a protein coding 
            continue

    entry = [group_name, counter_presence, dic_nb_dm[gene_ee], (counter_presence*100)/int(dic_nb_dm[gene_ee])]
    res.append(entry)

df2 = pd.DataFrame(res)

df2.to_csv("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/dm6/raw/ee_abundance_dm6.tsv",sep="\t",header=False,index=False)

### NEG
content=[]
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/dm6/raw/ovlp_neg_all_dm") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    try:
        gene_ee = dic_gene_dm[group_name.split("_")[0]]
    except KeyError: #not protein_coding/no_data in emsembl . but in ucsc is protein coding
        continue
    
    for index, row in group_data.iterrows():
        try:
            if dic_gene_dm[row[7].split("_")[0]] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a protein coding 
            continue

    entry = [group_name, counter_presence, dic_nb_dm[gene_ee], (counter_presence*100)/int(dic_nb_dm[gene_ee])]
    res.append(entry)

df2 = pd.DataFrame(res)

df2.to_csv("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/dm6/raw/neg_abundance_dm6.tsv",sep="\t",header=False,index=False)

###### TAIR
dic_gene_tair=[]
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/tair10/raw/tair10_protein_coding_id_list.txt") as file:
    for line in file:           
        dic_gene_tair.append(line.strip().split()[0])

dic_nb_tair={}
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/tair10/raw/nb_transcript_coding_per_gene_tair10.txt") as file:
    for line in file:           
        dic_nb_tair[line.strip().split()[1]] = line.strip().split()[0]

### EE
content=[]
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/tair10/raw/ovlp_ee_all_tair") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    
    gene_ee = (group_name.split("_")[0]).split(".")[0]

    for index, row in group_data.iterrows():
        try:
            if row[7].split("_")[0] in dic_gene_tair and (row[7].split("_")[0]).split(".")[0] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a protein coding 
            continue

    entry = [group_name, counter_presence, dic_nb_tair[gene_ee.split(".")[0]], (counter_presence*100)/int(dic_nb_tair[gene_ee.split(".")[0]])]
    res.append(entry)

df2 = pd.DataFrame(res)

df2.to_csv("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/tair10/raw/ee_abundance_tair10.tsv",sep="\t",header=False,index=False)

### NEG
content=[]
with open("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/tair10/raw/ovlp_neg_all_tair") as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

res = [["Exons","Presence_count","Total_gene_transcripts","Abundance"]]
for group_name, group_data in grouped_df:
    used = []
    counter_presence = 0
    
    gene_ee = (group_name.split("_")[0]).split(".")[0]

    for index, row in group_data.iterrows():
        try:
            if row[7].split("_")[0] in dic_gene_tair and (row[7].split("_")[0]).split(".")[0] == gene_ee and row[7].split("_")[0] not in used:
                used.append(row[7].split("_")[0])
                counter_presence += 1  
        except KeyError: #not a protein coding 
            continue

    entry = [group_name, counter_presence, dic_nb_tair[gene_ee.split(".")[0]], (counter_presence*100)/int(dic_nb_tair[gene_ee.split(".")[0]])]
    res.append(entry)

df2 = pd.DataFrame(res)

df2.to_csv("/home/mouren/Data/article_repo_data/EE_selection/other_species/data/gencode/tair10/raw/neg_abundance_tair10.tsv",sep="\t",header=False,index=False)