import sys 
import pandas as pd 
import os 

file = sys.argv[1]
chemin_dossier = os.path.dirname(os.path.abspath(sys.argv[1]))


human=[]
mouse = []
rat = []
dog = []
macaque = []
with open(file) as f:
    for line in f:    

        entry = [line.strip().split()[0],line.strip().split()[1],line.strip().split()[2],line.strip().split()[3]]
        if entry not in human:
            human.append(entry)

        row = line.strip().split()
        for i in range(len(row)):

            if row[i] == "Mouse":
                base = []
                base.append(("chr"+(row[i+1]).split(":")[0]))
                base.append(((row[i+1]).split(":")[1]).split("-")[0])
                base.append(((row[i+1]).split(":")[1]).split("-")[1])
                base.append(line.strip().split()[3])
                mouse.append(base)

            elif row[i] == "Rat":
                base = []
                base.append(("chr"+(row[i+1]).split(":")[0]))
                base.append(((row[i+1]).split(":")[1]).split("-")[0])
                base.append(((row[i+1]).split(":")[1]).split("-")[1])
                base.append(line.strip().split()[3])
                rat.append(base)
            
            elif row[i] == "Dog":
                base = []
                base.append(("chr"+(row[i+1]).split(":")[0]))
                base.append(((row[i+1]).split(":")[1]).split("-")[0])
                base.append(((row[i+1]).split(":")[1]).split("-")[1])
                base.append(line.strip().split()[3])
                dog.append(base)
            
            elif row[i] == "Macaque":
                base = []
                base.append(("chr"+(row[i+1]).split(":")[0]))
                base.append(((row[i+1]).split(":")[1]).split("-")[0])
                base.append(((row[i+1]).split(":")[1]).split("-")[1])
                base.append(line.strip().split()[3])
                macaque.append(base)

mouse_df = pd.DataFrame(mouse)
macaque_df = pd.DataFrame(macaque)
dog_df = pd.DataFrame(dog)
rat_df = pd.DataFrame(rat)
human_df = pd.DataFrame(human)

mouse_df.to_csv(os.path.join(chemin_dossier, "mouse_coords.bed"),sep="\t",header=False,index=False)
macaque_df.to_csv(os.path.join(chemin_dossier, "macaque_coords.bed"),sep="\t",header=False,index=False)
dog_df.to_csv(os.path.join(chemin_dossier, "dog_coords.bed"),sep="\t",header=False,index=False)
rat_df.to_csv(os.path.join(chemin_dossier, "rat_coords.bed"),sep="\t",header=False,index=False)
human_df.to_csv(os.path.join(chemin_dossier, "human_coords.bed"),sep="\t",header=False,index=False)



