###
# To be call by the bash script to make the Fantom enhancer bilan with ovlp TF on exons bilan AND CCRES and fantom cage catalog and non coding
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

    old_row = {"Chrom":"","Start":"","End":"","Exon_ID":"","Score":"","Strand":"", 'Size':"", "Size_merge":"", 'Exact_merge':"", "50pb_merge":"","cds_end":""}

    for line in lines:
        # check if it was the cds
        cds_end = line.strip().split()[13]

        if first == True: #if first line of file
            first = False
            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "cds_end":
                    old_row[key] = cds_end
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
            old_row["cds_end"] = old_row["cds_end"]+","+cds_end

            if line is last:
                df_list.append(copy.deepcopy(old_row))
            
            continue

        else:
            df_list.append(copy.deepcopy(old_row))

            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "cds_end":
                    old_row[key] = cds_end
                else:
                    old_row[key] = values_list[cpt]

                cpt +=1

            if line is last:
                df_list.append(copy.deepcopy(old_row))


df = pd.DataFrame(df_list)

df.to_csv('tmp_tes', sep='\t', index=False, header=False)