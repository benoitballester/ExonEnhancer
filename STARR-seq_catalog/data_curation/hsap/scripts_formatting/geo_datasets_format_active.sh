#!bin/bash

### This file  list the formatting operation used for the different geo datasets 

# we formate everythong to narrowpeak format and nlog10 pval and qval when available 

# 1: GSE211657_HCT116_oligo_library_counts.txt
grep "Wt_enhancer" ./hsap/geo/raw/GSE211657_HCT116_oligo_library_counts.txt > tmp
awk '{print $2}' tmp |tr _ '\t' > tmp2
awk '{$4="GSE211657.HCT-116"; print;}' OFS=$'\t' tmp2 > tmp3
awk '{print "0",$5,$22,"NA","NA","NA"}' OFS=$'\t' tmp > tmp4 #5 strand 22 foldchange

paste tmp3 tmp4 > tmp5

LC_ALL=C awk '{if ($7>0) print;}' OFS=$'\t' tmp5 > tmp6
awk '{if ($7!="NA") print;}' OFS=$'\t' tmp6 > tmp7

rm tmp tmp2 tmp3 tmp4 tmp5 tmp6

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp7 ./hsap/hg19ToHg38.over.chain GSE211657_hg38lift.bed unmapped.txt # 2 unmapped.txt
echo "unmapped 1"
wc -l unmapped.txt

rm tmp7 unmapped.txt

cat GSE211657_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active

rm GSE211657_hg38lift.bed

# 2: GSE181317_GM12878_active_regions.bed GSE181317_GM12878_silent_regions.bed
awk '{$4="GSE181317.GM12878.active_regions"; print $1,$2,$3,$4,"0",$6,$5,"NA","NA","NA"}' OFS=$'\t' ./hsap/geo/raw/GSE181317_GM12878_active_regions.bed |sort -k 1,1 -k 2,2n > active

cat active >> ./hsap/geo/tmp_final_geo_active

rm active
# 3: GSE156740_Log2FC_psAuxin_vs_msAuxin_per_COF_for_common_set_of_enhancers.txt
awk '{print $1}' ./hsap/geo/raw/GSE156740_Log2FC_psAuxin_vs_msAuxin_per_COF_for_common_set_of_enhancers.txt |tr :- '\t' > tmp
awk '{$4="GSE156740.HCT-116"; $5="0"; $6="."; print;}' OFS=$'\t' tmp > tmp2

awk '{print $3}' ./hsap/geo/raw/GSE156740_Log2FC_psAuxin_vs_msAuxin_per_COF_for_common_set_of_enhancers.txt > col
paste tmp2 col > tmp3

awk '(NR>1)' tmp3 > tmp4 #skip header

sort -k 1,1 -k 2,2n tmp4 > tmp5

LC_ALL=C awk '{if ($7>0) print;}' OFS=$'\t' tmp5 > tmp6
awk '{print $1,$2,$3,$4,$5,$6,$7,"NA","NA","NA"}' OFS=$'\t' tmp6 > tmp7

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp7 ./hsap/hg19ToHg38.over.chain GSE156740_hg38lift.bed unmapped.txt # 0 unmapped.txt
echo "unmapped 3"
wc -l unmapped.txt

rm tmp tmp2 col tmp3 tmp4 tmp5 tmp6 tmp7 unmapped.txt

cat GSE156740_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active

rm GSE156740_hg38lift.bed

# 4: raw/GSE183938_HCT116_oligo_library_counts.txt
grep "Wt_enhancer" ./hsap/geo/raw/GSE183938_HCT116_oligo_library_counts.txt > tmp
awk '{print $2}' tmp |tr _ '\t' > tmp2
awk '{$4="GSE183938.HCT-116"; print;}' OFS=$'\t' tmp2 > tmp3
awk '{print "0",$5,$13,"NA","NA","NA"}' OFS=$'\t' tmp > tmp4

paste tmp3 tmp4 > tmp5
LC_ALL=C awk '{if ($7>0) print;}' OFS=$'\t' tmp5 > tmp6
awk '{if ($7!="NA") print;}' OFS=$'\t' tmp6 > tmp7

rm tmp tmp2 tmp3 tmp4 tmp5 tmp6

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp7 ./hsap/hg19ToHg38.over.chain GSE183938_hg38lift.bed unmapped.txt # 2 unmapped.txt
echo "unmapped 4"
wc -l unmapped.txt

rm tmp7 unmapped.txt

cat GSE183938_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE183938_hg38lift.bed

# 5: GSE180152_RAW.tar.gz pval and qval are nlog10
# No nlog10(qvalue) < 1.3 (0.05) 
# No fold change < 0

tar -xvf ./hsap/geo/raw/GSE180152_RAW.tar
gzip -fd *

touch tmp
awk '{$4="GSE180152.GP5D.WT_non-methylated"; print;}' OFS=$'\t' GSM5454433_STARR-seq_gDNA_hg19_1712_GP5d_WT_NM_peaks.narrowPeak > tmp
awk '{$4="GSE180152.GP5D.WT_methylated"; print;}' OFS=$'\t' GSM5454434_STARR-seq_gDNA_hg19_1712_GP5d_WT_M_peaks.narrowPeak > tmp1
awk '{$4="GSE180152.GP5D.TP53-null_non-methylated"; print;}' OFS=$'\t' GSM5454435_STARR-seq_gDNA_hg19_1712_GP5d_C2_NM_peaks.narrowPeak > tmp2
awk '{$4="GSE180152.GP5D.TP53-null_methylated"; print;}' OFS=$'\t' GSM5454436_STARR-seq_gDNA_hg19_1712_GP5d_C2_M_peaks.narrowPeak > tmp3
awk '{$4="GSE180152.Hep-G2.REP1_non-methylated"; print;}' OFS=$'\t' GSM5454437_HepG2_NM1_peaks.narrowPeak > tmp4
awk '{$4="GSE180152.Hep-G2.REP2_non-methylated"; print;}' OFS=$'\t' GSM5454438_HepG2_NM2_peaks.narrowPeak > tmp5

