import pandas as pd 

######## EE
### Load file
content=[]
with open("/home/mouren/Data/encode-rE2G/ee_encode_re2g_overlap_raw.tsv") as file:
    for line in file:            
        content.append(line.strip().split("\t"))
df = pd.DataFrame(content)

### Prepare new dataframe 
celllines = df[8].unique()
exons = df[3].unique()
df2 = pd.DataFrame(index=exons, columns=celllines)

for col in df2.columns: # Fill the new DataFrame with empty lists
    df2[col] = df2[col].apply(lambda x: [])

### Fill new 
for index in df.index:
    if df.at[index,7] != "NA":
        df2.at[df.at[index,3],df.at[index,8]].append(df.at[index,7]) 

### Prepare for saving
for col in df2.columns:
    for idx in df2.index:
        if not df2.at[idx, col]:
            df2.at[idx, col] = "0"
        else:
            df2.at[idx, col] = ','.join(df2.at[idx, col])

df2.to_csv("/home/mouren/Data/encode-rE2G/ee_encode_re2g_overlap_bilan.tsv",sep="\t")

######## CRTL NEG
### Load file
content=[]
with open("/home/mouren/Data/encode-rE2G/neg_encode_re2g_overlap_raw.tsv") as file:
    for line in file:            
        content.append(line.strip().split("\t"))
df = pd.DataFrame(content)

### Prepare new dataframe 
celllines = df[8].unique()
exons = df[3].unique()
df2 = pd.DataFrame(index=exons, columns=celllines)

for col in df2.columns: # Fill the new DataFrame with empty lists
    df2[col] = df2[col].apply(lambda x: [])

### Fill new 
for index in df.index:
    if df.at[index,7] != "NA":
        df2.at[df.at[index,3],df.at[index,8]].append(df.at[index,7]) 

### Prepare for saving
for col in df2.columns:
    for idx in df2.index:
        if not df2.at[idx, col]:
            df2.at[idx, col] = "0"
        else:
            df2.at[idx, col] = ','.join(df2.at[idx, col])

df2.to_csv("/home/mouren/Data/encode-rE2G/neg_encode_re2g_overlap_bilan.tsv",sep="\t")

######## CRTL POS
### Load file
content=[]
with open("/home/mouren/Data/encode-rE2G/pos_encode_re2g_overlap_raw.tsv") as file:
    for line in file:            
        content.append(line.strip().split("\t"))
df = pd.DataFrame(content)

### Prepare new dataframe 
celllines = df[8].unique()
exons = df[3].unique()
df2 = pd.DataFrame(index=exons, columns=celllines)

for col in df2.columns: # Fill the new DataFrame with empty lists
    df2[col] = df2[col].apply(lambda x: [])

### Fill new 
for index in df.index:
    if df.at[index,7] != "NA":
        df2.at[df.at[index,3],df.at[index,8]].append(df.at[index,7]) 

### Prepare for saving
for col in df2.columns:
    for idx in df2.index:
        if not df2.at[idx, col]:
            df2.at[idx, col] = "0"
        else:
            df2.at[idx, col] = ','.join(df2.at[idx, col])

df2.to_csv("/home/mouren/Data/encode-rE2G/pos_encode_re2g_overlap_bilan.tsv",sep="\t")