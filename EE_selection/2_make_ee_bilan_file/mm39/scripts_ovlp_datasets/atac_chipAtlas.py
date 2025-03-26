#dnase encode
from pathlib import Path
import pandas as pd
import sys

### Dic encode ID to cell line
file = Path(sys.argv[2])
dic_atlas_cell={}
with open(file) as file:
    for line in file:            
        dic_atlas_cell[line.strip().split()[0]] = line.strip().split()[1]

### Treat overlap file
file = Path(sys.argv[1])

content=[]
with open(file) as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(0)

exons_cell_dic = {}
exons_nbPeak = {}
exons_idList = {}

for group_name, group_data in grouped_df:
    cell_dic = {}
    id_list = []
    nb_peak = 0

    for index, row in group_data.iterrows():
        nb_peak += 1

        if row[1] not in id_list:
            id_list.append(row[1])
        try:
            if dic_atlas_cell[row[1]] not in cell_dic:
                cell_dic[dic_atlas_cell[row[1]]] = int(row[2])
        except Exception:
            continue
        else:
            if int(row[2]) > cell_dic[dic_atlas_cell[row[1]]]:
                cell_dic[dic_atlas_cell[row[1]]] = int(row[2])
    

    if group_name not in exons_cell_dic:
        exons_nbPeak[group_name] = nb_peak 
        exons_cell_dic[group_name] = cell_dic    
        exons_idList[group_name] = id_list 
    else:
        print("Problem")
        break
    
new_content = []
for key,value in exons_cell_dic.items():
    entry = [key]
    entry.append(exons_nbPeak[key])
    entry.append((",").join(map(str, exons_cell_dic[key].keys())))
    entry.append((",").join(map(str, exons_cell_dic[key].values())))
    entry.append((",").join(exons_idList[key]))

    new_content.append(entry)    

new_df = pd.DataFrame(new_content)

new_df.to_csv("tmp",index=False,header=False,sep="\t")