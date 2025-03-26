#!/bin/bash

#awk '{print $2}' tair_ee_uniprotID > tmp
#awk '{print $2}' tair_neg_uniprotID >> tmp
#sort -u tmp > tair_id_uniprot_uniq

#awk '{print $1}' disorder_prediction_mobidb_tair10.tsv > done_id1
#grep -vFf done_id1 /home/mouren/Data/final_files_tokeep/notes/gene_names/mobidb_id_to_dl/tair_id_uniprot_uniq >run2_id

#We only take the prediction or curated disorder priority, if the entry doenst have those fields, we dont take them
while IFS= read -r line; do
    id=$(echo "$line" |awk '{print $1}')
    #curl -X 'GET' "https://mobidb.org/api/download?format=tsv&ncbi_taxon_id=9606&acc=$id" -H 'accept: text/plain' > tmp #HSAP
    #curl -X 'GET' "https://mobidb.org/api/download?format=tsv&ncbi_taxon_id=3702&acc=$id" -H 'accept: text/plain' > tmp #ATHA
    #curl -X 'GET' "https://mobidb.org/api/download?format=tsv&ncbi_taxon_id=10090&acc=$id" -H 'accept: text/plain' > tmp #MMUS
    curl -X 'GET' "https://mobidb.org/api/download?format=tsv&ncbi_taxon_id=7227&acc=$id" -H 'accept: text/plain' > tmp #DMEL

    grep prediction-disorder-priority tmp > tmp1
    grep curated-disorder-priority tmp > tmp2
    grep homology-disorder-priority tmp > tmp3
    grep derived-missing_residues-priority tmp > tmp4

    awk -v a="$id" '{print a,$0}' OFS=$'\t' tmp1 >>  disorder_prediction_mobidb_dm6.tsv
    awk -v a="$id" '{print a,$0}' OFS=$'\t' tmp2 >>  disorder_prediction_mobidb_dm6.tsv
    awk -v a="$id" '{print a,$0}' OFS=$'\t' tmp3 >>  disorder_prediction_mobidb_dm6.tsv
    awk -v a="$id" '{print a,$0}' OFS=$'\t' tmp4 >>  disorder_prediction_mobidb_dm6.tsv

done < /home/mouren/Data/mobidb/dm/run2_id #/gene_names/mobidb_id_to_dl/dm_id_uniprot_uniq #second run on the ones that didnt work the first time to make sure it was not a response delay problem from the first run 
rm tmp tmp1 tmp2 tmp3 tmp4

#curl -X 'GET' 'https://mobidb.org/api/download?format=tsv&acc=P10912&acc=O15063' -H 'accept: text/plain'
#curl -X 'GET' 'https://mobidb.org/api/download?format=tsv&acc=HTR4' -H 'accept: text/plain' 