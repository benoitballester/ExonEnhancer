#!/bin/bash
# id files created with a command like this : awk '{print $1".bed""\t"$1"."$13}' metadata_narrowpeaks.tsv > ids
# to download files : xargs -L 1 curl -O -J -L < files.txt

while IFS= read -r line
do
    file_name=$(echo $line |cut -f1 -d" ")
    to_replace=$(echo $line |cut -f2 -d" ")

    awk -v OFS="\t" '$1=$1' $2/files/$file_name > tabulated_$file_name

    awk -v x=$to_replace -F $'\t' '{t=$4; $4=x"."t; print;}' OFS=$'\t' tabulated_$file_name > id_$file_name
    mv id_$file_name $2/treated_files/id_$file_name
    rm tabulated_$file_name

done < $1