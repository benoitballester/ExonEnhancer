###
# To be call by the bash script to make the Fantom enhancer bilan with ovlp TF on exons bilan AND CCRES and fantom cage catalog
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

    old_row = {"Chrom":"","Start":"","End":"","Exon_ID":"","Score":"","Strand":"", 'Size':"", "Size_merge":"", 'Exact_merge':"", "50pb_merge":"", "Nb_TF":"", "TF_list":"", "tf_count":"","cell_lines":"","cell_lines_count":"", "cCREs_ID":"","cCREs_labels":"","fantom_id":"","fantom_ts":"","fantom_enhancer":"", "noncoding_exon":""}

    for line in lines:
        
        noncoding_exon = line.strip().split()[24]
        noncoding_strand = line.strip().split()[23]

        if first == True: #if first line of file
            first = False
            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "noncoding_exon":
                    old_row[key] = noncoding_exon+";"+noncoding_strand
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
            old_row["noncoding_exon"] = old_row["noncoding_exon"]+","+noncoding_exon+";"+noncoding_strand

            if line is last:
                df_list.append(copy.deepcopy(old_row))
            
            continue

        else:
            df_list.append(copy.deepcopy(old_row))

            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "noncoding_exon":
                    old_row[key] = noncoding_exon+";"+noncoding_strand
                else:
                    old_row[key] = values_list[cpt]

                cpt +=1

            if line is last:
                df_list.append(copy.deepcopy(old_row))


df = pd.DataFrame(df_list)

df.to_csv('exons_ovlpTF_NR_cCREs_Fantom5+Enh_NonCoding_Hsap.bed', sep='\t', index=False, header=False)