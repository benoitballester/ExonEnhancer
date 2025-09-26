import sys 
import pandas as pd

#Get list of jaspar
vertebrates=[]
with open("/home/mouren/Data/jaspar_files/jaspar2022_vertebrates_all_matrix_name.txt") as file:
    for line in file:           
        vertebrates.append(line.strip().split()[0].upper())

insects=[]
with open("/home/mouren/Data/jaspar_files/jaspar2022_insects_all_matrix_name.txt") as file:
    for line in file:           
        insects.append(line.strip().split()[0].upper())

plants=[]
with open("/home/mouren/Data/jaspar_files/jaspar2022_plants_all_matrix_name.txt") as file:
    for line in file:           
        plants.append(line.strip().split()[0].upper())

#compute file
file = sys.argv[1]
species = sys.argv[2]
type = sys.argv[4]
dataset = sys.argv[5]

content = []
if species == "hg" or species == "mm":
    with open(file) as f:
        for line in f:
            #define start and end in the limits of the exon
            if type == "ee":

                if int(line.strip().split()[10]) < int(line.strip().split()[1]):
                    start = int(line.strip().split()[1])         
                else:
                    start = int(line.strip().split()[10])

                if int(line.strip().split()[11]) > int(line.strip().split()[2]):
                    end = int(line.strip().split()[2])         
                else:
                    end = int(line.strip().split()[11])

                if dataset != "all":
                    #check if tf is in jaspar
                    tf = ((line.strip().split()[12]).split(":")[0]).upper()
                    if tf in vertebrates:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in vertebrates or tf2 in vertebrates:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
                else:
                    tf = ((line.strip().split()[12]).split(".")[1]).upper()
                    if tf in vertebrates:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in vertebrates or tf2 in vertebrates:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue

            else:
                if int(line.strip().split()[5]) < int(line.strip().split()[1]):
                    start = int(line.strip().split()[1])         
                else:
                    start = int(line.strip().split()[5])

                if int(line.strip().split()[6]) > int(line.strip().split()[2]):
                    end = int(line.strip().split()[2])         
                else:
                    end = int(line.strip().split()[6])

                if dataset != "all":
                    tf = ((line.strip().split()[7]).split(":")[0]).upper()
                    if tf in vertebrates:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in vertebrates or tf2 in vertebrates:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
                else:
                    tf = ((line.strip().split()[7]).split(".")[1]).upper()
                    if tf in vertebrates:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in vertebrates or tf2 in vertebrates:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue

elif species == "dm":
    with open(file) as f:
        for line in f:       
            #define start and end in the limits of the exon
            if type == "ee": #not the same formatting of remap file for pos and ee 
                if int(line.strip().split()[10]) < int(line.strip().split()[1]):
                    start = int(line.strip().split()[1])         
                else:
                    start = int(line.strip().split()[10])

                if int(line.strip().split()[11]) > int(line.strip().split()[2]):
                    end = int(line.strip().split()[2])         
                else:
                    end = int(line.strip().split()[11])

                #check if tf is in jaspar
                if dataset != "all":
                    tf = ((line.strip().split()[12]).split(":")[0]).upper()
                    if tf in insects:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in insects or tf2 in insects:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
                else:
                    tf = ((line.strip().split()[12]).split(".")[1]).upper()
                    if tf in insects:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in insects or tf2 in insects:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
            else:
                if int(line.strip().split()[5]) < int(line.strip().split()[1]):
                    start = int(line.strip().split()[1])         
                else:
                    start = int(line.strip().split()[5])

                if int(line.strip().split()[6]) > int(line.strip().split()[2]):
                    end = int(line.strip().split()[2])         
                else:
                    end = int(line.strip().split()[6])

                if dataset != "all":
                    tf = ((line.strip().split()[7]).split(":")[0]).upper()
                    if tf in insects:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in insects or tf2 in insects:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
                else:
                    tf = ((line.strip().split()[7]).split(".")[1]).upper()
                    if tf in insects:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in insects or tf2 in insects:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue

else:
    with open(file) as f:
        for line in f:         
            #define start and end in the limits of the exon
            if type == "ee":
                if int(line.strip().split()[10]) < int(line.strip().split()[1]):
                    start = int(line.strip().split()[1])         
                else:
                    start = int(line.strip().split()[10])

                if int(line.strip().split()[11]) > int(line.strip().split()[2]):
                    end = int(line.strip().split()[2])         
                else:
                    end = int(line.strip().split()[11])

                #check if tf is in jaspar
                if dataset != "all":
                    tf = ((line.strip().split()[12]).split(":")[0]).upper()
                    if tf in plants:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in plants or tf2 in plants:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
                else:
                    tf = ((line.strip().split()[12]).split(".")[1]).upper()
                    if tf in plants:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in plants or tf2 in plants:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
            else:
                if int(line.strip().split()[5]) < int(line.strip().split()[1]):
                    start = int(line.strip().split()[1])         
                else:
                    start = int(line.strip().split()[5])

                if int(line.strip().split()[6]) > int(line.strip().split()[2]):
                    end = int(line.strip().split()[2])         
                else:
                    end = int(line.strip().split()[6])

                if dataset != "all":
                    tf = ((line.strip().split()[7]).split(":")[0]).upper()
                    if tf in plants:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in plants or tf2 in plants:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue
                else:
                    tf = ((line.strip().split()[7]).split(".")[1]).upper()
                    if tf in plants:
                        content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf,"NA"])
                    else:
                        try:
                            tf1, tf2 = tf.split("-")
                            if tf1 in plants or tf2 in plants:
                                content.append([line.strip().split()[0],start,end,line.strip().split()[3],tf1,tf2])
                        except Exception as e:
                            continue

df = pd.DataFrame(content)

output = sys.argv[3]
df.to_csv("/home/mouren/Data/matching_jaspar_remap/remap_overlap_all/"+output,sep="\t",header=False,index=False)