cat tmp >> tmp1
cat tmp1 >> tmp2
cat tmp2 >> tmp3
cat tmp3 >> tmp4
cat tmp4 >> tmp5

sort -k 1,1 -k 2,2n tmp5 > total_narrowpeaks.narrowPeak

rm GSM5454433_STARR-seq_gDNA_hg19_1712_GP5d_WT_NM_peaks.narrowPeak GSM5454434_STARR-seq_gDNA_hg19_1712_GP5d_WT_M_peaks.narrowPeak GSM5454435_STARR-seq_gDNA_hg19_1712_GP5d_C2_NM_peaks.narrowPeak 
rm GSM5454436_STARR-seq_gDNA_hg19_1712_GP5d_C2_M_peaks.narrowPeak GSM5454437_HepG2_NM1_peaks.narrowPeak GSM5454438_HepG2_NM2_peaks.narrowPeak tmp tmp1 tmp2 tmp3 tmp4 tmp5

/home/mouren/UCSC_commands/liftOver -bedPlus=6 total_narrowpeaks.narrowPeak ./hsap/hg19ToHg38.over.chain GSE180152_hg38lift.narrowPeak unmapped.txt # 60 unmapped.txt
echo "unmapped 5"
wc -l unmapped.txt

rm total_narrowpeaks.narrowPeak unmapped.txt

cat GSE180152_hg38lift.narrowPeak >> ./hsap/geo/tmp_final_geo_active
rm GSE180152_hg38lift.narrowPeak

# 6: GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv GSE156857_SORT1_locus_binned_stranded_signal_bedlike.tsv
### maybe we need to filter the scores values at the end, because there is ton of noise since there is all the values in a sliding window (sort of)
touch tmp

awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.A-549.REF-REP1"; print $1,$2,$3,$4,"0",".",$6}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.A-549.REF-REP2"; print $1,$2,$3,$4,"0",".",$7}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.A-549.REF-REP3"; print $1,$2,$3,$4,"0",".",$8}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.A-549.COMP-REP1"; print $1,$2,$3,$4,"0",".",$9}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.A-549.COMP-REP2"; print $1,$2,$3,$4,"0",".",$10}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.A-549.COMP-REP3"; print $1,$2,$3,$4,"0",".",$11}' OFS=$'\t' >> tmp

awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.BE2C.REF-REP1"; print $1,$2,$3,$4,"0",".",$12}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.BE2C.REF-REP2"; print $1,$2,$3,$4,"0",".",$13}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.BE2C.REF-REP3"; print $1,$2,$3,$4,"0",".",$14}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.BE2C.COMP-REP1"; print $1,$2,$3,$4,"0",".",$15}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.BE2C.COMP-REP2"; print $1,$2,$3,$4,"0",".",$16}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.BE2C.COMP-REP3"; print $1,$2,$3,$4,"0",".",$17}' OFS=$'\t' >> tmp

awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.Hep-G2.REF-REP1"; print $1,$2,$3,$4,"0",".",$18}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.Hep-G2.REF-REP2"; print $1,$2,$3,$4,"0",".",$19}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.Hep-G2.REF-REP3"; print $1,$2,$3,$4,"0",".",$20}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.Hep-G2.COMP-REP1"; print $1,$2,$3,$4,"0",".",$21}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.Hep-G2.COMP-REP2"; print $1,$2,$3,$4,"0",".",$22}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.Hep-G2.COMP-REP3"; print $1,$2,$3,$4,"0",".",$23}' OFS=$'\t' >> tmp

awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.K-562.REF-REP1"; print $1,$2,$3,$4,"0",".",$24}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.K-562.REF-REP2"; print $1,$2,$3,$4,"0",".",$25}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.K-562.REF-REP3"; print $1,$2,$3,$4,"0",".",$26}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.K-562.COMP-REP1"; print $1,$2,$3,$4,"0",".",$27}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.K-562.COMP-REP2"; print $1,$2,$3,$4,"0",".",$28}' OFS=$'\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE156857_HTT_locus_binned_stranded_signal_bedlike.tsv |awk '{$4="GSE156857.K-562.COMP-REP3"; print $1,$2,$3,$4,"0",".",$29}' OFS=$'\t' >> tmp

awk -v OFS="\t" '$1=$1' ./hsap/geo/raw/GSE156857_SORT1_locus_binned_stranded_signal_bedlike.tsv > tabulated

