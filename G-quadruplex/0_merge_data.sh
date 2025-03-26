#!/bin/bash

awk '{print $1,$2,$3,"K_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003535_Arabidopsis_all_w15_th-1_minus.hits.max.K.w50.25.bed >> tmp_t
awk '{print $1,$2,$3,"K_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003539_Homo_all_w15_th-1_minus.hits.max.K.w50.25.bed >> tmp_h
awk '{print $1,$2,$3,"K_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003541_Drosophila_all_w15_th-1_minus.hits.max.K.w50.25.bed >> tmp_d
awk '{print $1,$2,$3,"K_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003547_Mouse_all_w15_th-1_minus.hits.max.K.w50.25.bed >> tmp_m

awk '{print $1,$2,$3,"K_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003535_Arabidopsis_all_w15_th-1_plus.hits.max.K.w50.25.bed >> tmp_t
awk '{print $1,$2,$3,"K_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003539_Homo_all_w15_th-1_plus.hits.max.K.w50.25.bed >> tmp_h
awk '{print $1,$2,$3,"K_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003541_Drosophila_all_w15_th-1_plus.hits.max.K.w50.25.bed >> tmp_d
awk '{print $1,$2,$3,"K_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003547_Mouse_all_w15_th-1_plus.hits.max.K.w50.25.bed >> tmp_m

awk '{print $1,$2,$3,"PDS_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003536_Arabidopsis_all_w15_th-1_plus.hits.max.PDS.w50.35.bed >> tmp_t
awk '{print $1,$2,$3,"PDS_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003540_Homo_all_w15_th-1_plus.hits.max.PDS.w50.35.bed >> tmp_h
awk '{print $1,$2,$3,"PDS_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003542_Drosophila_all_w15_th-1_plus.hits.max.PDS.w50.35.bed >> tmp_d
awk '{print $1,$2,$3,"PDS_plus_"NR,$4,"+"}' OFS=$'\t' Marsico2019_raw_data/GSM3003548_Mouse_all_w15_th-1_plus.hits.max.PDS.w50.35.bed >> tmp_m

awk '{print $1,$2,$3,"PDS_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003536_Arabidopsis_all_w15_th-1_minus.hits.max.PDS.w50.35.bed >> tmp_t
awk '{print $1,$2,$3,"PDS_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003540_Homo_all_w15_th-1_minus.hits.max.PDS.w50.35.bed >> tmp_h
awk '{print $1,$2,$3,"PDS_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003542_Drosophila_all_w15_th-1_minus.hits.max.PDS.w50.35.bed >> tmp_d
awk '{print $1,$2,$3,"PDS_minus_"NR,$4,"-"}' OFS=$'\t' Marsico2019_raw_data/GSM3003548_Mouse_all_w15_th-1_minus.hits.max.PDS.w50.35.bed >> tmp_m

sort -k1,1 -k2,2n tmp_t > tair10_g_quadruplex.bed
sort -k1,1 -k2,2n tmp_h > tmp_hg19
sort -k1,1 -k2,2n tmp_d > dm6_g_quadruplex.bed
sort -k1,1 -k2,2n tmp_m > tmp_mm10

~/UCSC_commands/liftOver tmp_hg19 /home/mouren/Data/final_files_tokeep/genomes_sizes/hg19ToHg38.over.chain hg38_g_quadruplex.bed hg19_unmapped
~/UCSC_commands/liftOver tmp_mm10 /home/mouren/Data/final_files_tokeep/genomes_sizes/mm10ToMm39.over.chain mm39_g_quadruplex.bed mm10_unmapped

rm tmp_t tmp_h tmp_d tmp_m tmp_hg19 tmp_mm10