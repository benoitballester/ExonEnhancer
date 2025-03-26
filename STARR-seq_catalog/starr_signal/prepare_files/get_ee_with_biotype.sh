#!/bin/bash

# in top 3 biotypes
grep "Myeloid" exons_Biotypes_majority_bilan.tsv |awk '{print $1}' > id 
grep -Ff id hg38_EE.bed > top3_myeloid.bed

grep "Embryonic" exons_Biotypes_majority_bilan.tsv |awk '{print $1}' > id 
grep -Ff id hg38_EE.bed > top3_embryonic.bed

grep "Musculoskeletal" exons_Biotypes_majority_bilan.tsv |awk '{print $1}' > id 
grep -Ff id hg38_EE.bed > top3_musculoskeletal.bed

# top 1 biotype
awk '{if ($4=="Myeloid") print $1}' exons_Biotypes_majority_bilan.tsv > id
grep -Ff id hg38_EE.bed > top1_myeloid.bed

awk '{if ($4=="Embryonic") print $1}' exons_Biotypes_majority_bilan.tsv > id
grep -Ff id hg38_EE.bed > top1_embryonic.bed

awk '{if ($4=="Musculoskeletal") print $1}' exons_Biotypes_majority_bilan.tsv > id
grep -Ff id hg38_EE.bed > top1_musculoskeletal.bed

awk '{if ($4=="Respiratory") print $1}' exons_Biotypes_majority_bilan.tsv > id
grep -Ff id hg38_EE.bed > top1_respiratory.bed

#top 1 biotype and tf of biotype >=50%
awk '{if ($4=="Myeloid" && $3=="TRUE") print $1}' exons_Biotypes_majority_bilan.tsv > id
grep -Ff id hg38_EE.bed > maj_myeloid.bed

awk '{if ($4=="Embryonic" && $3=="TRUE") print $1}' exons_Biotypes_majority_bilan.tsv > id
grep -Ff id hg38_EE.bed > maj_embryonic.bed

awk '{if ($4=="Musculoskeletal" && $3=="TRUE") print $1}' exons_Biotypes_majority_bilan.tsv > id
grep -Ff id hg38_EE.bed > maj_musculoskeletal.bed
rm id 

#random regions 
bedtools random -g hg38_sizes.genome -n 20000 -l 164 -seed 1234 > tmp
awk '{print $1,$2,$3,$6}' OFS=$'\t' tmp > tmp1
sort -k 1,1 -k 2,2n tmp1 > random_regions.bed
rm tmp tmp1

#ctrl pos #we limit the size for computational ressources
shuf -n 20000 control_pos_10TF_enhD_NoTSS_TES_10TFmin.tsv > tmp
awk '{print $1,$2,$3}' OFS=$'\t' tmp > tmp1
sort -k 1,1 -k 2,2n tmp1 > control_pos_limited_coordinates.bed
rm tmp tmp1 
