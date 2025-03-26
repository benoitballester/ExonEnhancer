import pandas as pd
import math
import sys

### Both
file = "/home/mouren/Data/variants/tcga_MC3/fabian/fabian_precise_bilan_JasparFilter_score.tsv"
#file = "/home/mouren/Data/variants/tcga_MC3/fabian/fabian_precise_bilan_eqtlHiC_RemapJasparFilter_score.tsv"

snp_list = []
df = pd.read_csv(file,sep='\t')
for column in df:
    if column == "Unnamed: 0":
                continue
    val = df[column].tolist()
    filtered_list = [x for x in val if x != 0.0]
    filtered_list.insert(0, column.split('.')[0])
    snp_list.append(filtered_list)
tmp = []
for list in snp_list:
    entry = []
    for val in list:
        if isinstance(val, float) == False:
                entry.append(val)
        else:
                if math.isnan(float(val)) == True:
                        continue
                else:
                        entry.append(val)
    tmp.append(entry)
cleaned_list_of_lists = []
for list in tmp:
    if len(list) <= 1:
        continue
    else:
        cleaned_list_of_lists.append(list)

df_snp = pd.DataFrame(cleaned_list_of_lists)
df_snp.to_csv("/home/mouren/Data/variants/tcga_MC3/fabian/fabian_precise_snp_tcga_full_list_onlyJaspar.tsv",sep='\t',header=False,index=False)
#df_snp.to_csv("/home/mouren/Data/variants/tcga_MC3/fabian/fabian_precise_snp_tcga_full_list_RemapJaspar.tsv",sep='\t',header=False,index=False)
