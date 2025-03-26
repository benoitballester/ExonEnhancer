#!/bin/bash 

### MM39
# We only want the summit or middle of STARR-peaks 
awk 'OFS="\t" {
  if ($10 == "NA") { #No summit data 
    diff  = int(($3 - $2) / 2)
    start = $2 + diff
    end   = start + 1
    print $1,start,end,$4,$5,$6,$7,$8,$9,$10
  } else {
    sum = $2 + $10
    end = sum + 1
    print $1,sum,end,$4,$5,$6,$7,$8,$9,$10
  }
}' ./STARR-seq_catalog/ENCODE_GEO_active_mm39_sorted.narrowPeak > tmp_mm39

#intersect
bedtools intersect -a ./EE_selection/mm39_EE.bed -b tmp_mm39 -wa -wb > ./STARR-seq_catalog/overlap/mm39_ee.tsv
bedtools intersect -a ./Control_selection/mm39_control_neg_NoTF_NoTSS_TES_prom.tsv -b tmp_mm39 -wa -wb > ./STARR-seq_catalog/overlap/mm39_neg.tsv
bedtools intersect -a ./Control_selection/mm39_control_pos_enhD_NoTSS_TES_10TFmin.tsv -b tmp_mm39 -wa -wb > ./STARR-seq_catalog/overlap/mm39_pos.tsv
rm tmp_mm39

### DM6
# We only want the summit or middle of STARR-peaks 
awk 'OFS="\t" {
  if ($10 == "NA") { #No summit data 
    diff  = int(($3 - $2) / 2)
    start = $2 + diff
    end   = start + 1
    print $1,start,end,$4,$5,$6,$7,$8,$9,$10
  } else {
    sum = $2 + $10
    end = sum + 1
    print $1,sum,end,$4,$5,$6,$7,$8,$9,$10
  }
}' ./STARR-seq_catalog/ENCODE_GEO_active_dm6_sorted.narrowPeak > tmp_dm6

#intersect
bedtools intersect -a ./EE_selection/dm6_EE.bed -b tmp_dm6 -wa -wb > ./STARR-seq_catalog/overlap/dm6_ee.tsv
bedtools intersect -a ./Control_selection/dm6_control_neg_NoTF_NoTSS_TES.tsv -b tmp_dm6 -wa -wb > ./STARR-seq_catalog/overlap/dm6_neg.tsv
bedtools intersect -a ./Control_selection/dm6_control_pos_NoTSS_TES_10TFmin.tsv -b tmp_dm6 -wa -wb > ./STARR-seq_catalog/overlap/dm6_pos.tsv
rm tmp_dm6

### TAIR10
# We only want the summit or middle of STARR-peaks 
awk 'OFS="\t" {
  if ($10 == "NA") { #No summit data 
    diff  = int(($3 - $2) / 2)
    start = $2 + diff
    end   = start + 1
    print $1,start,end,$4,$5,$6,$7,$8,$9,$10
  } else {
    sum = $2 + $10
    end = sum + 1
    print $1,sum,end,$4,$5,$6,$7,$8,$9,$10
  }
}' ./STARR-seq_catalog/Tan2023_active_tair10_sorted.narrowPeak > tmp_tair10

#intersect
bedtools intersect -a ./EE_selection/other_species/tair10_EE_nochr.bed -b tmp_tair10 -wa -wb > ./STARR-seq_catalog/overlap/tair10_ee.tsv
bedtools intersect -a ./Control_selection/other_species/tair10_control_neg_NoTF_NoTSS_TES_nochr.tsv -b tmp_tair10 -wa -wb > ./STARR-seq_catalog/overlap/tair10_neg.tsv
bedtools intersect -a ./Control_selection/other_species/tair10_control_pos_NoTSS_TES_10TFmin_nochr.tsv -b tmp_tair10 -wa -wb > ./STARR-seq_catalog/overlap/tair10_pos.tsv
rm tmp_tair10

