 #!/bin/bash
 # overlap with remap non redundant 

###hg38
##get coordinates for each track of plots; we want the coordinates of the corresponding exons and not just the lifted coordinates
#EE hg38 that are EE mm39
awk '{print $8}' ovlp_hg38_to_eemm39 |sort -u > tmp
grep -Ff tmp /home/mouren/Data/conservation/gencode_and_coords/ee_coords_mm39 |awk '{$2=$2-1000; $3=$3+1000; print;}' OFS=$'\t' |sort -u |sort -k1,1 -k2,2n > eehg38_as_eemm39
rm tmp

#EE hg38 that are mm39 exons
awk '{print $4}' ovlp_hg38_to_eemm39 |sort -u > tmp
grep -vFf tmp ovlp_hg38_to_allExonsmm39 > tmp1
python /home/mouren/Data/repoexonhancer/conservation/alignment_pairwise/2_overlap_with_remap.py tmp1
awk '{$2=$2-1000; $3=$3+1000; print;}' OFS=$'\t' tmp_data |sort -u |sort -k1,1 -k2,2n > eehg38_as_exonsmm39
rm tmp tmp1 tmp_data

#Ctrl Neg hg38 in mm39
python /home/mouren/Data/repoexonhancer/conservation/alignment_pairwise/2_overlap_with_remap.py /home/mouren/Data/conservation/hg38_mm39_comparison/alignment_pairwise_LASTZ_NET/control/ovlp_ctrlneghg38_to_allExonsmm39
awk '{$2=$2-1000; $3=$3+1000; print;}' OFS=$'\t' tmp_data |sort -u |sort -k1,1 -k2,2n > ctrlneghg38_as_exonsmm39
rm tmp_data

###### Overlap 
bedtools intersect -a eehg38_as_eemm39 -b /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_nr_macs2_mm39_v1_0.bed -wa -wb > overlap_remap/eehg38_as_eemm39_remap
bedtools intersect -a eehg38_as_exonsmm39 -b /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_nr_macs2_mm39_v1_0.bed -wa -wb > overlap_remap/eehg38_as_exonsmm39_remap
bedtools intersect -a ctrlneghg38_as_exonsmm39 -b /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_nr_macs2_mm39_v1_0.bed -wa -wb > overlap_remap/ctrlneghg38_as_exonsmm39_remap

echo "eehg38_as_eemm39"
awk '{print $4}' eehg38_as_eemm39 |sort -u |wc -l

echo "eehg38_as_exonsmm39"
awk '{print $4}' eehg38_as_exonsmm39 |sort -u |wc -l

echo "ctrlneghg38_as_exonsmm39"
awk '{print $4}' ctrlneghg38_as_exonsmm39 |sort -u |wc -l

mv eehg38_as_eemm39 eehg38_as_exonsmm39 ctrlneghg38_as_exonsmm39 overlap_remap/coords/