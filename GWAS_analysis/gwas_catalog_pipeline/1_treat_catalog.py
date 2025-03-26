import pandas as pd 
from pathlib import Path

# CHR_ID*: Chromosome number associated with rs number   11 field (12 in file)
# CHR_POS*: Chromosomal position associated with rs number 12 field (13 in file)
# SNPS*: Strongest SNP; if a haplotype it may include more than on rs number (multiple SNPs comprising the haplotype) 21 field (22 in file)

dic_parent_trait = {}
with open("/home/mouren/Data/variants/gwas/ld_pipe/dic_traits_to_parents_gwas.tsv") as file:
    for line in file:           
        dic_parent_trait[line.strip().split("\t")[0]] = line.strip().split("\t")[1]


file = Path("/home/mouren/Data/variants/gwas/ld_pipe/gwas_catalog_v1.0.2-associations_e113_r2025-02-18.tsv")

content=[]
gwas_lead_snps = []
dic_efo_traits = []
with open(file) as f:
    first = False
    for line in f:   
        row = line.strip().split("\t")
        
        if first == False:
            content.append(row)
            first = True
            continue
        
        if row[11] == "" or row[12] == "" or " x " in row[11] or row[21] == "": #No CHR or POS;  (SNP x SNP interaction); No rsID
            continue

        content.append(row)

        if ";" in row[11]: 
            chr = row[11].split(";")
            rs = row[21].split(";")
            type = row[24].split(";")
            
            max_length = max(len(chr), len(rs))
            chr_extended = chr + ["NA"] * (max_length - len(chr))
            rs_extended = rs + ["NA"] * (max_length - len(rs))
            type_extended = type + ["NA"] * (max_length - len(type))

            for i,j,y in zip(chr_extended,rs_extended,type_extended):
                if i !="NA" and j!="NA" and "x" not in j: #avoid rsid x rsid
                    gwas_lead_snps.append([i.strip(),j.strip()])
                    try:
                        parent_trait = dic_parent_trait[row[35].split("/")[-1]]
                    except KeyError:
                        parent_trait = "None"
                    dic_efo_traits.append([j.strip(),y.strip(),row[34],row[35].split("/")[-1],parent_trait]) #rsid, trait, EFO id, parent trait
        else:
            if "x" not in row[21]:#avoid rsid x rsid
                gwas_lead_snps.append([row[11],row[21]])
                try:
                    parent_trait = dic_parent_trait[row[35].split("/")[-1]]
                except KeyError:
                    parent_trait = "None"
                dic_efo_traits.append([row[21].strip(),row[24].strip(),row[34],row[35].split("/")[-1],parent_trait])

df = pd.DataFrame(content)
df.to_csv("/home/mouren/Data/variants/gwas/ld_pipe/gwas_catalog_v1.0.2-associations_clean.tsv",sep="\t",header=False,index=False)

df_dic = pd.DataFrame(dic_efo_traits)
df_dic = df_dic.drop_duplicates()
df_dic.to_csv("/home/mouren/Data/variants/gwas/ld_pipe/dic_rsId_traits.tsv",sep="\t",header=False,index=False)

### create lead snps files for plink
df2 = pd.DataFrame(gwas_lead_snps)
df2 = df2.drop_duplicates() #remove duplicates

grouped = df2.groupby(df2.columns[0])

for key_value, subdf in grouped: # key_value is the unique value in col0; # subdf is the subset of rows where col0 == key_value
    filename = f"/home/mouren/Data/variants/gwas/ld_pipe/lead_snps_chr{key_value}.txt"

    # Extract the column 1 values
    col1_values = subdf.iloc[:, 1]  # or subdf["column_name"] if named

    with open(filename, "w") as f:
        for val in col1_values:
            f.write(str(val) + "\n")