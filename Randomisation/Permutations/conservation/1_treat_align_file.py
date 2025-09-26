import sys 
import pandas as pd 

file = sys.argv[1]

content=[]
with open(file) as f:
    for line in f:            
        try:
            row = line.strip().split()
            entry = []
            entry.append(("chr"+(row[7]).split(":")[0]))
            entry.append(((row[7]).split(":")[1]).split("-")[0])
            entry.append(((row[7]).split(":")[1]).split("-")[1])
            entry.append(line.strip().split()[3])
            content.append(entry)
        except IndexError:
            continue

df = pd.DataFrame(content)
df.to_csv("/shared/projects/exonhancer/data/revisions/permut_test/conservation/lastznet_hg38_all_exons_treated.bed",sep="\t",header=False,index=False)


