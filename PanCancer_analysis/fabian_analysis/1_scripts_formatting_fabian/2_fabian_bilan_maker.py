import pandas as pd
import sys

### Both
#file = "/home/mouren/Data/variants/tcga_MC3/fabian/tcga_exonhancers_vcf_fabian_precise_result_clean_JasparRemap.tsv"
file = "/home/mouren/Data/variants/tcga_MC3/fabian/tcga_exonhancers_vcf_fabian_precise_result_clean_onlyJaspar.tsv"

content = []
with open(file) as f:
    for line in f:
        content.append(line.strip().split())

fabian_raw = pd.DataFrame(content)

#Get unique values from the SNP list and TF list, sort tf and put them as index, snp as columns names
fabian_bilan = pd.DataFrame(columns=fabian_raw[0].unique(), index=sorted(fabian_raw[1].unique()))

for snp_tf in fabian_raw.groupby([0,1]):
    score_sum  = 0
    cpt = 0
    for rows_index, rows in snp_tf[1].iterrows():
        cpt += 1
        score_sum += float(rows[13])
    fabian_bilan.at[rows[1], rows[0]] = round(score_sum/cpt,4)

fabian_bilan.to_csv("/home/mouren/Data/variants/tcga_MC3/fabian/fabian_precise_bilan_JasparFilter_score.tsv",sep="\t")
#fabian_bilan.to_csv("/home/mouren/Data/variants/tcga_MC3/fabian/fabian_precise_bilan_eqtlHiC_RemapJasparFilter_score.tsv",sep="\t")
