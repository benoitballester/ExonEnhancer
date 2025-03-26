###
# To be call in the snakemake to prepare chip atlas exp ID and cell lines/biotype dictionnary 
###
from pathlib import Path
import pandas as pd
import sys

file = Path(sys.argv[1])

content = []
with open(file) as f:
    for line in f:
        if line.strip().split("\t")[1] == "hg38":
            if line.strip().split("\t")[2] == "DNase-seq" or line.strip().split("\t")[2] == "ATAC-Seq":
                entry = [line.strip().split("\t")[0]]
                ### Easy biotypes first
                if line.strip().split("\t")[4] == "Adipocyte":
                    entry.append("Adipose_Tissue")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Blood" or line.strip().split("\t")[5] == "Spleen":
                    entry.append("Blood/Immune")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Muscle" or line.strip().split("\t")[4] == "Bone":
                    entry.append("Musculoskeletal")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Breast":
                    entry.append("Breast")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Cardiovascular":
                    entry.append("Cardiovascular")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Digestive tract":
                    entry.append("Digestive")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Embryo" or line.strip().split("\t")[4] == "Embryonic fibroblast" or line.strip().split("\t")[4] == "Placenta":
                    entry.append("Embryonic")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Epidermis":
                    entry.append("Skin")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Gonad" or line.strip().split("\t")[4] == "Uterus":
                    entry.append("Reproductive_F")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Kidney":
                    entry.append("Kidney")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Liver" or line.strip().split("\t")[5] == "Bile Ducts":
                    entry.append("Liver")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Neural":
                    entry.append("Brain/Nervous")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Pancreas":
                    entry.append("Pancreas")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Prostate":
                    entry.append("Reproductive_M")
                    content.append(entry)    
                    continue
                elif line.strip().split("\t")[4] == "Lung":
                    entry.append("Respiratory")
                    content.append(entry)    
                    continue

                else:
                    ### Next biotypes 
                    if line.strip().split("\t")[5] == "Bronchial brush":
                        entry.append("Respiratory")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Amniotic fluid cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Omentum":
                        entry.append("Adipose_Tissue")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Chorion" or line.strip().split("\t")[5] == "Oral epithelial" or line.strip().split("\t")[5] == "Mesothelial cells":
                        entry.append("Skin")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[4] == "Digestive tract" or line.strip().split("\t")[5] == "Urothelial cell carcinoma":
                        entry.append("Digestive")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[4] == "Epidermis" or line.strip().split("\t")[5] == "Acoustic Maculae" or line.strip().split("\t")[5] == "SqCC/Y1":
                        entry.append("Skin")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[4] == "Muscle" or line.strip().split("\t")[4] == "Bone" or line.strip().split("\t")[5] == "Tongue" or line.strip().split("\t")[5] == "HGF" or line.strip().split("\t")[5] == "Synoviocytes" or line.strip().split("\t")[5] == "93-VU147T" or line.strip().split("\t")[5] == "AG09319":
                        entry.append("Musculoskeletal")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[4] == "Placenta":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[4] == "Liver" or line.strip().split("\t")[5] == "Bile Ducts":
                        entry.append("Liver")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[4] == "Embryo" or line.strip().split("\t")[5] == "Amniotic stem cells" or line.strip().split("\t")[5] == "Embryonic facial prominences"  or line.strip().split("\t")[5] == "iMeLCs":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[4] == "Mesenchymal Stromal Cells" or line.strip().split("\t")[5] == "Mesenchymal stem cells" or line.strip().split("\t")[5] == "Mesenchymal Stromal Cells" or line.strip().split("\t")[5] == "Palatal mesenchymal cells":
                        entry.append("Mesenchyme")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Lens capsules" or line.strip().split("\t")[5] == "HConF" or line.strip().split("\t")[5] == "Schlemms canal cells" or line.strip().split("\t")[5] == "Trabecular meshwork cells" or line.strip().split("\t")[5] == "Limbal stem cells" or line.strip().split("\t")[5] == "Cornea" or line.strip().split("\t")[5] == "Eyes":
                        entry.append("Brain/Nervous")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Detroit 562":
                        entry.append("Digestive")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "16HBE14o-":
                        entry.append("Respiratory")
                        content.append(entry)    
                        continue
                    elif "Bladder" in line.strip().split("\t")[5] or "bladder" in line.strip().split("\t")[5]:
                        entry.append("Bladder")
                        content.append(entry)    
                        continue
                    elif "Thyroid carcinoma" in line.strip().split("\t")[5] or line.strip().split("\t")[5] == "Nthy-ori 3-1" or line.strip().split("\t")[5] == "Thyroid epithelial cells":
                        entry.append("Endocrine")
                        content.append(entry)    
                        continue
                    elif "Urine" in line.strip().split("\t")[5] or line.strip().split("\t")[5] == "Ureter":
                        entry.append("Kidney")
                        content.append(entry)    
                        continue
                    ###
                    elif line.strip().split("\t")[5] == "CD4+ T cells":
                        entry.append("Blood/Immune")
                        content.append(entry)
                        continue
                    elif line.strip().split("\t")[5] == "iPS cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived neural cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived macrophages" or line.strip().split("\t")[5] == "iPSC intermediates":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Tfh":
                        entry.append("Blood/Immune")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "HAEC":
                        entry.append("Cardiovascular")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Fibroblasts":
                        entry.append("Skin")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Adrenal Glands":
                        entry.append("Endocrine")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Spleen":
                        entry.append("Blood/Immune")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived cardiac cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "hESC H1":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "LNCAP":
                        entry.append("Reproductive_M")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "HuH-7":
                        entry.append("Liver")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "HTR8svn":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Osteobl":
                        entry.append("Musculoskeletal")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Hep G2":
                        entry.append("Liver")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Hepatocytes":
                        entry.append("Liver")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Chondrocytes":
                        entry.append("Musculoskeletal")
                        content.append(entry)    
                        continue
                    elif "hESC" in line.strip().split("\t")[5] or line.strip().split("\t")[5] == "ES cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Thyroid tumor" or line.strip().split("\t")[5] == "Thyroid Gland":
                        entry.append("Endocrine")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Tonsil":
                        entry.append("Blood/Immune")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "Ovary":
                        entry.append("Reproductive_F")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived erythroid cells?":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived microglia-like cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived hepatocytes":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived endothelial cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "PGCLC":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPS derived pancreatic cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived hematopoietic cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived chondrocytes":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived myotubes":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived hippocampal cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived epidermal cells" or line.strip().split("\t")[5] == "iPSC derived organoids":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "iPSC derived keratinocytes" or line.strip().split("\t")[5] == "iPSC derived retinal cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue
                    elif line.strip().split("\t")[5] == "PSC derived hepatocyte-like cells":
                        entry.append("Embryonic")
                        content.append(entry)    
                        continue

                    elif line.strip().split("\t")[4] == "Unclassified" or line.strip().split("\t")[5] == "Unclassified" or line.strip().split("\t")[5] == "Tumor" or line.strip().split("\t")[5] == "Cancer" or line.strip().split("\t")[5] == "AC7" or line.strip().split("\t")[5] == "Metastatic cells" or line.strip().split("\t")[5] == "MEFX 2090" or line.strip().split("\t")[5] == "3AA3" :
                        entry.append("Unclassified")
                        content.append(entry)    
                        continue

                    elif line.strip().split("\t")[4] == "No description" and line.strip().split("\t")[5] == "NA":
                        entry.append("Unclassified")
                        content.append(entry) 
                        continue
                    
                    ###
                    elif line.strip().split("\t")[4] == "Others" or line.strip().split("\t")[4] =="Pluripotent stem cell":
                        if line.strip().split("\t")[5] == "CCC-HEH-2" or line.strip().split("\t")[5] == "Embryonic fibroblasts":
                            entry.append("Embryonic")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "T24" or line.strip().split("\t")[5] == "Urothelia" or line.strip().split("\t")[5] == "VM-CUB1":
                            entry.append("Bladder")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "FaDu" or line.strip().split("\t")[5] == "2BS":
                            entry.append("Respiratory")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "SW 872":
                            entry.append("Adipose_Tissue")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "H69" or line.strip().split("\t")[5] == "Head and neck squamous cell carcinoma " or line.strip().split("\t")[5] == "12Z" or line.strip().split("\t")[5] == "GM02171" or line.strip().split("\t")[5] == "HIPEpiC" or line.strip().split("\t")[5] == "HFF-1" or line.strip().split("\t")[5] == "AG05397" or line.strip().split("\t")[5] == "HPdLF" or line.strip().split("\t")[5] == "HAEpiC" or line.strip().split("\t")[5] == "HNPCEpiC":
                            entry.append("Skin")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "SCC090" or line.strip().split("\t")[5] == "CAL 27" or line.strip().split("\t")[5] == "WSU-HN12" or line.strip().split("\t")[5] == "Aska" or line.strip().split("\t")[5] == "HSC-3" or line.strip().split("\t")[5] == "WERI-Rb-1":
                            entry.append("Musculoskeletal")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "HMS001":
                            entry.append("Blood/Immune")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "BT-12" or line.strip().split("\t")[5] == "Olf neurosphere":
                            entry.append("Brain/Nervous")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "NCCIT" or line.strip().split("\t")[5] == "NT2-D1":
                            entry.append("Reproductive_M")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "ACI-158" or line.strip().split("\t")[5] == "ACI-126":
                            entry.append("Reproductive_F")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "MRT G401":
                            entry.append("Kidney")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "NCI-H295R":
                            entry.append("Endocrine")
                            content.append(entry) 
                            continue
                        elif line.strip().split("\t")[5] == "ACC-MESO-1" or line.strip().split("\t")[5] == "KOSC-2":
                            entry.append("Digestive")
                            content.append(entry) 
                            continue
                        else:
                            print(line)
                            continue
                    else:
                        print(line)
                        continue



df = pd.DataFrame(content)
df.to_csv('chipAtlas_expID_biotype.tsv', sep='\t', index=False, header=False)