#All ids to get
list_id = []
with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/all_tumor_barcodes', 'r') as file:
    for line in file:
        list_id.append(line.strip()[:16])
with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/all_normal_barcodes', 'r') as file:
    for line in file:
        list_id.append(line.strip()[:16])

dic_barcode = {}
with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/all_UUID_TAGCBarcodes_dic.tsv', 'r') as file:
    for line in file:
        dic_barcode[line.strip().split("\t")[0]] = line.strip().split("\t")[1]

# Filter the data based on project_id containing "TCGA"
to_dl = []
with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/allTCGA_GeneCounts_fileID.txt', 'r') as file:  
    for line in file:
        barcode = dic_barcode[line.strip()]
        if barcode[:16] in list_id:
            to_dl.append(line.strip())


with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/to_dl_ids.txt', 'w') as file:
    for i in to_dl:
        file.write(i + '\n')

# Files were downloaded like this : 
#cat to_dl_ids.txt | xargs -P 18 -n 1 -I {} curl --remote-name --remote-header-n 'https://api.gdc.cancer.gov/data/{}'

# import json
# data = {'ids': to_dl}
# with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/request.txt', 'w') as file:
#     json.dump(data, file, indent=4)

#big_string = ("&").join(to_dl)
#with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/Payload', 'w') as file:
#    file.write(big_string)