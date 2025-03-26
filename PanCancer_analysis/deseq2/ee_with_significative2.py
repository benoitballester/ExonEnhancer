import pandas as pd
import os
dic_result = {}
content_sig = []
directory = "/mnt/project/exonhancer/ZENODO_REPO/PanCancer_analyse/deseq2/file_result"
for filename in os.listdir(directory):
    if os.path.isfile(os.path.join(directory, filename)):
        with open(os.path.join(directory, filename)) as file:
            first = True
            for line in file:
                if first:
                    first = False
                    continue

                try:
                    split_list = [int(x) for x in df_interactions.at[line.strip().split()[9],line.strip().split()[1]].split(",")] 
                    if split_list.count(1) < 2: #keep target with robust interactions 
                        continue
                except KeyError:
                    continue
                
                if filename.split("_")[0] not in dic_result:
                    dic_result[filename.split("_")[0]] = []

                if "allall" in filename:
                    dic_result[filename.split("_")[0]].append([float(line.strip().split()[3]),float(line.strip().split()[8]),"All"])
                    content_sig.append(["all", filename.split("_")[0], line.strip().split()[9]])
                else:
                    dic_result[filename.split("_")[0]].append([float(line.strip().split()[3]),float(line.strip().split()[8]),"Synonymous"])
                    content_sig.append(["syn", filename.split("_")[0], line.strip().split()[9],line.strip().split()[10]])

df_content_sig = pd.DataFrame(content_sig)
df_content_sig = df_content_sig.drop_duplicates()
df_content_sig.to_csv("/mnt/project/exonhancer/ZENODO_REPO/PanCancer_analyse/deseq2/all_sig_uniq.tsv",sep="\t",header=False,index=False)