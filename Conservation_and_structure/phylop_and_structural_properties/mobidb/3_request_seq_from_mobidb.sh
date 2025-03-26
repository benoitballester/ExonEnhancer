#!/bin/bash

#Get list of id that had disorders $1 = disorder_prediction_mobidb_hg38.tsv
awk '{print $1}' $1 |sort -u > dl_id_tmp

#Determine species $2 is hg dm mm tair
if [ "$2" = "hg" ]; then
    spec_id=9606
elif [ "$2" = "dm" ]; then
    spec_id=7227
elif [ "$2" = "mm" ]; then
    spec_id=10090
else
    spec_id=3702 #tair
fi

#We only take the prediction or curated disorder priority, if the entry doenst have those fields, we dont take them
while IFS= read -r line; do
    id=$(echo "$line" |awk '{print $1}')
    seq=$(curl -s "https://mobidb.org/api/download_page?acc=$id&ncbi_taxon_id=$spec_id" | jq -r '.data[0].sequence')
    echo -e "$id\t$seq" >> mobi_entry_full_aa_seq_$2.tsv #normally the file has the same number of lines has the disorder one (when both are sort -u) but because we corrected a few id manually later now it has just a bit more but no
                                                            # care because its a dictionnary

done < dl_id_tmp 
rm dl_id_tmp

#bash ~/Data/repoexonhancer/structure_prot/mobidb/3_request_seq_from_mobidb.sh disorder_prediction_mobidb_