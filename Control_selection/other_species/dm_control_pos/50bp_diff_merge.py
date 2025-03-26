import pandas as pd
import sys

# Overlap formula 
"""
pb_diff=abs(a1-b1)+abs(a2-b2)

a_perc=(overlap*100)/a_size
b_perc=(overlap*100)/b_size
"""

### Calculate results
file_ovlp = sys.argv[1]

content = []
with open(file_ovlp)as f:
    for line in f:
        content.append(line.strip().split())

df = pd.DataFrame(content)

df[1] = pd.to_numeric(df[1])
df[2] = pd.to_numeric(df[2])
df[5] = pd.to_numeric(df[5])
df[6] = pd.to_numeric(df[6])

df['Original_Order'] = range(len(df)) #Get original order of dataframe
grouped_df = df.groupby([3]) #Group by enh id
grouped_df = sorted(grouped_df, key=lambda x: x[1]['Original_Order'].iloc[0]) #Sort the group by the original order

merged_enh_list = [] #one list storing all enh ever merged to be quicker than iterating through all values in dictionnary
merged_enh = {}
new_start = {}
new_end = {}
for group_name, group_df in grouped_df:
    
    if group_name[0] in merged_enh_list:
        continue
    else:
        double_merge_key = 0 #if the enh A can overlap with enh B but not with C, while B can overlap with C (sizes differences) 
        for i in list(group_df[7]):
            if i in merged_enh_list:
                line_df = group_df[group_df[7] == i]
                if abs(int(line_df[5])-list(group_df[1])[0])+abs(int(line_df[6])-list(group_df[2])[0]) <= 50: #We check if C and B are mergeable in terms of pb_diff
                    for key,value_list in merged_enh.items(): #We find A with merged B    
                        if i in value_list:
                            double_merge_key = key
                            break 
                    break     

        id_to_merge = []
        min_start = list(group_df[1])[0]
        max_end = list(group_df[2])[0]

        for rows_index, rows in group_df.iterrows():
            if rows[3] == rows[7]: #remove self overlap
                continue

            pb_diff = abs(rows[1]-rows[5])+abs(rows[2]-rows[6])
            if pb_diff <= 50:
                id_to_merge.append(rows[7])
                merged_enh_list.append(rows[7])

                if rows[5] < min_start:
                    min_start = rows[5]
                if rows[6] > max_end:
                    max_end = rows[6]

        if double_merge_key != 0:
            for i in id_to_merge:
                if i not in merged_enh[double_merge_key]:
                    merged_enh[double_merge_key].append(i)
            if min_start < new_start[double_merge_key]:
                new_start[double_merge_key] = min_start
            if max_end > new_end[double_merge_key]:
                new_end[double_merge_key] = max_end
        else:            
            merged_enh[group_name[0]] = id_to_merge
            new_start[group_name[0]] = min_start
            new_end[group_name[0]] = max_end

### Write results
file_exact_merge = sys.argv[2]

content = []
with open(file_exact_merge)as f:
    for line in f:
        entry = line.strip().split()

        if entry[3] not in merged_enh: #if not in dictionnary, it has been merged
            continue
        else:
            if merged_enh[entry[3]] == []: #check if enh has a 50pb merge
                pass
            else:
                entry[1] = new_start[entry[3]]
                entry[2] = new_end[entry[3]]
        
            content.append(entry)

df_f = pd.DataFrame(content)
df_f.to_csv("/home/mouren/Data/final_files_tokeep/other_species/control/"+file_ovlp+"_treated",header=False,index=False,sep="\t")
