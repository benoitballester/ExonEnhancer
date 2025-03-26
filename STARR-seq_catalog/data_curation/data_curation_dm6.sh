#!/bin/bash
## p-val already filtered ; no fc <= 0
awk '{nlog10_1=-(log($4)/log(10)); print $1,$2-1,$2,"GSE40739_S2_rep1_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE40739_dm3/GSM1000400_S2_STARRseq_rep1.peaks.txt > tmp  #raw file header is the chromosome, the summit position, the enrichment over input (log2-scale) at the summit, and the p-value.
awk '{nlog10_1=-(log($4)/log(10)); print $1,$2-1,$2,"GSE40739_S2_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE40739_dm3/GSM1000401_S2_STARRseq_rep2.peaks.txt >> tmp
awk '{nlog10_1=-(log($4)/log(10)); print $1,$2-1,$2,"GSE40739_OSC_rep1_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE40739_dm3/GSM1000402_OSC_STARRseq_rep1.peaks.txt >> tmp
awk '{nlog10_1=-(log($4)/log(10)); print $1,$2-1,$2,"GSE40739_OSC_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE40739_dm3/GSM1000403_OSC_STARRseq_rep2.peaks.txt >> tmp

## no fc <= 0
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_S2_with_ecd_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357048_S2_STARRseq_with_ecd_rep2.peaks.txt >> tmp  #raw file header is the chromosome, the summit position, the enrichment over input (log2-scale) at the summit, and the p-value.
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_S2_with_ecd_rep1_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357047_S2_STARRseq_with_ecd_rep1.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_S2_no_ecd_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357046_S2_STARRseq_no_ecd_rep2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_S2_no_ecd_rep1_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357045_S2_STARRseq_no_ecd_rep1.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_OSC_with_ecd_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357057_OSC_STARRseq_with_ecd_rep2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_OSC_with_ecd_rep1_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357056_OSC_STARRseq_with_ecd_rep1.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_OSC_no_ecd_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357055_OSC_STARRseq_no_ecd_rep2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE47691_OSC_no_ecd_rep1_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE47691_dm3/GSM1357054_OSC_STARRseq_no_ecd_rep1.peaks.txt >> tmp

## p-val already filtered; no fc <= 0
LC_ALL=C awk '{nlog10_1=-(log($5)/log(10)); print $1,$2,$3,"GSE49809_BG3_DSCP_"NR,"0",".",$4,nlog10_1,"NA","NA"}' OFS=$'\t' GSE49809_BG3_Dmel_DSCP_500bp.peaks_dm3.txt >> tmp

## no fc <= 0
LC_ALL=C awk '{nlog10_1=-(log($9)/log(10)); if ($9<0.05) print $1,$2-1,$2,"GSE96542_DMSO_"NR,"0",".",$8,nlog10_1,"NA","NA"}' OFS=$'\t' GSE96542_KcWT_STARR_DMSO.merged.pe.peaks_dm3.txt >> tmp 
LC_ALL=C awk '{nlog10_1=-(log($9)/log(10)); if ($9<0.05) print $1,$2-1,$2,"GSE96542_inh_"NR,"0",".",$8,nlog10_1,"NA","NA"}' OFS=$'\t' GSE96542_KcWT_STARR_inh.merged.pe.peaks_dm3.txt >> tmp 

## no p-val
awk '(NR>1)' GSE183937_S2_oligo_library_counts_dm3.txt |awk '{if ($4=="wt") print $0}' OFS=$'\t' > dud
awk '{split($1,a,"_"); if ($20>0 && $20!="NA") print a[1],a[2],a[3],"GSE183937_S2_"a[6]"_dev_"NR,"0",a[4],$20,"NA","NA","NA"}' OFS=$'\t' dud >> tmp
awk '{split($1,a,"_"); if ($21>0 && $21!="NA") print a[1],a[2],a[3],"GSE183937_S2_"a[6]"_hk_"NR,"0",a[4],$21,"NA","NA","NA"}' OFS=$'\t' dud >> tmp
rm dud

awk '(NR>1)' GSE183937_S2_oligo_library_counts_dm3.txt |awk '{if ($4=="wt") print $0}' OFS=$'\t' > dud
awk '{split($1,a,"_"); if ($20<=0 && $20!="NA") print a[1],a[2],a[3],"GSE183937_S2_"a[6]"_dev_"NR,"0",a[4],$20,"NA","NA","NA"}' OFS=$'\t' dud >> tmp_no
awk '{split($1,a,"_"); if ($21<=0 && $21!="NA") print a[1],a[2],a[3],"GSE183937_S2_"a[6]"_hk_"NR,"0",a[4],$21,"NA","NA","NA"}' OFS=$'\t' dud >> tmp_no
rm dud

