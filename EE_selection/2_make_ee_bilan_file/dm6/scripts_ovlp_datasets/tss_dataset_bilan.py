###
# To be call by the bash script to make the Fantom bilan with ovlp TF on exons bilan AND CCRES catalog
###
from pathlib import Path
import pandas as pd
import copy
import sys

file = Path(sys.argv[1])

# We first take all tf and cells lines mapping on a gene 
df_list = []
first = True
with open(file) as f:
    lines = f.readlines()
    last = lines[-1]

    old_row = {"Chrom":"","Start":"","End":"","Exon_ID":"","Score":"","Strand":"", 'Size':"", "Size_merge":"", 'Exact_merge':"", "50pb_merge":"","fantom_id":""}

    for line in lines:
        
        fantom_id = line.strip().split()[13]
        try:
            fantom_ts = line.strip().split()[19]
        except IndexError:
            fantom_ts = "NA"

        if first == True: #if first line of file
            first = False
            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "fantom_id":
                    old_row[key] = fantom_id
                elif key == "fantom_ts":
                    old_row[key] = fantom_ts
                else:
                    old_row[key] = values_list[cpt]

                cpt +=1

            continue

        # Check if new row is the same exon as before 
        chrom = line.strip().split()[0]
        start = line.strip().split()[1]
        end = line.strip().split()[2]
        gene = line.strip().split()[3]

        if chrom == old_row["Chrom"] and start == old_row["Start"] and end == old_row["End"] and gene == old_row["Exon_ID"]:
            old_row["fantom_id"] = old_row["fantom_id"]+","+fantom_id

            if line is last:
                df_list.append(copy.deepcopy(old_row))
            
            continue

        else:
            df_list.append(copy.deepcopy(old_row))

            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "fantom_id":
                    old_row[key] = fantom_id
                elif key == "fantom_ts":
                    old_row[key] = fantom_ts
                else:
                    old_row[key] = values_list[cpt]

                cpt +=1

            if line is last:
                df_list.append(copy.deepcopy(old_row))


df = pd.DataFrame(df_list)

df.to_csv('tmp', sep='\t', index=False, header=False)