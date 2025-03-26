#filter of probleamtic transcript is only with mm39
#the others doesnt come from gencode so not possible 

### tair10 
grep protein_coding tair10_TranscriptDetails_ensembl_raw.tsv |awk '{print $4}' |sort -u > tair10_protein_coding_id_list.txt

grep -Ff tair10_protein_coding_id_list.txt tair10_CodingExons_raw.tsv > tair10_CodingExons_protein_coding.tsv 
grep -Ff tair10_protein_coding_id_list.txt tair10_UTR5_raw.tsv > tair10_UTR5_protein_coding.tsv 
grep -Ff tair10_protein_coding_id_list.txt tair10_UTR3_raw.tsv > tair10_UTR3_protein_coding.tsv 

grep -e lncRNA -e miRNA -e ncRNA -e rRNA -e snoRNA -e snRNA -e tRNA tair10_TranscriptDetails_ensembl_raw.tsv |awk '{print $4}' |sort -u > tair10_nonCoding_id_list.txt
grep -Ff tair10_nonCoding_id_list.txt raw/tair10_UTR3_raw.tsv > tair10_noncoding_UTR3.tsv
grep -Ff tair10_nonCoding_id_list.txt raw/tair10_UTR5_raw.tsv > tair10_noncoding_UTR5.tsv
grep utr3_0_0 tair10_noncoding_UTR3.tsv > tair10_noncoding1_UTR3.tsv
grep utr5_0_0 tair10_noncoding_UTR5.tsv > tair10_noncoding1_UTR5.tsv

#TSS and TES list 
grep -Ff tair10_protein_coding_id_list.txt tair10_TranscriptDetails_ensembl_raw.tsv > tmp
awk '{if ($5=="1") print $1,$2,$2+1,$4,"+"}' OFS=$'\t' tmp > tmp1
awk '{if ($5=="-1") print $1,$3-1,$3,$4,"-"}' OFS=$'\t' tmp >> tmp1
sort -k 1,1 -k 2,2n tmp1 > tair10_TSS_coord.tsv
rm tmp1

awk '{if ($5=="1") print $1,$3-1,$3,$4,"+"}' OFS=$'\t' tmp > tmp1
awk '{if ($5=="-1") print $1,$2,$2+1,$4,"-"}' OFS=$'\t' tmp >> tmp1
sort -k 1,1 -k 2,2n tmp1 > tair10_TES_coord.tsv
rm tmp tmp1


### dm6 
grep protein_coding dm6_TranscriptDetails_UCSC_raw.tsv |awk '{print $1}' |sort -u > dm6_protein_coding_id_list.txt

grep -Ff dm6_protein_coding_id_list.txt dm6_CodingExons_raw.tsv > dm6_CodingExons_protein_coding.tsv 
grep -Ff dm6_protein_coding_id_list.txt dm6_UTR5_raw.tsv > dm6_UTR5_protein_coding.tsv 
grep -Ff dm6_protein_coding_id_list.txt dm6_UTR3_raw.tsv > dm6_UTR3_protein_coding.tsv 

grep -e miRNA -e ncRNA -e pre_miRNA -e rRNA -e snoRNA -e snRNA -e tRNA dm6_TranscriptDetails_UCSC_raw.tsv |awk '{print $1}' |sort -u > dm6_nonCoding_id_list.txt
grep -Ff dm6_nonCoding_id_list.txt dm6_UTR3_raw.tsv > dm6_noncoding_UTR3.tsv
grep -Ff dm6_nonCoding_id_list.txt dm6_UTR5_raw.tsv > dm6_noncoding_UTR5.tsv
grep utr3_0_0 dm6_noncoding_UTR3.tsv > dm6_noncoding1_UTR3.tsv
grep utr5_0_0 dm6_noncoding_UTR5.tsv > dm6_noncoding1_UTR5.tsv

#TSS and TES list 
grep -Ff dm6_protein_coding_id_list.txt dm6_TranscriptDetails_UCSC_raw.tsv > tmp
awk '{if ($3=="+") print $2,$4,$4+1,$1,$3}' OFS=$'\t' tmp > tmp1
awk '{if ($3=="-") print $2,$5-1,$5,$1,$3}' OFS=$'\t' tmp >> tmp1
sort -k 1,1 -k 2,2n tmp1 > dm6_TSS_coord.tsv
rm tmp1

