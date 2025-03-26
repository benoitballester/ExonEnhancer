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

    old_row = {"Chrom":"","Start":"","End":"","Exon_ID":"","Score":"","Strand":"", "density_peak":""}

    for line in lines:
        # check if it was the cds
        density_peak = line.strip().split()[9]

        if first == True: #if first line of file
            first = False
            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "density_peak":
                    old_row[key] = density_peak
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
            if int(old_row["density_peak"]) > int(density_peak):
                continue
            else:
                old_row["density_peak"] = density_peak
               

            if line is last:
                df_list.append(copy.deepcopy(old_row))
            
            continue

        else:
            df_list.append(copy.deepcopy(old_row))

            values_list = line.strip().split()

            cpt = 0
            for key,values in old_row.items():
                if key == "density_peak":
                    old_row[key] = density_peak
                else:
                    old_row[key] = values_list[cpt]

                cpt +=1

            if line is last:
                df_list.append(copy.deepcopy(old_row))


df = pd.DataFrame(df_list)

df.to_csv('exons_ovlpTF_NR_cCREs_Fantom5+Enh_NonCoding_cdsStartEnd_UTR5_UTR3_peakDensity_Hsap.bed', sep='\t', index=False, header=False)