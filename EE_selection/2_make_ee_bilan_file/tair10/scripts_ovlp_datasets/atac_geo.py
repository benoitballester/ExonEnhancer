#dnase encode
from pathlib import Path
import pandas as pd
import sys

### Treat overlap file
file = Path(sys.argv[1])

content=[]
with open(file) as file:
    for line in file:            
        content.append(line.strip().split())
df = pd.DataFrame(content)

grouped_df = df.groupby(0)

exons_cell_dic = {}
exons_nb_peaks = {}

for group_name, group_data in grouped_df:
    list_cells = {}
    cpt = 0
    for index, row in group_data.iterrows():
        cpt += 1
        if row[1] not in list_cells:
            list_cells[row[1]] = 1
        else:
            list_cells[row[1]] += 1

              
    if group_name not in exons_cell_dic:
        exons_cell_dic[group_name] = list_cells    
        exons_nb_peaks[group_name] = cpt
    else:
        print("Problem")
        break
    
new_content = []
for key,value in exons_cell_dic.items():
    entry = [key]
    entry.append(exons_nb_peaks[key])
    entry.append((",").join(map(str, exons_cell_dic[key].keys())))
    entry.append((",").join(map(str, exons_cell_dic[key].values())))

    new_content.append(entry)    

new_df = pd.DataFrame(new_content)

new_df.to_csv("tmp",index=False,header=False,sep="\t")