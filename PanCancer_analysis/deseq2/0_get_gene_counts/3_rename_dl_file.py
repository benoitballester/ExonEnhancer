import os 
from pathlib import Path

dic_name_id = {}
with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/dic_fileName_IdFile', 'r') as file:
    for line in file :
        dic_name_id[line.strip().split("\t")[1]] = line.strip().split("\t")[0]

dic_barcode = {}
with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/all_UUID_TAGCBarcodes_dic.tsv', 'r') as file:
    for line in file:
        dic_barcode[line.strip().split("\t")[0]] = line.strip().split("\t")[1]

all = []
double_check = []
directory = "/home/mouren/Data/variants/tcga_MC3/normal_barcodes/dl"
for filename in os.listdir(directory):
    corresponding = dic_barcode[dic_name_id[filename]][:16]
    
    if corresponding not in all:
        all.append(corresponding)
    else:
        double_check.append(corresponding)
        
directory = "/home/mouren/Data/variants/tcga_MC3/normal_barcodes/dl"
for filename in os.listdir(directory):
    corresponding = dic_barcode[dic_name_id[filename]][:16]
    
    if corresponding not in double_check:
        current_path = Path(os.path.join(directory, filename))
        new_file_path = Path("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/renamed/"+corresponding+"_RNA_Gene_Counts.tsv")
        current_path.rename(new_file_path)

    else:
        current_path = Path(os.path.join(directory, filename))
        new_file_path = Path("/home/mouren/Data/variants/tcga_MC3/normal_barcodes/renamed/"+dic_barcode[dic_name_id[filename]]+"_RNA_Gene_Counts.tsv")
        current_path.rename(new_file_path)