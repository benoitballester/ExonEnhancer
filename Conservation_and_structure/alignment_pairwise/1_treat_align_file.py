import sys 
import pandas as pd 
import os 

file = sys.argv[1] #in raw/
filename = (os.path.basename(file)).split(".")[0]
species = filename.split("_")[0]

content=[]
with open(file) as f:
    for line in f:            
        row = line.strip().split()
        for i in range(len(row)):
            if species == "hg38":
                if row[i] == "Mouse":
                    base = []
                    base.append(("chr"+(row[i+1]).split(":")[0]))
                    base.append(((row[i+1]).split(":")[1]).split("-")[0])
                    base.append(((row[i+1]).split(":")[1]).split("-")[1])
                    base.append(line.strip().split()[3])
                    content.append(base)

df = pd.DataFrame(content)
df.to_csv("/home/mouren/Data/conservation/hg38_mm39_comparison/alignment_pairwise_LASTZ_NET/treated/"+filename+"_treated.bed",sep="\t",header=False,index=False)



