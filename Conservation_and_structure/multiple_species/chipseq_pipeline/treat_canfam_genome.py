import pandas as pd

### rewrite the chromosome name correctly in the fasta genome file of canis familiaris 
dic = {}
with open("/home/mouren/Data/ncbi-genomes-2024-05-16/dic_ncbi_canfam_chrom_name.tsv") as f:
    for line in f:
        dic[line.strip().split()[0]] = line.strip().split()[1]

content = []
with open("/home/mouren/Data/ncbi-genomes-2024-05-16/GCF_014441545.1_ROS_Cfam_1.0_genomic.fna") as f:
    for line in f:
        if line[0] == ">":
            id = (line.strip().split()[0])[1:]
            try:
                content.append([">"+str(dic[id])])
            except KeyError: #We are on the unplaced scaffold so we don't care
                break
        else:
            content.append(line.strip().split())

df = pd.DataFrame(content)

df.to_csv("/home/mouren/Data/ncbi-genomes-2024-05-16/Cfam_1.0_ChromNamesCorrect_noUnplacedScaffolds.fasta",sep="\t",header=False,index=False)