### HG38
# We only want the summit or middle of STARR-peaks 
awk 'OFS="\t" {
  if ($10 == "NA") { #No summit data 
    diff  = int(($3 - $2) / 2)
    start = $2 + diff
    end   = start + 1
    print $1,start,end,$4,$5,$6,$7,$8,$9,$10
  } else {
    sum = $2 + $10
    end = sum + 1
    print $1,sum,end,$4,$5,$6,$7,$8,$9,$10
  }
}' ./STARR-seq_catalog/ENCODE_GEO_active_hg38_sorted.narrowPeak |sort -k1,1 -k2,2n > tmp_hg38

#intersect
bedtools intersect -sorted -a ./EE_selection/hg38_EE.bed -b tmp_hg38 -wa -wb > ./STARR-seq_catalog/overlap/hg38_ee.tsv
bedtools intersect -sorted -a ./Control_selection/control_neg_NoTF_NoTSS_TES_prom.tsv -b tmp_hg38 -wa -wb > ./STARR-seq_catalog/overlap/hg38_neg.tsv
bedtools intersect -sorted -a ./Control_selection/control_pos_enhD_NoTSS_TES_10TFmin.tsv -b tmp_hg38 -wa -wb > ./STARR-seq_catalog/overlap/hg38_pos.tsv
rm tmp_hg38

### SEE OVERLAP RESULTS
a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/mm39_ee.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/12244" | bc)
echo "MM EE STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/mm39_neg.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/18457" | bc)
echo "MM NEG STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/mm39_pos.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/149241" | bc)
echo "MM POS STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/dm6_ee.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/13688" | bc)
echo "DM EE STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/dm6_neg.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/903" | bc)
echo "DM NEG STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/dm6_pos.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/133253" | bc)
echo "DM POS STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/tair10_ee.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/7138" | bc)
echo "TAIR EE STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/tair10_neg.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/7862" | bc)
echo "TAIR NEG STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/tair10_pos.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/9025" | bc)
echo "TAIR POS STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/hg38_ee.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/13481" | bc)
echo "HG EE STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/hg38_neg.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/13253" | bc)
echo "HG NEG STARR: ${a} Perc:${perc}"

a=$(awk '{print $4}' ./STARR-seq_catalog/overlap/hg38_pos.tsv |sort -u |wc -l)
perc=$(echo "scale=3; $a*100/404325" | bc)
echo "HG POS STARR: ${a} Perc:${perc}"

# MM EE STARR: 72 Perc:0.588
# MM NEG STARR: 12 Perc:0.065
# MM POS STARR: 6649 Perc:4.455
# DM EE STARR: 3690 Perc:26.957
# DM NEG STARR: 19 Perc:2.104
# DM NEG STARR 5 : 238 Perc:5.065
# DM NEG STARR 5eq: 301 Perc:5.159
# DM POS STARR: 48812 Perc:36.631
# TAIR EE STARR: 403 Perc:5.645
# TAIR NEG STARR: 14 Perc:0.178
# TAIR POS STARR: 322 Perc:3.567
# HG EE STARR: 9095 Perc:67.465
# HG NEG STARR: 2041 Perc:15.400
# HG POS STARR: 264445 Perc:65.404

#Count nb of peaks by dataset in catalogs
#awk '{print $4}' dm6_ee.tsv |cut -d_ -f1 |sort |uniq -c |awk '{print $2,$1}' OFS=$'\t' |sort -k1,1

#Count nb of peaks in EE by datasets
#awk '{print $10}' dm6_ee.tsv |cut -d_ -f1 |sort |uniq -c |awk '{print $2,$1}' OFS=$'\t' |sort -k1,1

#Count nb of EE overlapped by datasets
#awk '{split($10,a,"_"); print $4,a[1]}' OFS='\t' dm6_ee.tsv |sort -u |awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' OFS=$'\t' |sort -k1,1