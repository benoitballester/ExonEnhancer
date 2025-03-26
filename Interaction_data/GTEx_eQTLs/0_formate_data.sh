#!/bin/bash
# get all snp significant variant-gene pair association data from getex and merge in one file
tar -xf GTEx_Analysis_v8_eQTL.tar
gzip -d *gene_pairs*

header="chr\tstart\tend\tvariant_id\tgene_id\ttss_distance\tma_samples\tma_count\tmaf\tpval_nominal\tslope\tslope_se\tpval_nominal_threshold\tmin_pval_nominal\tpval_beta"

echo -e ${header} > gtex_all_signif_variant_gene_pairs.tsv
for file in *gene_pairs.txt
do
  SAMPLE=$(basename ${file})
  awk '(NR>1)' $file |awk -v name=${SAMPLE} '{split(name,a,"."); split($1,b,"_"); print b[1],b[2]-1,b[2],a[1]"_"NR"_"b[3]">"b[4],$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}' OFS=$'\t' >> gtex_all_signif_variant_gene_pairs.tsv
done

