### DIVIDE REMAP NON REDUNDANT DATASET INTO A LOLA COLLECTION BY TF
# srun --mem 30GB --cpus-per-task 8 --pty python /shared/projects/exonhancer/repoexonhancer/enrichment/collection_maker_remap.py /shared/projects/exonhancer/data/remap_files/remap2022_nr_macs2_TAIR10_v1_0.bed tf_nr_tair10/ 
import pandas as pd
import sys 

remap_file = sys.argv[1]
output_folder = sys.argv[2]

dic_tf = {}
with open(remap_file) as f:
    for line in f:
        tf  = (line.strip().split()[3]).split(':')[0]
        if tf not in dic_tf :
            dic_tf[tf] = [line.strip().split()]
        else:
            dic_tf[tf].append(line.strip().split())

for key, value in dic_tf.items():
    df = pd.DataFrame(value)
    df.to_csv('/shared/projects/exonhancer/data/LOLA/tf_catalogs/'+str(output_folder)+'collection/regions/'+str(key)+'_remap2022.bed', sep='\t', index=False, header=False)

with open('/shared/projects/exonhancer/data/LOLA/tf_catalogs/'+str(output_folder)+'collection/sizes.txt', 'w') as file:
    file.write(f'filename\tsize\n')
    for key, value in dic_tf.items():
        file.write(f'{key}\t{len(value)}\n')