#!/bin/bash
# $1 = tcga_snp_exonhancers_raw_uniques.tsv #344777
awk '{print $1,$2,$3,$1":"$3$4">"$5}' OFS=$'\t' $1 |sort -u |sort -k1,1 -k2,2n - > coords

while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /home/mouren/Data/jaspar_files/JASPAR2022_hg19.bb /home/mouren/Data/variants/tcga_MC3/tmp
    awk -v a="$name" '{print a,$7}' OFS=$'\t' /home/mouren/Data/variants/tcga_MC3/tmp >> tmp1

done < coords
sort -u tmp1 > jaspar_tcga_precise.tsv
rm /home/mouren/Data/variants/tcga_MC3/tmp tmp1

bedtools intersect -a coords -b /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_nr_macs2_hg19_v1_0.bed -wa -wb > ovlp
awk '{split($8,a,":"); print $4,a[1]}' OFS=$'\t' ovlp > remap_tcga_precise.tsv

rm coords ovlp