## p-val already filtered ; no fc <= 0
awk '(NR>1)' GSE183936_S2_hk_STARRseq_merged.peaks_dm3.txt |awk '{nlog10_1=-(log($9)/log(10)); print $1,$2-1,$2,"GSE183936_S2_hk_"NR,"0",".",$8,nlog10_1,"NA","NA"}' OFS=$'\t' >> tmp
awk '(NR>1)' GSE183936_S2_dev_STARRseq_merged.peaks_dm3.txt |awk '{nlog10_1=-(log($9)/log(10)); print $1,$2-1,$2,"GSE183936_S2_dev_"NR,"0",".",$8,nlog10_1,"NA","NA"}' OFS=$'\t' >> tmp

## no fc <= 0
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_DSCP_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_DSCP_BAC_S2.peaks.txt >> tmp  #raw file header is the chromosome, the summit position, the enrichment over input (log2-scale) at the summit, and the p-value.
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_NipB_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_NipB_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_NipB_S2_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_NipB_S2_rep2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_RpS12_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_RpS12_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_X16_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_X16_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_X16_S2_rep2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_X16_S2_rep2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_dCP_OSC_merged_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_dCP_OSC_merged.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_dCP_S2_merged_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_dCP_S2_merged.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_eEF1delta_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_eEF1delta_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_eEF1delta_S2_rep1_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_eEF1delta_S2_rep1.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_eve_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_eve_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_evelong_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_evelong_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_hkCP_OSC_merged_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_hkCP_OSC_merged.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_hkCP_S2_merged_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_hkCP_S2_merged.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_hsp70_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_hsp70_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_pnr_BAC_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_pnr_BAC_S2.peaks.txt >> tmp
LC_ALL=C awk '{nlog10_1=-(log($4)/log(10)); if ($4<0.05) print $1,$2-1,$2,"GSE57876_pnr_S2_"NR,"0",".",$3,nlog10_1,"NA","NA"}' OFS=$'\t' GSE57876_dm3/GSE57876_pnr_S2.peaks.txt >> tmp

## data of the deepstarr tool; pval not present but already filtered
awk '(NR>1)' deepstarr_GSE183939_all_sequences_activity.txt |LC_ALL=C awk '{if ($7>0) print}' OFS=$'\t' > dev
awk '(NR>1)' deepstarr_GSE183939_all_sequences_activity.txt |LC_ALL=C awk '{if ($8>0) print}' OFS=$'\t' > hk

awk '{print $1,$2,$3,"GSE183939_dev_S2",$7}' OFS=$'\t' dev |sort -u |awk '{print $1,$2,$3,$4"_"NR,"0",".",$5,"NA","NA","NA"}' OFS=$'\t' >> tmp #we sort -u to remove the sequences reverse complemented added for the training of the model
awk '{print $1,$2,$3,"GSE183939_hk_S2",$8}' OFS=$'\t' hk |sort -u |awk '{print $1,$2,$3,$4"_"NR,"0",".",$5,"NA","NA","NA"}' OFS=$'\t' >> tmp 
rm dev hk

awk '(NR>1)' deepstarr_GSE183939_all_sequences_activity.txt |LC_ALL=C awk '{if ($7<=0) print}' OFS=$'\t' > dev
awk '(NR>1)' deepstarr_GSE183939_all_sequences_activity.txt |LC_ALL=C awk '{if ($8<=0) print}' OFS=$'\t' > hk

awk '{print $1,$2,$3,"GSE183939_dev_S2",$7}' OFS=$'\t' dev |sort -u |awk '{print $1,$2,$3,$4"_"NR,"0",".",$5,"NA","NA","NA"}' OFS=$'\t' >> tmp_no #we sort -u to remove the sequences reverse complemented added for the training of the model
awk '{print $1,$2,$3,"GSE183939_hk_S2",$8}' OFS=$'\t' hk |sort -u |awk '{print $1,$2,$3,$4"_"NR,"0",".",$5,"NA","NA","NA"}' OFS=$'\t' >> tmp_no 
rm dev hk

##
sort -k1,1 -k2,2n tmp > tmp1
~/UCSC_commands/liftOver -bedPlus=6 tmp1 ../dm3ToDm6.over.chain a unmap
rm tmp tmp1 unmap

grep -v chrUn_DS485357v1 a > b
grep -v chrUn_DS485746v1 b > ENCODE_GEO_active_dm6_sorted.narrowPeak
rm a b

sort -k1,1 -k2,2n tmp_no > tmp1
~/UCSC_commands/liftOver -bedPlus=6 tmp1 ../dm3ToDm6.over.chain a unmap
rm tmp_no tmp1 unmap

grep -v chrUn_DS485357v1 a > b
grep -v chrUn_DS485746v1 b > ENCODE_GEO_silent_dm6_sorted.narrowPeak
rm a b