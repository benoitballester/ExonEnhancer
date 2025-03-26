# Called in get_robust_exons_ovlp_remap_all_raw.sh

from pathlib import Path
import pandas as pd
import sys    

### Import cell lines and biotypes dictionnary 
dic_biotype1 = {}
dic_gtex = {}
with open("/home/mouren/Data/final_files_tokeep/tls1/annotation/cellLines_Biotype_GtexSimplifiedBiotype.tsv") as file:
    for line in file:
        dic_biotype1[line.strip().split()[0]] = line.strip().split()[1]            
        dic_gtex[line.strip().split()[0]] = line.strip().split()[2]

### Bilan to make 
file = Path(sys.argv[1])

# We first take all tf and cells lines mapping on a gene 
dico = {}
with open(file) as f:
    for line in f:
        exon = line.strip().split()[3]
        peak = line.strip().split()[12]

        tf_name = peak.split(".")[1]
        tmp = peak.split(".")[2]
        cell_lines = tmp.split("_")[0]

        biotype_biotype1 = dic_biotype1[cell_lines]
        biotype_gtex = dic_gtex[cell_lines]

        if exon not in dico:
            dico[exon] = {"TF":[tf_name],"cell_lines":[cell_lines],"biotype1":[biotype_biotype1],"gtex":[biotype_gtex],"count":1}
        else:
            dico[exon]["TF"].append(tf_name)
            dico[exon]["cell_lines"].append(cell_lines)
            dico[exon]["biotype1"].append(biotype_biotype1)
            dico[exon]["gtex"].append(biotype_gtex)
            dico[exon]["count"] += 1

#create the count list
content = []
for key,value in dico.items():
    dic_tf = {}
    dic_cellLines = {}
    dic_bio_biotype1 = {}
    dic_bio_gtex = {}

    for tf in value["TF"]:
        if tf not in dic_tf:
            nb = value["TF"].count(tf)
            dic_tf[tf] = nb
        else:
            continue
    
    for cell in value["cell_lines"]:
        if cell not in dic_cellLines:
            nb = value["cell_lines"].count(cell)
            dic_cellLines[cell] = nb
        else:
            continue
    
    for bio in value["biotype1"]:
        if bio not in dic_bio_biotype1:
            nb = value["biotype1"].count(bio)
            dic_bio_biotype1[bio] = nb
        else:
            continue

    for bio in value["gtex"]:
        if bio not in dic_bio_gtex:
            nb = value["gtex"].count(bio)
            dic_bio_gtex[bio] = nb
        else:
            continue
    
    list_tf = ",".join(list(dic_tf.keys()))
    list_tf_count = ",".join(list(map(str,list(dic_tf.values()))))
    list_cell = ",".join(list(dic_cellLines.keys()))
    list_cell_count = ",".join(list(map(str,list(dic_cellLines.values()))))
    list_bio_biotype1 = ",".join(list(dic_bio_biotype1.keys()))
    list_bio_biotype1_count = ",".join(list(map(str,list(dic_bio_biotype1.values()))))
    list_bio_gtex = ",".join(list(dic_bio_gtex.keys()))
    list_bio_gtex_count = ",".join(list(map(str,list(dic_bio_gtex.values()))))

    row = [key, value["count"], list_tf, list_tf_count, list_cell, list_cell_count, list_bio_biotype1, list_bio_biotype1_count, list_bio_gtex, list_bio_gtex_count]

    content.append(row)

df = pd.DataFrame(content)
df.to_csv('bilan_robust_exons_OvlpAll_remap.csv', sep='\t', index=False, header=False)