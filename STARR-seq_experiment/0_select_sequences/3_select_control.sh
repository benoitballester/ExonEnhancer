#!bin/bash

###control selection
##neg
awk '{sum=$3-$2; print $1,$2,$3,$4,sum}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/control/control_neg_NoTF_NoTSS_TES_prom.tsv > neg_sizes
awk '{if ($5>=130) print}' neg_sizes > negmin

awk '{if ($5==0) print $4}' /home/mouren/Data/final_files_tokeep/dnase_atac/venn_plot/control/neg_atac_atlas > neg_atac_id
awk '{if ($5==0) print $4}' /home/mouren/Data/final_files_tokeep/dnase_atac/venn_plot/control/neg_dnase_atlas > neg_dnase_id
awk '{if ($5==0) print $4}' /home/mouren/Data/final_files_tokeep/dnase_atac/venn_plot/control/neg_dnase_encode > neg_encode_id

sort neg_atac_id -o neg_atac_id_sorted
sort neg_dnase_id -o neg_dnase_id_sorted
sort neg_encode_id -o neg_encode_id_sorted

# Find common IDs among the three sorted files
comm -12 neg_atac_id_sorted neg_dnase_id_sorted > tmp
comm -12 tmp neg_encode_id_sorted > neg_tot_id

grep -Ff neg_tot_id negmin > negmin_noact

awk '{if ($5<=220) print $1,$2,$3,$4}' OFS=$'\t' negmin_noact > NegCtrl_goodSize_NoAct.tsv

rm neg_sizes negmin neg_atac_id neg_dnase_id neg_encode_id neg_atac_id_sorted neg_dnase_id_sorted neg_encode_id_sorted tmp neg_tot_id negmin_noact 

#get the 1500 with lowest jaspar score
while IFS= read -r line; do
    chr=$(echo "$line" |awk '{print $1}')
    start=$(echo "$line" |awk '{print $2}')
    end=$(echo "$line" |awk '{print $3}')
    name=$(echo "$line" |awk '{print $4}')  

    ~/UCSC_commands/bigBedToBed -chrom=${chr} -start=$start -end=$end /home/mouren/Data/jaspar_files/JASPAR2022_upd_hg38.bb /home/mouren/Data/valid_exp_starr/control/tmp
    awk -v a="$name" '{print a,$5}' OFS=$'\t' /home/mouren/Data/valid_exp_starr/control/tmp >> tmp1

done < NegCtrl_goodSize_NoAct.tsv
sort -k1,1 -k2,2nr tmp1 | awk '!seen[$1]++' |sort -k2,2n - |head -n 1463 |awk '{print $1}' > id #lowest scores
grep -Ff id NegCtrl_goodSize_NoAct.tsv > tmp2

awk '{split($4,a,"_"); strand=a[7]; if (strand=="r") sens="-"; if (strand=="f") sens="+"; print $1,$2,$3,$4,"0",sens}' OFS=$'\t' tmp2 > NegCtrl_1463_goodSize_NoAct_LowScoresJaspar_coords.tsv
rm tmp tmp1 id tmp2
#awk '{print $1}' tmp1 |uniq -c |sort -k1,1nr - > count #nb of tfbs

##pos
awk '{sum=$3-$2; print $1,$2,$3,$4,sum}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/control/control_pos_enhD_NoTSS_TES_10TFmin.tsv > pos_sizes
awk '{if ($5>=130) print}' pos_sizes > posmin
awk '{if ($5<=220) print}' posmin > posmin_max

bedtools intersect -sorted -a posmin_max -b /home/mouren/Data/final_files_tokeep/raw_important/remap/remap2022_nr_macs2_hg38_v1_0.bed -wa -wb > ovlp

grep K-562 ovlp > resk
grep A-549 ovlp > resa
grep GM12878 ovlp > resg

awk '{print $4}' resk |uniq -c > tmpk
awk '{print $4}' resa |uniq -c > tmpa
awk '{print $4}' resg |uniq -c > tmpg

awk '{if ($1>=3) print $2}' tmpk |sort - > resk2
awk '{if ($1>=3) print $2}' tmpa |sort - > resa2
awk '{if ($1>=3) print $2}' tmpg |sort - > resg2

comm -12 resk2 resa2 > tmp
comm -12 tmp resg2 > tmp1

grep -Ff tmp1 /home/mouren/Data/final_files_tokeep/control/control_pos_enhD_NoTSS_TES_10TFmin.tsv > PosCtrl_goodSize_3_K562_A549_GM12878_NR_TF_min.tsv
rm pos_sizes posmin ovlp tmp posmin_max resk resa resg tmpk tmpa tmpg resk2 resa2 resg2 tmp1

shuf -n 1463 PosCtrl_goodSize_3_K562_A549_GM12878_NR_TF_min.tsv |sort -k1,1 -k2,2n - > PosCtrl_1463_goodSize_3_K562_A549_GM12878_NR_TF_min_coords.tsv


### 1 : DL references sequences from UCSC PosCtrl_1463_goodSize_3_K562_A549_GM12878_NR_TF_min_coords.tsv NegCtrl_1463_goodSize_NoAct_LowScoresJaspar_coords.tsv

#upload the file on UCSC, then go the table browser, select the track and "sequence" type of output, it will gives the fasta of the coordiantes