awk '{if ($3=="+") print $2,$5-1,$5,$1,$3}' OFS=$'\t' tmp > tmp1
awk '{if ($3=="-") print $2,$4,$4+1,$1,$3}' OFS=$'\t' tmp >> tmp1
sort -k 1,1 -k 2,2n tmp1 > dm6_TES_coord.tsv
rm tmp tmp1


### mm39
#we take TLS1 and tls2 because not enough gene annoted as TLS1
#Problematic list id
awk '{if ($9=="nonCoding" && $10=="TEC") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv > problematic_transcript_id_gencodeVM33_ucsc.txt
awk '{if ($9=="nonCoding" && $10=="retained_intron") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv >> problematic_transcript_id_gencodeVM33_ucsc.txt
awk '{if ($9=="nonCoding" && $10=="disrupted_domain") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv >> problematic_transcript_id_gencodeVM33_ucsc.txt
awk '{if ($9=="nonCoding" && $10=="artifact") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv >> problematic_transcript_id_gencodeVM33_ucsc.txt

#TLS1 lists ids
awk '{if ($11=="1" && $9=="coding" && $10=="protein_coding") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv > tmp
awk '{if ($11=="2" && $9=="coding" && $10=="protein_coding") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv >> tmp
grep -v -f problematic_transcript_id_gencodeVM33_ucsc.txt tmp > mm39_Coding_transcript_id.txt

awk '{if ($11=="1" && $9=="nonCoding") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv > tmp
awk '{if ($11=="2" && $9=="nonCoding") print $4}' OFS=$'\t' mm39_TranscriptDetails_UCSC_raw.tsv >> tmp
grep -v -f problematic_transcript_id_gencodeVM33_ucsc.txt tmp > mm39_nonCoding_transcript_id.txt
rm tmp

#get list of elements
grep -Ff mm39_Coding_transcript_id.txt mm39_CodingExons_raw.tsv > mm39_CodingExons_protein_coding.tsv 
grep -Ff mm39_Coding_transcript_id.txt mm39_UTR5_raw.tsv > mm39_UTR5_protein_coding.tsv 
grep -Ff mm39_Coding_transcript_id.txt mm39_UTR3_raw.tsv > mm39_UTR3_protein_coding.tsv 

grep -Ff mm39_nonCoding_transcript_id.txt mm39_UTR5_raw.tsv > mm39_noncoding_UTR5.tsv 
grep -Ff mm39_nonCoding_transcript_id.txt mm39_UTR3_raw.tsv > mm39_noncoding_UTR3.tsv 
grep utr3_0_0 mm39_noncoding_UTR3.tsv > mm39_noncoding1_UTR3.tsv
grep utr5_0_0 mm39_noncoding_UTR5.tsv > mm39_noncoding1_UTR5.tsv

#TSS and TES list 
grep -Ff mm39_Coding_transcript_id.txt mm39_TranscriptDetails_UCSC_raw.tsv > tmp
awk '{if ($6=="+") print $1,$2,$2+1,$4,$6}' OFS=$'\t' tmp > tmp1
awk '{if ($6=="-") print $1,$3-1,$3,$4,$6}' OFS=$'\t' tmp >> tmp1
sort -k 1,1 -k 2,2n tmp1 > mm39_TSS_coord.tsv
rm tmp1

awk '{if ($6=="+") print $1,$3-1,$3,$4,$6}' OFS=$'\t' tmp > tmp1
awk '{if ($6=="-") print $1,$2,$2+1,$4,$6}' OFS=$'\t' tmp >> tmp1
sort -k 1,1 -k 2,2n tmp1 > mm39_TES_coord.tsv
rm tmp tmp1

### HG38
#TSL1
awk '{if ($3=="transcript") print}' OFS=$'\t' gencode.v41.annotation.gff3 |grep transcript_support_level=1 |awk '{split($9, parts, ";"); print parts[1]}' |awk '{split($1, parts, "="); print parts[2]}' > TLS1_id.txt

#Problematic 
awk '{if ($21=="nonCoding" && $23=="TEC") print}' OFS=$'\t' gencodeV41_TranscriptDetails_UCSC.bed > tmp
awk '{if ($21=="nonCoding" && $23=="retained_intron") print}' OFS=$'\t' gencodeV41_TranscriptDetails_UCSC.bed >> tmp
awk '{if ($21=="nonCoding" && $23=="disrupted_domain") print}' OFS=$'\t' gencodeV41_TranscriptDetails_UCSC.bed >> tmp
awk '{if ($21=="nonCoding" && $23=="artifact") print}' OFS=$'\t' gencodeV41_TranscriptDetails_UCSC.bed >> tmp
awk '{print $4}' tmp > problematic_transcript_id_gencodeV41_ucsc.txt

