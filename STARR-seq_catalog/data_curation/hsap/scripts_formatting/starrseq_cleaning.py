from pathlib import Path
import pandas as pd
import sys

file_narr = Path(sys.argv[1])

content_narr=[]
with open(file_narr) as file:
    for line in file:
        row = line.strip().split()
        if "A549" in row[3]:
            row[3] = row[3].replace('A549', 'A-549')
        elif "K562" in row[3]:
            row[3] = row[3].replace('K562', 'K-562')
        elif "HCT116" in row[3]:
            row[3] = row[3].replace('HCT116', 'HCT-116')
        elif "HepG2" in row[3]:
            row[3] = row[3].replace('HepG2', 'Hep-G2')
        elif "K562" in row[3]:
            row[3] = row[3].replace('K562', 'K-562')
        elif "MCF7" in row[3]:
            row[3] = row[3].replace('MCF7', 'MCF-7')

        content_narr.append(row)

df_narr = pd.DataFrame(content_narr)
df_narr.to_csv("tmp_file_clean",index=False,header=False,sep="\t")