awk '(NR>1)' tabulated |awk '{$4="GSE156857.Hep-G2.REF-REP1"; print $1,$2,$3,$4,"0",".",$6}' OFS=$'\t' >> tmp
awk '(NR>1)' tabulated |awk '{$4="GSE156857.Hep-G2.COMP-REP1"; print $1,$2,$3,$4,"0",".",$7}' OFS=$'\t' >> tmp
awk '(NR>1)' tabulated |awk '{$4="GSE156857.Hep-G2.REF-REP2"; print $1,$2,$3,$4,"0",".",$8}' OFS=$'\t' >> tmp
awk '(NR>1)' tabulated |awk '{$4="GSE156857.Hep-G2.COMP-REP2"; print $1,$2,$3,$4,"0",".",$9}' OFS=$'\t' >> tmp
awk '(NR>1)' tabulated |awk '{$4="GSE156857.Hep-G2.REF-REP3"; print $1,$2,$3,$4,"0",".",$10}' OFS=$'\t' >> tmp
awk '(NR>1)' tabulated |awk '{$4="GSE156857.Hep-G2.COMP-REP3"; print $1,$2,$3,$4,"0",".",$11}' OFS=$'\t' >> tmp

awk -F $'\t' '{if ($7!="NA") print;}' OFS='\t' tmp > tmp1
LC_ALL=C awk -F $'\t' '{if ($7>0) print $1,$2,$3,$4,$5,$6,$7,"NA","NA","NA"}' OFS='\t' tmp1 > tmp3

sort -k 1,1 -k 2,2n tmp3 > GSE156857_hg38.bed

rm tmp tabulated tmp1 tmp3 

cat GSE156857_hg38.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE156857_hg38.bed

# 7: GSE184426_HS-STARR-seq-enhancers_counts.txt   block comment because this one takes long
awk '(NR>1)' ./hsap/geo/raw/GSE184426_HS-STARR-seq-enhancers_counts.txt |awk '{if ($4=="-") print;}' OFS='\t' > neg
awk '(NR>1)' ./hsap/geo/raw/GSE184426_HS-STARR-seq-enhancers_counts.txt |awk '{if ($4!="-") print;}' OFS='\t' > pos

awk '{t=$2; $2=$3; $3=t; print;}' OFS='\t' neg > neg_correct
cat neg_correct >> pos

touch tmp

awk '{t="GSE184426.K-562.REP3"; res=$7/$6; print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' pos >> tmp
awk '{t="GSE184426.K-562.REP1"; res=$8/$6; print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' pos >> tmp
awk '{t="GSE184426.K-562.REP2"; res=$9/$6; print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' pos >> tmp
awk '{t="GSE184426.K-562.REP4"; res=$10/$6; print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' pos >> tmp

awk -F $'\t' '{if ($7!="NA") print;}' OFS='\t' tmp > tmp1
LC_ALL=C awk -F $'\t' '{if ($7>0 || $7=="Inf") print $1,$2,$3,$4,$5,$6,$7,"NA","NA","NA"}' OFS='\t' tmp1 > tmp2

sort -k 1,1 -k 2,2n tmp2 > tmp3

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp3 ./hsap/hg19ToHg38.over.chain GSE184426_hg38lift.bed unmapped.txt    # 1398 unmapped.txt
echo "unmapped 7"
wc -l unmapped.txt

rm neg neg_correct pos tmp tmp1 tmp2 tmp3 unmapped.txt

cat GSE184426_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE184426_hg38lift.bed

# 8: GSE145257_RAW.tar
tar -xvf ./hsap/geo/raw/GSE145257_RAW.tar
gzip -fd *

touch tmp

awk '{$4="GSE145257.COS7-transfected.REP1_pcDNA-GataFactors"; print $1,$2,$3,$4,"0",".","NA","NA","NA"}' OFS='\t' GSM4310264_hSTARR_SG4-over-pcDNA_FC1.5_1.bed >> tmp
awk '{$4="GSE145257.COS7-transfected.REP2_pcDNA-GataFactors"; print $1,$2,$3,$4,"0",".","NA","NA","NA"}' OFS='\t' GSM4310265_hSTARR_SG4-over-pcDNA_FC1.5_2.bed >> tmp
awk '{$4="GSE145257.COS7-transfected.REP1_pcDNA-TcfFactors"; print $1,$2,$3,$4,"0",".","NA","NA","NA"}' OFS='\t' GSM4310266_hSTARR_Wnt-over-pcDNA_FC1.5_1.bed >> tmp

sort -k 1,1 -k 2,2n tmp > tmp1

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp1 ./hsap/hg19ToHg38.over.chain GSE145257_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 8"
wc -l unmapped.txt

rm GSM4310264_hSTARR_SG4-over-pcDNA_FC1.5_1.bed GSM4310265_hSTARR_SG4-over-pcDNA_FC1.5_2.bed GSM4310266_hSTARR_Wnt-over-pcDNA_FC1.5_1.bed GSM4310272_mSTARR_SG4-over-pcDNA_FC1.5_1.bed
rm GSM4310273_mSTARR_SG4-over-pcDNA_FC1.5_2.bed GSM4310274_mSTARR_Wnt-over-pcDNA_FC1.5_1.bed tmp tmp1 unmapped.txt

cat GSE145257_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE145257_hg38lift.bed

# 9: GSE133802_BAC_STARR_putative_enhancers_hg19.bed.gz GSE133802_BAC_STARR_putative_repressors_hg19.bed.gz 
tr -d '\r' < ./hsap/geo/raw/GSE133802_BAC_STARR_putative_enhancers_hg19.bed > tmp_enh

touch tmp

awk '(NR>1)' tmp_enh |awk '{$4="GSE133802.iAM1-transfected.enhancers"; print $1,$2,$3,$4,"0",".","NA","NA","NA"}' OFS='\t' >> tmp