#protein coding id and tls1
awk '{if ($21=="coding") print}' OFS=$'\t' gencodeV41_TranscriptDetails_UCSC.bed > tmp
awk '{print $4}' tmp > tmp1
grep -vf problematic_transcript_id_gencodeV41_ucsc.txt tmp1 > tmp2
grep -f TLS1_id.txt tmp2 > coding_transcript_id_gencodeV41_ucsc_TLS1_noProb.txt
rm tmp tmp1 tmp2

#Exons
awk '$1 !~ /_/ { print }' coding_exons_gencodeV41_ComprehensiveSet_Hsap.bed > tmp
grep -Ff coding_transcript_id_gencodeV41_ucsc_TLS1_noProb.txt tmp > hg38_CodingExons_protein_coding.tsv

#nonCoding
awk '{if ($21=="nonCoding") print}' OFS=$'\t' gencodeV41_TranscriptDetails_UCSC.bed > tmp
grep -v -f problematic_transcript_id_gencodeV41_ucsc.txt tmp |awk '{print $4}' >  nonCoding_clean_transcript_id_gencodeV41_ucsc.txt
grep -f nonCoding_clean_transcript_id_gencodeV41_ucsc.txt gencode.v41.annotation.gff3 > nonCoding_gencodeV41.gff3
grep 'ID=exon:ENST.*:1;' nonCoding_gencodeV41.gff3 |awk -F'\t' '{split($9, parts, ";"); print $1,$4,$5,$7,parts[1]}' OFS=$'\t' |awk -F'\t' '{split($5, parts, ":"); print $1,$2,$3,$4,parts[2]}' OFS=$'\t' > tmp
grep -f TLS1_id.txt tmp > hg38_nc1_tls1_no_prob.tsv
rm  tmp nonCoding_gencodeV41.gff3 nonCoding_clean_transcript_id_gencodeV41_ucsc.txt

#TSS
grep -Ff coding_transcript_id_gencodeV41_ucsc.txt gencodeV41_allAnnot_UCSC_ComprehensiveSet.tsv > coding_UCSC_allAnnot_ComprehensiveSet.tsv
awk '{if ($4=="+") print}' OFS=$'\t' coding_UCSC_allAnnot_ComprehensiveSet.tsv > plus
awk '{if ($4=="-") print}' OFS=$'\t' coding_UCSC_allAnnot_ComprehensiveSet.tsv > minus

awk '{end=$5+1; print $3,$5,end,$2,$4}' OFS=$'\t' plus > plustss
awk '{end=$6-1; print $3,end,$6,$2,$4}' OFS=$'\t' minus > minustss

cat plustss >> minustss 
sort -k 1,1 -k 2,2n minustss > tmp
awk '$1 !~ /_/ { print }' OFS=$'\t' tmp > tmp
grep -f TLS1_id.txt tmp > coding_transcript_TSS_TLS1.bed

rm plustss minustss plus minus tmp

#TES
grep -Ff coding_transcript_id_gencodeV41_ucsc.txt gencodeV41_allAnnot_UCSC_ComprehensiveSet.tsv > coding_UCSC_allAnnot_ComprehensiveSet.tsv
awk '{if ($4=="+") print}' OFS=$'\t' coding_UCSC_allAnnot_ComprehensiveSet.tsv > plus
awk '{if ($4=="-") print}' OFS=$'\t' coding_UCSC_allAnnot_ComprehensiveSet.tsv > minus

awk '{end=$6-1; print $3,end,$6,$2,$4}' OFS=$'\t' plus > plustes
awk '{end=$5+1; print $3,$5,end,$2,$4}' OFS=$'\t' minus > minustes

cat plustes >> minustes
sort -k 1,1 -k 2,2n minustes > tmp
awk '$1 !~ /_/ { print }' OFS=$'\t' tmp > tmp
grep -f TLS1_id.txt tmp > coding_transcript_TES_TLS1.bed

rm plustes minustes plus minus tmp

#get list of elements
grep -Ff coding_transcript_id_gencodeV41_ucsc_TLS1_noProb.txt GencodeV41_UTR5_UCSC_ComprehensiveSet.bed > GencodeV41_UTR5_UCSC_noProb_CompSet_TLS1.tsv
grep -Ff coding_transcript_id_gencodeV41_ucsc_TLS1_noProb.txt GencodeV41_UTR3_UCSC_ComprehensiveSet.bed > GencodeV41_UTR3_UCSC_noProb_CompSet_TLS1.tsv