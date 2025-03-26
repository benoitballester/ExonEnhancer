#!/bin/bash

awk -F '\t' '{print $4}' OFS=$'\t' $2 | sort | uniq -c > tmp #get list of frequencies of apparition in column 4

awk 'NR==FNR{a[$2]=$1; next} {print $0, a[$4]}' OFS=$'\t' tmp $1 > tmp1 
# if the gene name in column 2 of first file "a[$2]" match with fourth column of second file "a[$4]", print full line of second file "print $0" then first column of first file "a[$2]=$1"

awk '{if ($11=="") $11="NA"; print $0}' OFS=$'\t' tmp1 > tmp2

python /home/mouren/Data/repoexonhancer/overlap/hg38/scripts_ovlp_datasets/bedBilan_TF.py $2

awk 'NR==FNR{a[$1]=$2"\t"$3"\t"$4"\t"$5; next} {print $0, a[$4]}' OFS=$'\t' tf_cell_count.csv tmp2 > tmp3

awk '{if ($12=="") $12="NA"; if ($13=="") $13="NA"; if ($14=="") $14="NA"; if ($15=="") $15="NA"; print}' OFS=$'\t' tmp3 

rm tmp tmp1 tmp2 tmp3 tf_cell_count.csv