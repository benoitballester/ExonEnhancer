import pandas as pd
import sys
import csv

file_raw = sys.argv[1]
tiss_file = sys.argv[2]
abrv_file = sys.argv[3]

#cancer id to full name dic
tiss_dic={}
with open(tiss_file) as file:
    for line in file: 
        tiss_dic[line.strip().split("\t")[0]] = line.strip().split("\t")[2]

#abrv_dic id to full name dic
abrv_dic={}
with open(abrv_file) as file:
    for line in file: 
        abrv_dic[line.strip().split("\t")[1]] = line.strip().split("\t")[0]

content_file = []
fabian_dic = {}
with open(file_raw) as f:
    cpt = 0
    for line in f:
        entry=line.strip().split()

        patient = (line.strip().split()[8]).split("-")[2] #we get the patient and put in a column for easy handling of file later
        entry.append(patient)

        cancer_id = (line.strip().split()[8]).split("-")[1] #we get the Tissue Source Site in the tumor barcode number 
        cancer_name = tiss_dic[cancer_id]
        try:
            cancer_abrv = abrv_dic[cancer_name]
            entry.append(cancer_abrv)
        except KeyError:
            entry.append(cancer_name)

        entry.append(str(cpt)) # we had a unique identifier for the snp to easy handle the fabian response later
        
        #we create directly the dic of fabian snp format and unique identifier 
        fabian_format = line.strip().split()[0]+":"+line.strip().split()[2]+line.strip().split()[4]+">"+line.strip().split()[5]
        if fabian_format not in fabian_dic:
            fabian_dic[fabian_format] = [str(cpt)]
        else:
            fabian_dic[fabian_format].append(str(cpt))

        cpt += 1

        content_file.append(entry)
file_mc3 = pd.DataFrame(content_file)
file_mc3.to_csv("/home/mouren/Data/variants/tcga_MC3/tcga_all_snps_hg19.tsv",header=False,index=False,sep="\t")

file_name = '/home/mouren/Data/variants/tcga_MC3/snpId_fabianFormat_dic.tsv'
with open(file_name, 'w', newline='') as file:
    tsv_writer = csv.writer(file, delimiter='\t')
    for inner_list in content:
        tsv_writer.writerow(inner_list)