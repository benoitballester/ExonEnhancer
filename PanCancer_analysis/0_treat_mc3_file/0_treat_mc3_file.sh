#!/bin/bash 

###1: formate raw mc3 file 
awk '{print "chr"$5,$6,$7,$0}' OFS='\t' mc3.v0.2.8.PUBLIC.maf.gz > mc3.v0.2.8.PUBLIC_coordinatesReplaced.maf

###2: lift exon enhancer hg38 to hg19 using UCSC lift over
~/UCSC_commands/liftOver exonhancers_candidates_coordinates_hg38.tsv hg38ToHg19.over.chain exonhancers_candidates_coordinates_hg19.tsv unmapped

###3: make snp file 
#the ref allele is always the same as the tumor allele 1 so we take only one of the two
#every snp is in GRCh37 so we dont have to keep that info
# we take the Tumor_Sample_Barcode and normal barcode
awk '{start=$3-1; print $1,start,$3,$17,$14,$16,$12,$4,$19,$20}' OFS=$'\t' mc3.v0.2.8.PUBLIC_coordinatesReplaced.maf > tmp
sort -k1,1 -k2,2n tmp |sort -u > tmp1
python prepare_snp_file.py tmp1 tissue_source_sites_codes_dictionnay.tsv tcga_cancer_abrev_dic.tsv #will give tcga_all_snps_hg19.tsv and snpId_fabianFormat_dic.tsv (file necessary for the fabian analysis)
rm tmp tmp1
   
###4: overlap 
bedtools intersect -a tcga_all_snps_hg19.tsv -b exonhancers_candidates_coordinates_hg19.tsv -wa > tcga_snp_exonhancers_hg19.tsv

###5: make the different snp files needed for the analyses 
#for distrib in supp 
awk '{print $1,$2,$3,$5,$6,$7,$11}' OFS=$'\t' tcga_snp_exonhancers_hg19.tsv |awk '{if ($4!="-") print}' OFS=$'\t' |awk '{if ($5!="-") print}' OFS=$'\t' |sort -u > tcga_snp_exonhancers_raw_uniques_hg19.tsv

# for deseq
sort -k18,18 -k4,4 tcga_snp_exonhancers_hg19.tsv > tcga_snp_exonhancers_SortedByCancer_hg19.tsv
cp tcga_snp_exonhancers_SortedByCancer_hg19.tsv tcga_snp_exonhancers_allall.tsv
awk '{if ($13=="Silent") print}' OFS=$'\t' tcga_snp_exonhancers_SortedByCancer_hg19.tsv > tcga_snp_exonhancers_allsyn.tsv

# for the distribution of snp per patient  
awk '{print $7,$8,$9,$11,$12,$17,$18}' OFS=$'\t' tcga_snp_exonhancers_SortedByCancer_hg19.tsv |sort -u > tcga_snp_exonhancers_for_plot_hg19.tsv

# snp per ee per patients per cancer
awk '{print $7,$8,$9,$11,$12,$13,$4,$17,$18}' OFS=$'\t' tcga_snp_exonhancers_hg19.tsv > tcga_variants_in_ee_per_patients_per_cancers_hg19.tsv