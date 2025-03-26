import sys 
import csv
import pandas as pd 
import pyarrow as pa
#srun --mem 100GB --cpus-per-task 10 --pty python ../../../repoexonhancer/divers/matching_jaspar_remap/pipeline_ifb_randomized_v2/4_check_matching_ifb.py remap/group_ match_tfbs/group_ nb_tf_per_elements.tsv

#Load list of elements in group file 
tf_file = sys.argv[1]
with open(tf_file, "r") as f:
    element_in_group_list = list({line.split("\t")[3] for line in f if line.strip()})

#Load nb of TF per elements
dic_file = sys.argv[3]
with open(dic_file, "r") as f:
    reader = csv.reader(f, delimiter="\t")
    dic_tf = {rows[0]: int(rows[1]) for rows in reader}

#Load overlap file
dtypes = {
    'Chromosome': pd.ArrowDtype(pa.large_string()),
    'Start': pd.ArrowDtype(pa.int64()),
    'End': pd.ArrowDtype(pa.int64()),
    'exon':pd.ArrowDtype(pa.large_string()),
    'tf1':pd.ArrowDtype(pa.large_string()),
    'tf2':pd.ArrowDtype(pa.large_string()),
    'Chromosome_tfbs': pd.ArrowDtype(pa.large_string()),
    'Start_tfbs': pd.ArrowDtype(pa.int64()),
    'End_tfbs': pd.ArrowDtype(pa.int64()),
    'tfbs1':pd.ArrowDtype(pa.large_string()),
    'tfbs2':pd.ArrowDtype(pa.large_string()),
}
match_file = sys.argv[2]
df_match = pd.read_table(match_file, sep='\t', header=None, names=['Chromosome','Start','End','exon','tf1','tf2','Chromosome_tfbs','Start_tfbs','End_tfbs','tfbs1','tfbs2'], engine='pyarrow',dtype_backend='pyarrow',dtype=dtypes)

# Filter DF
df_match = df_match.loc[ #get matching TF/TFBS
    (
        (~df_match['tf1'].isna()) & 
        ((df_match['tf1'] == df_match['tfbs1']) | (df_match['tf1'] == df_match['tfbs2']))
    ) |
    (
        (~df_match['tf2'].isna()) & 
        ((df_match['tf2'] == df_match['tfbs1']) | (df_match['tf2'] == df_match['tfbs2']))
    )
]

df_match.drop_duplicates(subset=df_match.columns[:5], inplace=True) # Keep only one row for each unique combination of the first five columns

# Compute matching
match_counts = df_match['exon'].value_counts().to_dict()
res = {}
for key,value in match_counts.items():
    res[key] = (value*100)/dic_tf[key]

for element in element_in_group_list:
    if element not in res: #element had no matching TF/TFBS
        res[element] = 0

file_number = tf_file.split("_")[-1]
with open("/shared/projects/exonhancer/data/matching_tfbs/to_treat/res/matching_res_"+file_number, 'w') as file:
    for key, value in res.items():
        file.write(f'{key}\t{value}\n')