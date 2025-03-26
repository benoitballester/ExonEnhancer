import sys 
import pandas as pd 

file = sys.argv[1]

df = pd.read_csv(file, sep="\t", header=None,index_col=False)

df[3] = pd.to_numeric(df[3])

df[3] = df[3] / 12

df.to_csv("/home/mouren/Data/starrseq/starr_distribution/bigwig/a549/allENCODE_STARR_signal_A-549_sorted_normalized.bedGraph",sep="\t",header=False,index=False)