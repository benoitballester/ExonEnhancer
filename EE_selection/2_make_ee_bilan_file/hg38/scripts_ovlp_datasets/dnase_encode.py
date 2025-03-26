#dnase encode
from pathlib import Path
import pandas as pd
import sys

### Dic encode ID to cell line
file = Path(sys.argv[2])
dic_encode_cell={}
with open(file) as file:
    for line in file:            
        dic_encode_cell[line.strip().split()[0]] = line.strip().split()[1]

### Treat overlap file
file = Path(sys.argv[1])

content=[]
with open(file) as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(3)

exons_cell_dic = {}
for group_name, group_data in grouped_df:
    cell_dic = {}
    for index, row in group_data.iterrows():
        for id in range(len(row[10].split(','))):
            try:
                if dic_encode_cell[row[10].split(',')[id]] not in cell_dic:
                    cell_dic[dic_encode_cell[row[10].split(',')[id]]] = int(row[11].split(',')[id])
                else:
                    if int(row[11].split(',')[id]) > cell_dic[dic_encode_cell[row[10].split(',')[id]]]:
                        cell_dic[dic_encode_cell[row[10].split(',')[id]]] = int(row[11].split(',')[id])
            except KeyError:
                continue
    
    if group_name not in exons_cell_dic:
        exons_cell_dic[group_name] = cell_dic    
    else:
        print("Problem")
        break
    
new_content = []
for key,value in exons_cell_dic.items():
    entry = [key]
    entry.append((",").join(map(str, exons_cell_dic[key].keys())))
    entry.append((",").join(map(str, exons_cell_dic[key].values())))

    new_content.append(entry)    

new_df = pd.DataFrame(new_content)

new_df.to_csv("dnase_result",index=False,header=False,sep="\t")