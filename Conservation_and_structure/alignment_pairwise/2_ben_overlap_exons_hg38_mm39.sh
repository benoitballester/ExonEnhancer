#!/bin/bash

### ee
bedtools intersect -a ./treated/hg38_ee_mm39_treated.bed -b /home/mouren/Data/conservation/gencode_and_coords/ee_coords_mm39 -wa -wb > ovlp_hg38_to_eemm39

bedtools intersect -a ./treated/hg38_ee_mm39_treated.bed -b /home/mouren/Data/conservation/gencode_and_coords/allCodingExons_mm39.bed -wa -wb > ovlp_hg38_to_allExonsmm39

### controls neg 
bedtools intersect -a ./treated/hg38_ctrlneg_mm39_treated.bed -b /home/mouren/Data/conservation/gencode_and_coords/ee_coords_mm39 -wa -wb > ovlp_ctrlneghg38_to_eemm39

bedtools intersect -a ./treated/hg38_ctrlneg_mm39_treated.bed -b /home/mouren/Data/conservation/gencode_and_coords/allCodingExons_mm39.bed -wa -wb > ovlp_ctrlneghg38_to_allExonsmm39

### controls pos 
bedtools intersect -a ./treated/hg38_ctrlpos_mm39_treated.bed -b /home/mouren/Data/conservation/gencode_and_coords/ctrlpos_coords_mm39 -wa -wb > ovlp_ctrlposhg38_to_ctrlposmm39

### Results
## EE HG
# Number of ee not lifted:
lifted_ee=$(awk '{print $4}' ./treated/hg38_ee_mm39_treated.bed |sort -u |wc -l)
total_ee_hg=$(wc -l /home/mouren/Data/conservation/gencode_and_coords/ee_coords_hg38 |cut -f1 -d' ')
count=$((total_ee_hg-lifted_ee))
perc=$(echo "scale=3; $count*100/$total_ee_hg" | bc) #In bash, to divide a number by a greater number, we need to use this syntax instead of $((x / y)), because that one will be truncated 
echo "HG EE Not lifted:${count} Perc:${perc}"

# Number of ee lifted but not mapping exons
total_ee_hg_as_exons_mm=$(awk '{print $4}' ovlp_hg38_to_allExonsmm39 |sort -u |wc -l)
count=$((lifted_ee-total_ee_hg_as_exons_mm))
perc=$(echo "scale=3; $count*100/$total_ee_hg" | bc)
echo "HG EE Lifted but not mapping exons:${count} Perc:${perc}"

# Number of ee hg mapping ee mm
ee_mm_mapped=$(awk '{print $4}' ovlp_hg38_to_eemm39 |sort -u |wc -l)
perc=$(echo "scale=3; $ee_mm_mapped*100/$total_ee_hg" | bc)
echo "HG EE mapping ee mm:${ee_mm_mapped} Perc:${perc}"

# Number of ee of mapping normal exons 
awk '{print $4}' ovlp_hg38_to_eemm39 |sort -u > tmp
ee_hg_mapping_exons_but_not_ee=$(grep -vFf tmp ovlp_hg38_to_allExonsmm39 |awk '{print $4}' |sort -u |wc -l)
perc=$(echo "scale=3; $ee_hg_mapping_exons_but_not_ee*100/$total_ee_hg" | bc)
echo "HG EE mapping exon mm but not ee:${ee_hg_mapping_exons_but_not_ee} Perc:${perc}"
rm tmp

## CTRL NEG HG
# Number of ee not lifted:
lifted_ee=$(awk '{print $4}' ./treated/hg38_ctrlneg_mm39_treated.bed |sort -u |wc -l)
total_ee_hg=$(wc -l /home/mouren/Data/conservation/gencode_and_coords/ctrlneg_coords_hg38 |cut -f1 -d' ')
count=$((total_ee_hg-lifted_ee))
perc=$(echo "scale=3; $count*100/$total_ee_hg" | bc) #In bash, to divide a number by a greater number, we need to use this syntax instead of $((x / y)), because that one will be truncated 
echo "CTRL NEG HG Not lifted:${count} Perc:${perc}"

