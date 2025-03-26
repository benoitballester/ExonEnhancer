#dnase encode
from pathlib import Path
import pandas as pd
import sys

### Dic encode ID to cell line
file = Path(sys.argv[2])
dic_encode_cell={}
with open(file, encoding = "ISO-8859-1") as f:
    for line in f:   
        try:     
            if line.strip().split("\t")[1] not in dic_encode_cell:     
                dic_encode_cell[(line.strip().split("\t")[1]).strip()] = (("_").join((line.strip().split("\t")[3]).split())).strip()
        except IndexError:#end of file
            continue

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
    list_cells = {}
    for index, row in group_data.iterrows():
        for bio in row[14].split(';'):
            id = dic_encode_cell[bio.strip()]

            if id not in list_cells:
                list_cells[id] = 1
            else:
                list_cells[id] += 1

              
    if group_name not in exons_cell_dic:
        exons_cell_dic[group_name] = list_cells    
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

new_df.to_csv("tmp",index=False,header=False,sep="\t")