### Data comes from Laverré et al. 2022 Genome Research; Supplemental Dataset S1
import pandas as pd

gene_dic = {}
with open("/home/mouren/Data/hiC/raw/bait_coords_hg38.txt") as file:
    first = True
    for line in file:            
        if first == True:
            first = False
            continue
        else:
            gene_dic[line.strip().split()[0]] = line.strip().split()[5]

#Based on Laverré et al. 2022 Genome Research, we need to remove interactions under a distance of 25KB and above 2M
#Size of targets are comprised between 150bp and 50000bp

# We need two files : one with all the interactions (meaning the EE can be in a target fragment without or with a promoter)
# The other file where we will overlap the EE with the bait fragments, because the EE can be in bait, BUT target needs to be also baited,
# it means that the EE in the bait fragment needs another promoter in the target frament to interact with, so a baited target)


#List of cells line interaction 
cells = ["Bcell","CD34","PEK_early","PEK_late","PEK_undiff","pre_adipo","cardio","hESC","hNEC","MK","EP","Mon","TCD8","Ery","Neu","FoeT","NB","TCD4MF","TCD4Non","TCD4Non","TCD4Act","Mac0","Mac1","Mac2","NCD4","TB","NCD8"]

#File where we will cross EE with targets       
content=[]
with open("/home/mouren/Data/hiC/raw/all_interactions.txt") as file:
    first = True
    for line in file:            
        if first == True:
            entry = ["target_chr","target_start","target_end","target_type","bait_chr","bait_start","bait_end","distance","mean_score","BAIT_genesID"]
            content.append(entry)
            first = False
            continue
        else:     
            if float(line.strip().split()[7]) < 25000 or float(line.strip().split()[7]) > 2000000:
                continue
            else:
                entry = [line.strip().split()[3],line.strip().split()[4],line.strip().split()[5],line.strip().split()[6],line.strip().split()[0],line.strip().split()[1],line.strip().split()[2],line.strip().split()[7]]       
                
                tmp = line.strip().split()[8:] 
                score = 0
                list_cells = []
                for i in range(len(tmp)):
                    if tmp[i] != "NA":
                        score += float(tmp[i])
                        list_cells.append(cells[i])
                score =  round(score/len(tmp), 2)
                entry.append(score)
                entry.append((",").join(list_cells))

                gene = gene_dic[line.strip().split()[0]+":"+line.strip().split()[1]+":"+line.strip().split()[2]]
                entry.append(gene)
                    
                content.append(entry)

df = pd.DataFrame(content)
df.to_csv("/home/mouren/Data/hiC/allTargets_interactions_hg38.tsv",sep="\t",header=False,index=False)

#File where we will cross EE with baits but only if target is baited also         
content=[]
with open("/home/mouren/Data/hiC/raw/all_interactions.txt") as file:
    first = True
    for line in file:            
        if first == True:
            entry = ["bait_chr","bait_start","bait_end","target_type","target_chr","target_start","target_end","distance","mean_score","TARGET_genesID"]
            content.append(entry)
            first = False
            continue
        else:     
            if float(line.strip().split()[7]) < 25000 or float(line.strip().split()[7]) > 2000000:
                continue
            else:
                if line.strip().split()[6] == "baited":
                
                    entry = [line.strip().split()[0],line.strip().split()[1],line.strip().split()[2],line.strip().split()[6],line.strip().split()[3],line.strip().split()[4],line.strip().split()[5],line.strip().split()[7]]       

                    tmp = line.strip().split()[8:] 
                    score = 0
                    list_cells = []
                    for i in range(len(tmp)):
                        if tmp[i] != "NA":
                            score += float(tmp[i])
                            list_cells.append(cells[i])
                    score =  round(score/len(tmp), 2)
                    entry.append(score)
                    entry.append((",").join(list_cells))

                    gene = gene_dic[line.strip().split()[3]+":"+line.strip().split()[4]+":"+line.strip().split()[5]]
                    entry.append(gene)
                        
                    content.append(entry)

df = pd.DataFrame(content)
df.to_csv("/home/mouren/Data/hiC/baitTobait_interactions_hg38.tsv",sep="\t",header=False,index=False)