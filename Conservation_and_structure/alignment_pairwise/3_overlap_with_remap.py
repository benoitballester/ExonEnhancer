# to be called by overlap_with_remap.sh
import pandas as pd 
import sys 

file = sys.argv[1]

content = []
with open(file, 'r') as f :
    for line in f:
        content.append(line.strip().split())

df = pd.DataFrame(content)

df[1] = pd.to_numeric(df[1])
df[2] = pd.to_numeric(df[2])
df[5] = pd.to_numeric(df[5])
df[6] = pd.to_numeric(df[6])

grouped_df = df.groupby(3)

contentf= []
for group_name, group_data in grouped_df:
    
    found = False
    for index, row in group_data.iterrows():
        if row[5] == row[1] and row[6] == row[2]:
            contentf.append([row[4],row[5],row[6],row[7]])
            found = True
            break

    if found:
        continue
    
    pb_diff = 0
    closest = []
    for index, row in group_data.iterrows():
        if not closest:
            closest = [row[4],row[5],row[6],row[7]]
            pb_diff = abs(row[1]-row[5])+abs(row[2]-row[6])
        else:
            row_pb_diff  = abs(row[1]-row[5])+abs(row[2]-row[6])
            if row_pb_diff < pb_diff:
                closest = [row[4],row[5],row[6],row[7]]
    
    contentf.append(closest)
    
df_f = pd.DataFrame(contentf)

df_f.to_csv("tmp_data",sep="\t",header=False,index=False)

        