import pandas as pd
import os

jasp_file = "/home/mouren/Data/variants/tcga_MC3/fabian/jaspar_tcga_precise.tsv"
remap_file = "/home/mouren/Data/variants/tcga_MC3/fabian/remap_tcga_precise.tsv"

#jasp file        
jasp_dic={}
with open(jasp_file) as file:
    for line in file: 
        if line.strip().split()[0] not in jasp_dic:
            jasp_dic[line.strip().split()[0]] = [line.strip().split()[1]]
        else:
            jasp_dic[line.strip().split()[0]].append(line.strip().split()[1])

#remap file 
remap_dic={}
with open(remap_file) as file:
    for line in file: 
        if line.strip().split()[0] not in remap_dic:
            remap_dic[line.strip().split()[0]] = [line.strip().split()[1]]
        else:
            remap_dic[line.strip().split()[0]].append(line.strip().split()[1])

directory = "/home/mouren/Data/variants/tcga_MC3/fabian/result"

#do for only jaspar and jaspar-remap
for filename in os.listdir(directory):
    filepath = os.path.join(directory, filename)
    if os.path.isfile(filepath):

        content = []
        with open(filepath) as file:
            for line in file: 
                name = (line.strip().split()[0]).split(".")[0]
                if name in jasp_dic : #and name in remap_dic:
                    if line.strip().split()[1] in jasp_dic[name]: # and line.strip().split()[1] in remap_dic[name]:
                        content.append(line.strip().split())
                

        df = pd.DataFrame(content)
        df.to_csv("/home/mouren/Data/variants/tcga_MC3/fabian/result_treated/"+filename+"_treated.tsv",sep="\t",header=False,index=False)

#cat /home/mouren/Data/variants/tcga_MC3/0_curl_fabian/result_treated/* >> tcga_exonhancers_vcf_fabian_precise_result_clean_JasparRemap.tsv
#cat /home/mouren/Data/variants/tcga_MC3/0_curl_fabian/result_treated/* >> tcga_exonhancers_vcf_fabian_precise_result_clean_onlyJaspar.tsv

#tar -zcvf tcga_fabian_precise_result.tar.gz /home/mouren/Data/variants/tcga_MC3/fabian/result
#rm result/result_treated