import pandas as pd
import os

dic_robust = {}
with open("/home/mouren/Data/interaction/robust_associations_exons_genes.txt") as file:
    for line in file:    
        if line.strip().split()[0] not in dic_robust:
            dic_robust[line.strip().split()[0]] = []
        if line.strip().split()[1] not in dic_robust[line.strip().split()[0]]:
            dic_robust[line.strip().split()[0]].append(line.strip().split()[1])

content_sig = []
directory = "/mnt/project/exonhancer/ZENODO_REPO/PanCancer_analysis/deseq2/file_result"
header = False
for filename in os.listdir(directory):
    if os.path.isfile(os.path.join(directory, filename)):
        with open(os.path.join(directory, filename)) as file:
            first = True
            for line in file:
                if first:
                    if header == False:
                        content_sig.append(["gene","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","nlog10","EE","cancer","patients_full_id","patient_number","analysis"])
                        header = True
                    first = False
                    continue
                
                #check if its robust interaction
                if line.strip().split()[9] in dic_robust:
                    if line.strip().split()[1] in dic_robust[line.strip().split()[9]]:
                        if "allall" in filename:    
                            content_sig.append([line.strip().split()[1],line.strip().split()[2],line.strip().split()[3],line.strip().split()[4],line.strip().split()[5],line.strip().split()[6],line.strip().split()[7],line.strip().split()[8],line.strip().split()[9],filename.split("_")[0],"all_patients_in_EE","all_patients_in_EE","all_variants"])
                        else:
                            patient_number = ""
                            for id_pat in (line.strip().split()[10]).split(","):
                                if patient_number == "":
                                    patient_number = id_pat.split("-")[2]
                                else:
                                    patient_number = patient_number+","+id_pat.split("-")[2]
                            content_sig.append([line.strip().split()[1],line.strip().split()[2],line.strip().split()[3],line.strip().split()[4],line.strip().split()[5],line.strip().split()[6],line.strip().split()[7],line.strip().split()[8],line.strip().split()[9],filename.split("_")[0], line.strip().split()[10],patient_number,"synonymous_variants"])

df_content_sig = pd.DataFrame(content_sig)
df_content_sig = df_content_sig.drop_duplicates()
df_content_sig.to_csv("/mnt/project/exonhancer/ZENODO_REPO/PanCancer_analysis/deseq2/tcga_deseq_significative_results.tsv",sep="\t",header=False,index=False)