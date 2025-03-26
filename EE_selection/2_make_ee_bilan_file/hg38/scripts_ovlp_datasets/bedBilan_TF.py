###
# To be call by the bash script to make the ovlp TF exons bilan catalog
###
from pathlib import Path
import pandas as pd
from collections import Counter
import sys

file = Path(sys.argv[1])

# We first take all tf and cells lines mapping on a gene 
dico = {}
with open(file) as f:
    for line in f:
        gene = line.strip().split()[3]
        tf = line.strip().split()[12]

        tf_name = tf.split(":")[0]
        cell_lines = tf.split(":")[1]
        cell_lines_list = cell_lines.split(",")

        if gene not in dico:
            dico[gene] = {"TF":[tf_name],"cell_lines":cell_lines_list,}
            
        else:
            dico[gene]["TF"].append(tf_name)
            for i in cell_lines_list:
                dico[gene]["cell_lines"].append(i)

#print(dico)


#we now create a dict with the names of tf and occurences in second field same thing for cell lines
df_list = []
cpt = 1
for key,value in dico.items():
    new_row = {"gene":"","tf":"","tf_count":"","cell_lines":"","cell_lines_count":""}
    new_row["gene"] = key

    cpt2 = 0
    for key2,value2 in value.items():
        count_obj = Counter(value2) # Counter gives the frequency of every item in a list by returning a dict

        for key3,value3 in count_obj.items():
            if cpt2 == 0:
                new_row["tf"] += key3+","
                new_row["tf_count"] += str(value3)+","

            if cpt2 == 1:
                new_row["cell_lines"] += key3+","
                new_row["cell_lines_count"] += str(value3)+","
                       
        cpt2 +=1

    new_row["tf"] = new_row["tf"].strip(',')
    new_row["tf_count"] = new_row["tf_count"].strip(',')
    new_row["cell_lines"] = new_row["cell_lines"].strip(',')
    new_row["cell_lines_count"] = new_row["cell_lines_count"].strip(',')

    df_list.append(new_row)

df = pd.DataFrame(df_list)
            
df.to_csv('tf_cell_count.csv', sep='\t', index=False, header=False)