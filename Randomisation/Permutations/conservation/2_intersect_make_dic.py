#bedtools intersect -a lastznet_hg38_all_exons_treated.bed -b coding_exons_50pb_merge_mm39.tsv -wa -wb > hg_latsz_overlap_all_exons_mm39.tsv

import sys 

file = sys.argv[1]

content={}
with open(file) as f:
    for line in f:            
        if line.strip().split()[3] not in content:
            content[line.strip().split()[3]] = [line.strip().split()[7]]
        else:
            content[line.strip().split()[3]].append(line.strip().split()[7])

with open("/shared/projects/exonhancer/data/revisions/permut_test/conservation/hg_mmus_all_exons_lastz_dic.tsv", 'w') as file:
    for key, value in content.items():
        val = (",").join(value)
        file.write(f'{key}\t{val}\n')