# Number of ee lifted but not mapping exons
total_ee_hg_as_exons_mm=$(awk '{print $4}' ovlp_ctrlneghg38_to_allExonsmm39 |sort -u |wc -l)
count=$((lifted_ee-total_ee_hg_as_exons_mm))
perc=$(echo "scale=3; $count*100/$total_ee_hg" | bc)
echo "CTRL NEG HG Lifted but not mapping exons:${count} Perc:${perc}"

# Number of ee hg mapping ee mm
ee_mm_mapped=$(awk '{print $4}' ovlp_ctrlneghg38_to_eemm39 |sort -u |wc -l)
perc=$(echo "scale=3; $ee_mm_mapped*100/$total_ee_hg" | bc)
echo "CTRL NEG HG mapping ee mm:${ee_mm_mapped} Perc:${perc}"

# Number of ee of mapping normal exons 
awk '{print $4}' ovlp_ctrlneghg38_to_eemm39 |sort -u > tmp
ee_hg_mapping_exons_but_not_ee=$(grep -vFf tmp ovlp_ctrlneghg38_to_allExonsmm39 |awk '{print $4}' |sort -u |wc -l)
perc=$(echo "scale=3; $ee_hg_mapping_exons_but_not_ee*100/$total_ee_hg" | bc)
echo "CTRL NEG HG mapping exon mm but not ee:${ee_hg_mapping_exons_but_not_ee} Perc:${perc}"
rm tmp

## CTRL POS HG
# Number of ee not lifted:
lifted_ee=$(awk '{print $4}' ./treated/hg38_ctrlpos_mm39_treated.bed |sort -u |wc -l)
total_ee_hg=$(wc -l /home/mouren/Data/conservation/gencode_and_coords/ctrlpos_coords_hg38 |cut -f1 -d' ')
count=$((total_ee_hg-lifted_ee))
perc=$(echo "scale=3; $count*100/$total_ee_hg" | bc) #In bash, to divide a number by a greater number, we need to use this syntax instead of $((x / y)), because that one will be truncated 
echo "CTRL POS HG Not lifted:${count} Perc:${perc}"

# Number of ee lifted but not mapping exons
total_ee_hg_as_exons_mm=$(awk '{print $4}' ovlp_ctrlposhg38_to_ctrlposmm39 |sort -u |wc -l)
count=$((lifted_ee-total_ee_hg_as_exons_mm))
perc=$(echo "scale=3; $count*100/$total_ee_hg" | bc)
echo "CTRL POS HG Lifted but not mapping ctrlpos mm:${count} Perc:${perc}"

# Number of ee hg mapping ee mm
ee_mm_mapped=$(awk '{print $4}' ovlp_ctrlposhg38_to_ctrlposmm39 |sort -u |wc -l)
perc=$(echo "scale=3; $ee_mm_mapped*100/$total_ee_hg" | bc)
echo "CTRL POS HG mapping ee ctrlpos mm:${ee_mm_mapped} Perc:${perc}"

### Move control
mv *ctrlneg* control/

### Results 
# HG EE Not lifted:82 Perc:0.608
# HG EE Lifted but not mapping exons:121 Perc:0.897
# HG EE mapping ee mm:3740 Perc:27.742
# HG EE mapping exon mm but not ee:9538 Perc:70.751
# CTRL NEG HG Not lifted:828 Perc:6.247
# CTRL NEG HG Lifted but not mapping exons:430 Perc:3.244
# CTRL NEG HG mapping ee mm:316 Perc:2.384
# CTRL NEG HG mapping exon mm but not ee:11679 Perc:88.123
# CTRL POS HG Not lifted:148857 Perc:36.816
# CTRL POS HG Lifted but not mapping ctrlpos mm:210944 Perc:52.171
# CTRL POS HG mapping ee ctrlpos mm:44524 Perc:11.011