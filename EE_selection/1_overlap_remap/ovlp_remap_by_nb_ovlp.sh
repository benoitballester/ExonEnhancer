#!/bin/bash

#The 3 cat plot is made to observe the distribution of TF on the exons when we group the exons par the number of NR overlap with Tf summits. The exons falling on the TSS and TES are removed. all the others are kept (no other filters applied)

### Get exons coordiantes
awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/merge/coding_exons_50pb_merge_Hsap_tls1.tsv |sort -k1,1 -k2,2n - > hg_coord
awk '{if ($2>1000) $2=$2-1000; $3=$3+1000; print $1,$2,$3,$4,$5,$6}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/mm39/merge/coding_exons_50pb_merge_mm39.tsv |sort -k1,1 -k2,2n - > mm_coord
awk '{if ($2>500) $2=$2-500; $3=$3+500; print $1,$2,$3,$4,$5,$6}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/dm6/merge/coding_exons_50pb_merge_dm6.tsv |sort -k1,1 -k2,2n - > dm_coord
awk '{if ($2>500) $2=$2-500; $3=$3+500; print $1,$2,$3,$4,$5,$6}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/data/gencode/tair10/merge/coding_exons_50pb_merge_tair10.tsv |sort -k1,1 -k2,2n - > tair_coord

### Overlap (we overlap with the chipseq summit peaks and not the full body peak)
bedtools intersect -sorted -a hg_coord -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed -wa -wb > hg_ovlp
bedtools intersect -sorted -a mm_coord -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed -wa -wb > mm_ovlp
bedtools intersect -sorted -a dm_coord -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed -wa -wb > dm_ovlp
bedtools intersect -sorted -a tair_coord -b /home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed -wa -wb > tair_ovlp

### Remove TSS & TES; Filter by category : 5 or less; 5 and ten; more than 10
awk '{if ($22=="NA" && $23=="NA" && $11!="NA" && $11<5) print $4}' /home/mouren/Data/final_files_tokeep/final_catalogs/coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb_AllSummitsPeaksDensitySum_correl_DnaseEncodeChipAtlas_ATAC.bed > hg
awk '{if ($22=="NA" && $23=="NA" && $11!="NA" && $11<5) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > mm
awk '{if ($18=="NA" && $19=="NA" && $11!="NA" && $11<5) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > dm
awk '{if ($18=="NA" && $19=="NA" && $11!="NA" && $11<5) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > tair

grep -Ff hg hg_ovlp > hg5
grep -Ff mm mm_ovlp > mm5
grep -Ff dm dm_ovlp > dm5
grep -Ff tair tair_ovlp > tair5

awk '{if ($22=="NA" && $23=="NA" && $11!="NA" && $11>=5 && $11<10) print $4}' /home/mouren/Data/final_files_tokeep/final_catalogs/coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb_AllSummitsPeaksDensitySum_correl_DnaseEncodeChipAtlas_ATAC.bed > hg
awk '{if ($22=="NA" && $23=="NA" && $11!="NA" && $11>=5 && $11<10) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > mm
awk '{if ($18=="NA" && $19=="NA" && $11!="NA" && $11>=5 && $11<10) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > dm
awk '{if ($18=="NA" && $19=="NA" && $11!="NA" && $11>=5 && $11<10) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > tair

grep -Ff hg hg_ovlp > hg5_10
grep -Ff mm mm_ovlp > mm5_10
grep -Ff dm dm_ovlp > dm5_10
grep -Ff tair tair_ovlp > tair5_10

awk '{if ($22=="NA" && $23=="NA" && $11!="NA" && $11>=10) print $4}' /home/mouren/Data/final_files_tokeep/final_catalogs/coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb_AllSummitsPeaksDensitySum_correl_DnaseEncodeChipAtlas_ATAC.bed > hg
awk '{if ($22=="NA" && $23=="NA" && $11!="NA" && $11>=10) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > mm
awk '{if ($18=="NA" && $19=="NA" && $11!="NA" && $11>=10) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv > dm
awk '{if ($18=="NA" && $19=="NA" && $11!="NA" && $11>=10) print $4}' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/tair10_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_PlantRegMapDnase_AtacGEO.tsv > tair

grep -Ff hg hg_ovlp > hg10
grep -Ff mm mm_ovlp > mm10
grep -Ff dm dm_ovlp > dm10
grep -Ff tair tair_ovlp > tair10

rm mm dm tair hg hg_ovlp mm_ovlp dm_ovlp tair_ovlp hg_ovlp mm_ovlp dm_ovlp tair_ovlp hg_coord mm_coord dm_coord tair_coord