sort -k 1,1 -k 2,2n tmp > tmp1

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp1 ./hsap/hg19ToHg38.over.chain GSE133802_enhancers_and_repressors_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 9"
wc -l unmapped.txt

rm tmp_enh tmp tmp1 unmapped.txt

cat GSE133802_enhancers_and_repressors_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE133802_enhancers_and_repressors_hg38lift.bed

# 10: GSE142566_RawCountTable.txt
grep "WT" ./hsap/geo/raw/GSE142566_RawCountTable.txt > tmpWT

touch tmp

awk '{t="GSE142566.Hep-G2.REP1"; res=log($7/$13)/log(2); print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' tmpWT >> tmp
awk '{t="GSE142566.Hep-G2.REP2"; res=log($8/$13)/log(2); print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' tmpWT >> tmp
awk '{t="GSE142566.Hep-G2.REP3"; res=log($9/$13)/log(2); print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' tmpWT >> tmp
awk '{t="GSE142566.Hep-G2.REP4"; res=log($10/$13)/log(2); print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' tmpWT >> tmp
awk '{t="GSE142566.Hep-G2.REP5"; res=log($11/$13)/log(2); print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' tmpWT >> tmp
awk '{t="GSE142566.Hep-G2.REP6"; res=log($12/$13)/log(2); print $1,$2,$3,t,"0",$4,res}' OFS=$'\t' tmpWT >> tmp

awk -F $'\t' '{if ($7!="NA" && $7!="-nan") print;}' OFS='\t' tmp > tmp1

awk -F $'\t' '{if ($7>0) print $1,$2,$3,$4,$5,$6,$7,"NA","NA","NA"}' OFS='\t' tmp1 > tmp2

sort -k 1,1 -k 2,2n tmp2 > tmp3

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp3 ./hsap/hg19ToHg38.over.chain GSE142566_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 10"
wc -l unmapped.txt

rm tmpWT tmp tmp1 tmp2 unmapped.txt tmp3

cat GSE142566_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE142566_hg38lift.bed

# 11: GSE114063_peaks_t00_union.bed GSE114063_peaks_t12_union.bed GSE114063_peaks_t1_union.bed GSE114063_peaks_t4_union.bed GSE114063_peaks_t8_union.bed
touch tmp

awk '{$4="GSE114063.A-549"; print $1,$2,$3,$4,"0",".","NA","NA","NA","NA"}' OFS='\t' ./hsap/geo/raw/GSE114063_peaks_t00_union.bed >> tmp
awk '{$4="GSE114063.A-549"; print $1,$2,$3,$4,"0",".","NA","NA","NA","NA"}' OFS='\t' ./hsap/geo/raw/GSE114063_peaks_t12_union.bed >> tmp
awk '{$4="GSE114063.A-549"; print $1,$2,$3,$4,"0",".","NA","NA","NA","NA"}' OFS='\t' ./hsap/geo/raw/GSE114063_peaks_t1_union.bed >> tmp
awk '{$4="GSE114063.A-549"; print $1,$2,$3,$4,"0",".","NA","NA","NA","NA"}' OFS='\t' ./hsap/geo/raw/GSE114063_peaks_t4_union.bed >> tmp
awk '{$4="GSE114063.A-549"; print $1,$2,$3,$4,"0",".","NA","NA","NA","NA"}' OFS='\t' ./hsap/geo/raw/GSE114063_peaks_t8_union.bed >> tmp

sort -k 1,1 -k 2,2n tmp > GSE114063_hg38.bed

rm tmp

cat GSE114063_hg38.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE114063_hg38.bed

# 12: GSE100432_differential_peaks_inhibitor_vs_no-inhibitor_supp.table2.tsv.gz GSE100432_peaks_inhibitor_correctedEnrichment4_supp.table2.tsv.gz GSE100432_peaks_no-inhibitor_correctedEnrichment4_supp.table2.tsv.gz GSE100432_shortlisted_regions_inhibitor_supp.table2.tsv.gz
touch tmp

#no pval >0.05
awk '(NR>1)' ./hsap/geo/raw/GSE100432_shortlisted_regions_inhibitor_supp.table2.tsv |awk '{$4="GSE100432.HeLa-S3.regions-inhibitor-treatment_pval"; print $1,$2,$3,$4,"0",".",$5,$6,"NA","NA"}' OFS='\t' >> tmp 
awk '(NR>1)' ./hsap/geo/raw/GSE100432_peaks_inhibitor_correctedEnrichment4_supp.table2.tsv |awk '{$4="GSE100432.HeLa-S3.inhibitor-treatment_pval"; print $1,$2,$3,$4,"0",".",$5,$6,"NA","NA"}' OFS='\t' >> tmp 
awk '(NR>1)' ./hsap/geo/raw/GSE100432_peaks_no-inhibitor_correctedEnrichment4_supp.table2.tsv |awk '{$4="GSE100432.HeLa-S3.no-inhibitor_pval"; print $1,$2,$3,$4,"0",".",$5,$6,"NA","NA"}' OFS='\t' >> tmp 

