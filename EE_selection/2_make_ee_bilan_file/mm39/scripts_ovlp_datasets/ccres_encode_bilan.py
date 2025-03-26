###
# To be call by the bash script to make the ENCODE ccres with ovlp TF on exons bilan catalog
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

    old_row = {"Chrom":"","Start":"","End":"","Exon_ID":"","Score":"","Strand":"", 'Size':"", "Size_merge":"", 'Exact_merge':"", "50pb_merge":"", "cCREs_ID":"","cCREs_labels":""}

    for line in lines:
        
        ccre_id = line.strip().split()[13]
        ccre_label = line.strip().split()[16]

        if first == True: #if first line of file
            first = False
            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "cCREs_ID":
                    old_row[key] = ccre_id
                elif key == "cCREs_labels":
                    old_row[key] = ccre_label
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
            old_row["cCREs_ID"] = old_row["cCREs_ID"]+","+ccre_id
            old_row["cCREs_labels"] = old_row["cCREs_labels"]+","+ccre_label

            if line is last:
                df_list.append(copy.deepcopy(old_row))
            
            continue

        else:
            df_list.append(copy.deepcopy(old_row))

            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "cCREs_ID":
                    old_row[key] = ccre_id
                elif key == "cCREs_labels":
                    old_row[key] = ccre_label
                else:
                    old_row[key] = values_list[cpt]

                cpt +=1

            if line is last:
                df_list.append(copy.deepcopy(old_row))


df = pd.DataFrame(df_list)

df.to_csv('tmp_ccre', sep='\t', index=False, header=False)