#!/bin/bash
##
awk '(NR>2)' 41467_2015_BFncomms7905_MOESM360_ESM_SalvaCapStarr_mm9.csv |awk '{if ($7=="Strong" || $7=="Weak") print $1,$2,$3,"PMID-25872643_P5424_"NR,"0",".",$6,"NA","NA","NA"}' OFS='\t' |sort -k1,1 -k2,2n > tmp
awk '(NR>2)' 41467_2015_BFncomms7905_MOESM360_ESM_SalvaCapStarr_mm9.csv |awk '{if ($9=="Strong" || $9=="Weak") print $1,$2,$3,"PMID-25872643_3T3_"NR,"0",".",$8,"NA","NA","NA"}' OFS='\t' |sort -k1,1 -k2,2n >> tmp

awk '(NR>2)' 41467_2015_BFncomms7905_MOESM360_ESM_SalvaCapStarr_mm9.csv |awk '{if ($7=="Inactive") print $1,$2,$3,"PMID-25872643_P5424_"NR,"0",".",$6,"NA","NA","NA"}' OFS='\t' |sort -k1,1 -k2,2n > tmp_no
awk '(NR>2)' 41467_2015_BFncomms7905_MOESM360_ESM_SalvaCapStarr_mm9.csv |awk '{if ($9=="Inactive") print $1,$2,$3,"PMID-25872643_3T3_"NR,"0",".",$8,"NA","NA","NA"}' OFS='\t' |sort -k1,1 -k2,2n >> tmp_no

~/UCSC_commands/liftOver -bedPlus=6 tmp ../mm9ToMm39.over.chain tmp1 unmap
cat tmp1 > tmp_final
rm tmp tmp1 unmap

~/UCSC_commands/liftOver -bedPlus=6 tmp_no ../mm9ToMm39.over.chain tmp1 unmap
cat tmp1 > tmp_final_no
rm tmp_no tmp1 unmap

##
awk '{print $1,$2,$3,"GSE121753_"NR,0,".","NA","NA","NA","NA"}' OFS=$'\t' GSE121753_STARRseq_aB_peaks_mm9.bed |sort -k1,1 -k2,2n > tmp
~/UCSC_commands/liftOver -bedPlus=6 tmp ../mm9ToMm39.over.chain tmp1 unmap
cat tmp1 >> tmp_final
rm tmp tmp1 unmap

##
awk '(NR>1)' GSE143544_STARRseq_2iL_SL_DEseq2_mm9.tsv |LC_ALL=C awk '{nlog10_1=-(log($25)/log(10)); nlog10_2=-(log($26)/log(10)); if ($24>0 && $26<0.05) print $2,$3,$4,"GSE143544_"NR,"0",".",$24,nlog10_1,nlog10_2,"NA"}' OFS=$'\t' |sort -k1,1 -k2,2n > tmp
~/UCSC_commands/liftOver -bedPlus=6 tmp ../mm9ToMm39.over.chain tmp1 unmap
cat tmp1 >> tmp_final
rm tmp tmp1 unmap

awk '(NR>1)' GSE143544_STARRseq_2iL_SL_DEseq2_mm9.tsv |LC_ALL=C awk '{nlog10_1=-(log($25)/log(10)); nlog10_2=-(log($26)/log(10)); if ($24<=0 && $26<0.05) print $2,$3,$4,"GSE143544_"NR,"0",".",$24,nlog10_1,nlog10_2,"NA"}' OFS=$'\t' |sort -k1,1 -k2,2n > tmp
awk -F'\t' '{if ($7!="") print;}' OFS=$'\t' tmp > tmpaa
~/UCSC_commands/liftOver -bedPlus=6 tmpaa ../mm9ToMm39.over.chain tmp1 unmap
cat tmp1 >> tmp_final_no
rm tmp tmp1 unmap tmpaa

##
awk '{print $1,$2,$3,"GSE171771_LIFdep_SummitMm9_"NR,$5,$6,$7,$8,$9,$10}' OFS=$'\t' GSE171771_FAIRE_STARR_enh_LIFdep_mm9.bed > tmp
awk '{print $1,$2,$3,"GSE171771_mESC_SummitMm9_"NR,$5,$6,$7,$8,$9,$10}' OFS=$'\t' GSE171771_FAIRE_STARR_enh_mESC_mm9.bed >> tmp
awk '{print $1,$2,$3,"GSE171771_RAind_SummitMm9_"NR,$5,$6,$7,$8,$9,$10}' OFS=$'\t' GSE171771_FAIRE_STARR_enh_RAind_mm9.bed >> tmp
sort -k1,1 -k2,2n tmp > tmp1
~/UCSC_commands/liftOver -bedPlus=6 tmp1 ../mm9ToMm39.over.chain tmp2 unmap
cat tmp2 >> tmp_final
rm tmp tmp1 tmp2 unmap

##
awk '{print $1,$2,$3,"GSE197005_"NR,$5,".","NA","NA","NA","NA"}' OFS=$'\t' GSE197005_starrpeaker_common_RNA_q09_peaks_mm10.bed |sort -k1,1 -k2,2n > tmp
~/UCSC_commands/liftOver -bedPlus=6 tmp ../mm10ToMm39.over.chain tmp1 unmap
cat tmp1 >> tmp_final
rm tmp tmp1 unmap

## Narrowpeak encode 
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7>0) print $1,$2,$3,"ENCFF428NIS_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF428NIS.bed > tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7>0) print $1,$2,$3,"ENCFF449JPD_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF449JPD.bed >> tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7>0) print $1,$2,$3,"ENCFF667UIB_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF667UIB.bed >> tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7>0) print $1,$2,$3,"ENCFF709PFP_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF709PFP.bed >> tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7>0) print $1,$2,$3,"ENCFF788NIT_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF788NIT.bed >> tmp
sort -k1,1 -k2,2n tmp > tmp1
~/UCSC_commands/liftOver -bedPlus=6 tmp1 ../mm10ToMm39.over.chain tmp2 unmap
cat tmp2 >> tmp_final
rm tmp tmp1 tmp2 unmap

LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7<=0) print $1,$2,$3,"ENCFF428NIS_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF428NIS.bed > tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7<=0) print $1,$2,$3,"ENCFF449JPD_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF449JPD.bed >> tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7<=0) print $1,$2,$3,"ENCFF667UIB_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF667UIB.bed >> tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7<=0) print $1,$2,$3,"ENCFF709PFP_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF709PFP.bed >> tmp
LC_ALL=C awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); if ($7<=0) print $1,$2,$3,"ENCFF788NIT_SummitMm9_"NR,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' ENCFF788NIT.bed >> tmp
sort -k1,1 -k2,2n tmp > tmp1
~/UCSC_commands/liftOver -bedPlus=6 tmp1 ../mm10ToMm39.over.chain tmp2 unmap
cat tmp2 >> tmp_final_no
rm tmp tmp1 tmp2 unmap

#
sort -k1,1 -k2,2n tmp_final > ENCODE_GEO_active_mm39_sorted.narrowPeak
rm tmp_final

sort -k1,1 -k2,2n tmp_final_no > ENCODE_GEO_silent_mm39_sorted.narrowPeak
rm tmp_final_no