#p_over_adjust is pvalue of peaks with fc>0; p_under_adjust is pvalue of peaks with fc<0
awk '(NR>1)' ./hsap/geo/raw/GSE100432_differential_peaks_inhibitor_vs_no-inhibitor_supp.table2.tsv |LC_ALL=C awk '{if ($4>0 && $5<0.05) print;}' OFS='\t' > tmp_fc
awk '{t="GSE100432.HeLa-S3.combined-inhibitorTreatmentVSnoInhibitor"; print $1,$2,$3,t,"0",".",$4,$5,"NA","NA"}' OFS='\t' tmp_fc >> tmp

LC_ALL=C awk '{nlog10=-(log($8)/log(10)); print $1,$2,$3,$4,$5,$6,$7,nlog10,$9,$10}' OFS='\t' tmp > tmp_aa

LC_ALL=C awk '{if ($7>0) print;}' OFS='\t' tmp_aa >> tmp10

sort -k 1,1 -k 2,2n tmp10 > tmp1  

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp1 ./hsap/hg19ToHg38.over.chain GSE100432_hg38lift.bed unmapped.txt  # 70 unmapped.txt
echo "unmapped 12"
wc -l unmapped.txt

rm tmp tmp1 unmapped.txt tmp_fc tmp10 tmp_aa

cat GSE100432_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE100432_hg38lift.bed

# 13: GSE82204_enhancer_not_overlapped_dnase.txt GSE82204_enhancer_overlap_dnase.txt
touch tmp

## no fc <0 and qval>0.05
#with overlap is narrowpeak format with dnase peak added at the end (p and q values are nlog10)
awk '{n="GSE82204.LNCaP.DNAse-overlap"; print $1,$2,$3,n,$5,$6,$7,$8,$9,$10}' OFS='\t' ./hsap/geo/raw/GSE82204_enhancer_overlap_dnase.txt >> tmp

# no overlap is narrowpeak format (p and q values are nlog10)
awk '{n="GSE82204.LNCaP.DNAse-noOverlap"; print $1,$2,$3,n,$5,$6,$7,$8,$9,$10}' OFS='\t' ./hsap/geo/raw/GSE82204_enhancer_not_overlapped_dnase.txt >> tmp

sort -k 1,1 -k 2,2n tmp > tmp1

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp1 ./hsap/hg19ToHg38.over.chain GSE82204_hg38lift.bed unmapped_enh.txt  # 50 unmapped_enh.txt
echo "unmapped 13"
wc -l unmapped_enh.txt

rm tmp tmp1 unmapped_enh.txt

cat GSE82204_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE82204_hg38lift.bed

# 14: GSE40739_RAW.tar #transform pval ici
tar -xvf ./hsap/geo/raw/GSE40739_RAW.tar
gzip -fd *

awk '{n="GSE40739.HeLa-Kyoto"; nlog10=-(log($4)/log(10)); t=$2+1;  print $1,$2,t,n,"0",".",$3,nlog10,"NA","NA"}' OFS='\t' GSM1055604_HeLa_BAC_STARRseq.peaks.txt > tmp

sort -k 1,1 -k 2,2n tmp > tmp1

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp1 ./hsap/hg19ToHg38.over.chain GSE40739_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 14"
wc -l unmapped.txt

rm GSM1055604_HeLa_BAC_STARRseq.peaks.txt tmp tmp1 unmapped.txt

cat GSE40739_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE40739_hg38lift.bed

# 15: GSE118725_starr_seq.count.tsv #WT are the first lines of pairs of line # some lines are wrong but its okay
awk '(NR>1)' ./hsap/geo/raw/GSE118725_starr_seq.count.tsv |grep "chr" > tmp

awk '{print $1}' tmp |cut -f5 -d"_" > col #takes only lines with full coordinates
paste tmp col > tmp1
awk '{if ($15!="") print $0}' tmp1 > tmp2

awk '{print $1}' tmp2 |cut -f1,3,4 -d"_" > col2 #takes only lines that goes in pair strictly (remove uniques lines)
paste tmp2 col2 > tmp3
awk '{print $16}' tmp3 | sort | uniq -c | sort -nr > freq

awk '{if ($1=="2") print $2}' freq > good_lines
grep -f good_lines tmp3 > tmp4

sort -k 1 tmp4 |sed '$!N;s/\n/ /' > tmp5

touch tmp_f

awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.Hep-G2.REP1-ssIII"; res=log($3/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.Hep-G2.REP2-ssIII"; res=log($4/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.Hep-G2.REP3-ssIII"; res=log($5/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.Hep-G2.REP1-AB"; res=log($6/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.Hep-G2.REP2-AB"; res=log($7/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.Hep-G2.REP3-AB"; res=log($8/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.HEK293T.REP1-ssIII"; res=log($9/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.HEK293T.REP2-ssIII"; res=log($10/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.HEK293T.REP3-ssIII"; res=log($11/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.HEK293T.REP1-AB"; res=log($12/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.HEK293T.REP2-AB"; res=log($13/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f
awk '{split($1,a,"_"); c=a[1]; s=a[3]; e=a[4]; t="GSE118725.HEK293T.REP3-AB"; res=log($14/$2)/log(2); print c,s,e,t,"0",".",res}' OFS=$'\t' tmp5 >> tmp_f

sort -k 1,1 -k 2,2n tmp_f > tmp6

LC_ALL=C awk -F $'\t' '{if ($7>0) print $1,$2,$3,$4,$5,$6,$7,"NA","NA","NA"}' OFS='\t' tmp6 > tmp7

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp7 ./hsap/hg19ToHg38.over.chain GSE118725_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 15"
wc -l unmapped.txt

rm tmp col tmp1 tmp2 col2 tmp3 freq good_lines tmp4 tmp5 tmp6 tmp7 tmp_f unmapped.txt

cat GSE118725_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE118725_hg38lift.bed

# 16: GSE142207 Candidate_silencers_and_uncharacterized_CREs_human_hg19_ENCODE_cell_types.txt Candidate_silencers_and_uncharacterized_CREs_human_hg19_roadmap_cell_types.txt  block comment because this one takes long
touch tmp

awk '(NR>1)' ./hsap/geo/raw/Candidate_silencers_and_uncharacterized_CREs_human_hg19_ENCODE_cell_types.txt |awk '{t=$7; $4="GSE142207.K-562.encode-"t; print $1,$2,$3,$4,"0",".","NA","NA","NA","NA"}' OFS='\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/Candidate_silencers_and_uncharacterized_CREs_human_hg19_roadmap_cell_types.txt |awk '{t=$7; $4="GSE142207.K-562.roadmap-"t; print $1,$2,$3,$4,"0",".","NA","NA","NA","NA"}' OFS='\t' >> tmp

grep "uncharacterized_CRE" tmp > tmpfc
sort -k 1,1 -k 2,2n tmpfc > tmp1

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp1 ./hsap/hg19ToHg38.over.chain GSE142207_hg38lift.bed unmapped.txt  # 3506 unmapped.txt
echo "unmapped 16"
wc -l unmapped.txt

rm tmp tmp1 unmapped.txt tmpfc

cat GSE142207_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE142207_hg38lift.bed

# 17: GSE113978_Ortholog_scores.tsv GSE113978_Tiling_scores.tsv #no pval qval here
awk '(NR>1)' ./hsap/geo/raw/GSE113978_Tiling_scores.tsv |awk '{split($1,a,":"); c=a[1]; split($1,b,"-"); s=b[1]; e=b[2]; t="GSE113978.Hep-G2.tiling"; print "chr"c,s,e,t,"0",".",$2,"NA","NA","NA"}' OFS='\t' > tmp

grep "hg38" ./hsap/geo/raw/GSE113978_Ortholog_scores.tsv |awk '{split($1,a,":"); c=a[1]; split($1,b,"-"); s=b[1]; e=b[2]; t="GSE113978.Hep-G2.ortholog-hg38"; print "chr"c,s,e,t,"0",".",$2,"NA","NA","NA"}' OFS='\t' > tmp1

awk '{split($2,a,":"); s=a[2]; print $1,s,$3,$4,$5,$6,$7,$8,$9,$10}' OFS='\t' tmp > tmp_lift
awk '{split($2,a,":"); s=a[2]; split($3,b,"_"); e=b[1]; print $1,s,e,$4,$5,$6,$7,$8,$9,$10}' OFS='\t' tmp1 > tmp_add

grep -v "chrNegative" tmp_lift > tmp_lift2
LC_ALL=C awk -F $'\t' '{if ($7>0) print;}' OFS='\t' tmp_lift2 > tmp_lift3

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp_lift3 ./hsap/hg19ToHg38.over.chain tmp_f unmapped.txt  # 0 unmapped.txt
echo "unmapped 17"
wc -l unmapped.txt

LC_ALL=C awk -F $'\t' '{if ($7>0) print;}' OFS='\t' tmp_add > tmp_add1
cat tmp_add1 >> tmp_f
rm tmp_add1

sort -k 1,1 -k 2,2n tmp_f > GSE113978_hg38lift.bed

rm tmp tmp1 tmp_lift tmp_lift2 tmp_lift3 tmp_add unmapped.txt tmp_f

cat GSE113978_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE113978_hg38lift.bed

# 18: GSE99630 mmc7.zip -> Super-enhancers_naive.bed.gz Super-enhancers_primed.bed.gz | mmc3.xlsx -> .tsv (from article) #no pval qval here
unzip ./hsap/geo/raw/mmc7.zip
rm ChIP-seq_peaks_H3K27ac.bed.gz ChIP-seq_peaks_H3K4me1.bed.gz ChIP-seq_peaks_NANOG.bed.gz ChIP-seq_peaks_OCT4.bed.gz ChIP-STARR-seq_enhancers_naive.bed.gz ChIP-STARR-seq_enhancers_primed.bed.gz
gzip -fd *

touch tmp
awk '{t="GSE99630.H9-hESCs.super-enhancers_naive"; print $1,$2,$3,t,"0",".","NA","NA","NA","NA"}' OFS='\t' Super-enhancers_naive.bed >> tmp
awk '{t="GSE99630.H9-hESCs.super-enhancers_primed"; print $1,$2,$3,t,"0",".","NA","NA","NA","NA"}' OFS='\t' Super-enhancers_primed.bed >> tmp

sed 's/\xc2\xa0/ /g' ./hsap/geo/raw/mmc3.tsv > mmc3_treated # removes the M-BM- characters that are here because of xlsx/odf

touch tmp1 #in excel there is only the ratio of RNA reads relative to plasmid reads after normalization (RPP, reads per plasmid)
awk '(NR>1)' mmc3_treated |awk -F $'\t' '{split($2,a," "); s=a[1]a[2]a[3]; split($3,b," "); e=b[1]b[2]b[3]; split($8,c," "); y=c[1]c[2]c[3]; x=log(y)/log(2); t="GSE99630.H9-hESCs.RPP_primed"; print $1,s,e,t,"0",".",x,"NA","NA","NA"}' OFS='\t' >> tmp1
awk '(NR>1)' mmc3_treated |awk -F $'\t' '{split($2,a," "); s=a[1]a[2]a[3]; split($3,b," "); e=b[1]b[2]b[3]; split($9,c," "); y=c[1]c[2]c[3]; x=log(y)/log(2); t="GSE99630.H9-hESCs.RPP_naive"; print $1,s,e,t,"0",".",x,"NA","NA","NA"}' OFS='\t' >> tmp1

sort -k 1,1 -k 2,2n tmp > super
sort -k 1,1 -k 2,2n tmp1 > rpp

/home/mouren/UCSC_commands/liftOver -bedPlus=6 super ./hsap/hg19ToHg38.over.chain GSE99630_hg38lift_superEnhancers.bed unmapped.txt  # 6 unmapped.txt
echo "unmapped 18"
wc -l unmapped.txt

/home/mouren/UCSC_commands/liftOver -bedPlus=6 rpp ./hsap/hg19ToHg38.over.chain GSE99630_hg38lift_enhancersRPP.bed unmapped1.txt  # 2200 unmapped1.txt
echo "unmapped 18 1"
wc -l unmapped1.txt

rm Super-enhancers_naive.bed Super-enhancers_primed.bed tmp mmc3_treated tmp1 super rpp unmapped.txt unmapped1.txt

awk -F $'\t' '{if ($7>0) print;}' OFS='\t' GSE99630_hg38lift_enhancersRPP.bed > tmpfc

cat GSE99630_hg38lift_superEnhancers.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE99630_hg38lift_superEnhancers.bed
cat tmpfc >> ./hsap/geo/tmp_final_geo_active
rm GSE99630_hg38lift_enhancersRPP.bed tmpfc

# 19: GSE77869 NIHMS807819-supplement-2.tsv (xlsx converted in tsv)

awk '(NR>1)' ./hsap/geo/raw/NIHMS807819-supplement-2.tsv |awk '{split($1,a,"_"); c=a[1]; s=a[2]; e=a[3]; t="GSE77869.A-549"; print c,s,e,t,"0",".",$3,$6,$7,"NA"}' OFS='\t' > tmp

awk '{if ($9<0.05) print}' tmp > tmp1 #filter on qval

awk '{nlog10_1=-(log($8)/log(10)); nlog10_2=-(log($9)/log(10)); print $1,$2,$3,$4,$5,$6,$7,nlog10_1,nlog10_2,$10}' OFS=$'\t' tmp1 > tmp_log

awk '{if ($7>0) print;}' OFS='\t' tmp_log > tmp2 

sort -k 1,1 -k 2,2n tmp2 > tmp3

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp3 ./hsap/hg19ToHg38.over.chain GSE77869_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 19"
wc -l unmapped.txt

rm tmp tmp1 tmp2 tmp3 unmapped.txt tmp_log

cat GSE77869_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE77869_hg38lift.bed

# 20: GSE76654 Supplemental_Table_S4.xlsx -> raw/Supplemental_Table_S4.tsv (manunally converted)
awk '(NR>1)' ./hsap/geo/raw/Supplemental_Table_S4.tsv |awk -F'\t' '{split($2,a,"-"); c=a[1]; s=a[2]; e=a[3]; t="GSE76654.MCF7.p53-treatment_responsive"; print c,s,e,t,$18,".",$4,"NA",$5,"NA"}' OFS='\t' > tmp

awk '{nlog10=-(log($9)/log(10)); print $1,$2,$3,$4,$5,$6,$7,$8,nlog10,$10}' OFS=$'\t' tmp > tmp_log

sort -k 1,1 -k 2,2n tmp_log > tmp1

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp1 ./hsap/hg19ToHg38.over.chain GSE76654_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 20"
wc -l unmapped.txt

rm tmp tmp1 unmapped.txt tmp_log

cat GSE76654_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE76654_hg38lift.bed

# 21: GSE180846_raw_count_matrix.txt.gz  <- to take with caution because SNP allelic effect is tested
touch tmp
awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP1"; res=log($9/$6)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP2"; res=log($10/$7)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP3"; res=log($11/$8)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp

awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP1_IL1b-24h"; res=log($12/$6)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP2_IL1b-24h"; res=log($13/$7)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP3_IL1b-24h"; res=log($14/$8)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp

awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP1_IL1b-6h"; res=log($15/$6)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP2_IL1b-6h"; res=log($16/$7)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp
awk '(NR>1)' ./hsap/geo/raw/GSE180846_raw_count_matrix.txt |awk '{t="GSE180846.teloHAEC."$4"-REP3_IL1b-6h"; res=log($17/$8)/log(2); print $1,$2,$3,t,"0",".",res}' OFS='\t' >> tmp

sort -k 1,1 -k 2,2n tmp > tmp1

grep -v "NA" tmp1 > tmp2

awk '{if ($7>0) print $1,$2,$3,$4,$5,$6,$7,"NA","NA","NA"}' OFS='\t' tmp2 > tmp3 

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp3 ./hsap/hg19ToHg38.over.chain GSE180846_hg38lift.bed unmapped.txt  # 2 unmapped.txt
echo "unmapped 21"
wc -l unmapped.txt

rm tmp tmp1 tmp2 tmp3 unmapped.txt 

cat GSE180846_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE180846_hg38lift.bed

# 22: GSE142696_9MPRA.ActivityRatios.IndividualReps.tsv.gz HSS ORI columns
grep -v "C:" ./hsap/geo/raw/GSE142696_9MPRA.ActivityRatios.IndividualReps.tsv > raw1
grep -v "FOXA1_FOXA2" raw1 > raw2
grep -v "FOXA1_FOXA2_HNF4A" raw2 > raw3
grep -v "FOXA1_HNF4A" raw3 > raw4
grep -v "FOXA2_HNF4A" raw4 > raw5

grep "FOXA1_FOXA2" ./hsap/geo/raw/GSE142696_9MPRA.ActivityRatios.IndividualReps.tsv > raw_foxa
grep "FOXA1_HNF4A" ./hsap/geo/raw/GSE142696_9MPRA.ActivityRatios.IndividualReps.tsv >> raw_foxa
grep "FOXA2_HNF4A" ./hsap/geo/raw/GSE142696_9MPRA.ActivityRatios.IndividualReps.tsv >> raw_foxa
grep -v "FOXA1_FOXA2_HNF4A" raw_foxa > raw_foxa_f

grep "FOXA1_FOXA2_HNF4A" ./hsap/geo/raw/GSE142696_9MPRA.ActivityRatios.IndividualReps.tsv > raw_foxa2

awk '(NR>1)' raw5 |awk '{split($1,a,"_"); print a[2]}' |tr :- '\t' > coordinates1
awk '{split($1,a,"_"); print a[3]}' raw_foxa_f |tr :- '\t' > coordinates_foxa
awk '{split($1,a,"_"); print a[4]}' raw_foxa2 |tr :- '\t' > coordinates_foxa2


awk '(NR>1)' raw5 |awk -F $'\t' '{print $5,$6,$7,$8,$9,$10,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40}' OFS='\t' > val1
awk -F$'\t' '{print $5,$6,$7,$8,$9,$10,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40}' OFS='\t' raw_foxa_f > val_foxa
awk -F$'\t' '{print $5,$6,$7,$8,$9,$10,$29,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40}' OFS='\t' raw_foxa2 > val_foxa2

paste coordinates1 val1 > tmp1
paste coordinates_foxa val_foxa > tmp_foxa
paste coordinates_foxa2 val_foxa2 > tmp_foxa2

cat tmp_foxa >> tmp1
cat tmp_foxa2 >> tmp1

touch tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP1"; print $1,$2,$3,t,"0",".",$4}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP2"; print $1,$2,$3,t,"0",".",$5}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP3"; print $1,$2,$3,t,"0",".",$6}' OFS='\t' tmp1 >> tmp2

awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP1"; print $1,$2,$3,t,"0",".",$7}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP2"; print $1,$2,$3,t,"0",".",$8}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP3"; print $1,$2,$3,t,"0",".",$9}' OFS='\t' tmp1 >> tmp2

awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP1_full"; print $1,$2,$3,t,"0",".",$10}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP2_full"; print $1,$2,$3,t,"0",".",$11}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP3_full"; print $1,$2,$3,t,"0",".",$12}' OFS='\t' tmp1 >> tmp2

awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP1_full"; print $1,$2,$3,t,"0",".",$13}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP2_full"; print $1,$2,$3,t,"0",".",$14}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP3_full"; print $1,$2,$3,t,"0",".",$15}' OFS='\t' tmp1 >> tmp2

awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP1_b2"; print $1,$2,$3,t,"0",".",$16}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP2_b2"; print $1,$2,$3,t,"0",".",$17}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.HSS-REP3_b2"; print $1,$2,$3,t,"0",".",$18}' OFS='\t' tmp1 >> tmp2

awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP1_b2"; print $1,$2,$3,t,"0",".",$19}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP2_b2"; print $1,$2,$3,t,"0",".",$20}' OFS='\t' tmp1 >> tmp2
awk -F'\t' '{t="GSE142696.Hep-G2.ORI-REP3_b2"; print $1,$2,$3,t,"0",".",$21}' OFS='\t' tmp1 >> tmp2

grep -v "NA" tmp2 > tmp3

awk -F'\t' '{if ($1!="") print}' OFS='\t' tmp3 > tmp_bb

LC_ALL=C awk '{if ($7>0) print $1,$2,$3,$4,$5,$6,$7,"NA","NA","NA"}' OFS='\t' tmp_bb > tmp4

sed -i 's/\r//g' tmp4 #remove windows return caracter

sort -k1,1 -k2,2n tmp4 > tmp5

/home/mouren/UCSC_commands/liftOver -bedPlus=6 tmp5 ./hsap/hg19ToHg38.over.chain GSE142696_hg38lift.bed unmapped.txt  # 0 unmapped.txt
echo "unmapped 22"
wc -l unmapped.txt

rm tmp_bb raw1 raw2 raw3 raw4 raw5 raw_foxa raw_foxa_f raw_foxa2 coordinates1 coordinates_foxa coordinates_foxa2 val1 val_foxa val_foxa2 tmp_foxa tmp_foxa2 tmp1 tmp2 tmp3 tmp4 tmp5 unmapped.txt 

cat GSE142696_hg38lift.bed >> ./hsap/geo/tmp_final_geo_active
rm GSE142696_hg38lift.bed

### formate
sort -k1,1 -k2,2n ./hsap/geo/tmp_final_geo_active > ./hsap/geo/geo_active_narrowpeak.tsv
rm ./hsap/geo/tmp_final_geo_active