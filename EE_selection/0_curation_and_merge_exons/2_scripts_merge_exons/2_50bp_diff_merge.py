import pandas as pd
import sys
# ls | awk '{print $1}' | xargs -P 18 -n 1 python ../../../../../../../repoexonhancer/other_species/prep_and_merge/2_scripts_merge_exons/2_50bp_diff_merge.py

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
df[8] = pd.to_numeric(df[8])
df[9] = pd.to_numeric(df[9])

df['Original_Order'] = range(len(df)) #Get original order of dataframe
grouped_df = df.groupby([3]) #Group by exon id
grouped_df = sorted(grouped_df, key=lambda x: x[1]['Original_Order'].iloc[0]) #Sort the group by the original order

merged_exons_list = [] #one list storing all exons ever merged to be quicker than iterating through all values in dictionnary
merged_exons = {}
new_start = {}
new_end = {}
for group_name, group_df in grouped_df:
    
    if group_name[0] in merged_exons_list:
        continue
    else:
        double_merge_key = 0 #if the exon A can overlap with exon B but not with C, while B can overlap with C (sizes differences) 
        for i in list(group_df[10]):
            if i in merged_exons_list:
                line_df = group_df[group_df[10] == i]
                if abs(int(line_df[8])-list(group_df[1])[0])+abs(int(line_df[9])-list(group_df[2])[0]) <= 50: #We check if C and B are mergeable in terms of pb_diff
                    for key,value_list in merged_exons.items(): #We find A with merged B    
                        if i in value_list:
                            double_merge_key = key
                            break 
                    break     

        id_to_merge = []
        min_start = list(group_df[1])[0]
        max_end = list(group_df[2])[0]

        for rows_index, rows in group_df.iterrows():
            if rows[3] == rows[10]: #remove self overlap
                continue

            pb_diff = abs(rows[1]-rows[8])+abs(rows[2]-rows[9])
            if pb_diff <= 50:
                id_to_merge.append(rows[10])
                merged_exons_list.append(rows[10])

                if rows[8] < min_start:
                    min_start = rows[8]
                if rows[9] > max_end:
                    max_end = rows[9]

        if double_merge_key != 0:
            for i in id_to_merge:
                if i not in merged_exons[double_merge_key]:
                    merged_exons[double_merge_key].append(i)
            if min_start < new_start[double_merge_key]:
                new_start[double_merge_key] = min_start
            if max_end > new_end[double_merge_key]:
                new_end[double_merge_key] = max_end
        else:            
            merged_exons[group_name[0]] = id_to_merge
            new_start[group_name[0]] = min_start
            new_end[group_name[0]] = max_end

### Write results
#file_exact_merge = "coding_exons_exact_merge_tair10.bed"
#file_exact_merge = "merge/coding_exons_exact_merge_dm6.bed"
file_exact_merge = "coding_exons_exact_merge_mm39.bed"

content = []
with open(file_exact_merge)as f:
    for line in f:
        entry = line.strip().split()

        if entry[3] not in merged_exons: #if not in dictionnary, it has been merged
            continue
        else:
            #First check if it has been merged with 100% similarity
            if len(entry) == 7:
                entry.append("None")

            if merged_exons[entry[3]] == []: #check if exon has a 50pb merge
                entry.append("None")
            else:
                entry.append(";".join(merged_exons[entry[3]]))
                entry[1] = new_start[entry[3]]
                entry[2] = new_end[entry[3]]
        
            content.append(entry)

df_f = pd.DataFrame(content)
#df_f.to_csv("treated_"+file_ovlp,header=False,index=False,sep="\t")
#df_f.to_csv("treated_"+file_ovlp,header=False,index=False,sep="\t")
df_f.to_csv("treated_"+file_ovlp,header=False,index=False,sep="\t")
