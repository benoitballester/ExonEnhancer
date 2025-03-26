import pandas as pd
from pathlib import Path
import numpy as np
import sys

file = sys.argv[1]

content = []
with open(file) as f:
    for line in f:
        content.append(line.strip().split())

df = pd.DataFrame(content)
df[9] = df[9].astype(int)


grouped_df = df.groupby(3)

#take the highest density position in exons and move around it
new_content = []
for group_name, group_data in grouped_df:
    max_row = group_data.loc[group_data[9].idxmax()]

    real_start = int(max_row[1])
    real_end = int(max_row[2])

    if int(max_row[7]) >= real_start and int(max_row[8]) <= real_end: 
        middle_density = round((int(max_row[8])+int(max_row[7]))/2)
    elif int(max_row[7]) < real_start and int(max_row[8]) <= real_end:
        middle_density = round((int(max_row[8])+real_start)/2)
    elif int(max_row[7]) >= real_start and int(max_row[8]) > real_end:
        middle_density = round((real_end+int(max_row[7]))/2)
    
    if middle_density < real_start or middle_density > real_end:
        print("problem density",group_name)
        
    size = 0
    trimmed_start = middle_density
    trimmed_end = middle_density
    while size < 220:
        trimmed_start -= 1
        trimmed_end += 1

        if trimmed_start < real_start:
            trimmed_start += 1
            trimmed_end += 1
        elif trimmed_end > real_end:
            trimmed_end -= 1
            trimmed_start -= 1

        size = trimmed_end-trimmed_start
    
    #Verify
    if trimmed_start < real_start or trimmed_end > real_end or size != 220:
        print("problem trimming")
        break
    
    new_content.append([max_row[0],trimmed_start,trimmed_end,group_name,max_row[4],max_row[5]]) 


df_2 = pd.DataFrame(new_content)
df_2.to_csv("/home/mouren/Data/valid_exp_starr/list_raw_v3/"+file+"_TrimmedSizes.tsv",sep="\t",header=False,index=False)



