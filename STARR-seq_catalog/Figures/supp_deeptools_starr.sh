#!/bin/bash

starr_allk562="bigwig/k562/allENCODE_STARR_signal_K-562.bw"

random="random_regions.bed"
pos="control_pos_limited_coordinates.bed"

### plot top 3 
top3_myeloid="top3_myeloid.bed"
top3_embryo="top3_embryonic.bed"
top3_muscu="top3_musculoskeletal.bed"

computeMatrix reference-point --missingDataAsZero -S $starr_allk562 -R $top3_myeloid $pos $random $top3_embryo $top3_muscu $top3_respi --referencePoint center -a 1000 -b 1000 -p 18 -o deeptools_matrixes/top3.mat
plotProfile -m deeptools_matrixes/top3.mat --plotTitle "EE with biotype in top 3" --averageType mean --yAxisLabel STARR-seq --refPointLabel 0 --regionsLabel "Myeloid EE (n=2752)" Ctrl+ "Random regions" "Embryonic EE (n=4732)" "Musculoskeletal EE (n=3911)" -o /home/mouren/Images/tls1/supplementary_figures/supp_fig2/starr_signal/starr_encode_k562_Myeloid_Top3.pdf

###  plot top1
top1_myeloid="top1_myeloid.bed"
top1_embryo="top1_embryonic.bed"
top1_muscu="top1_musculoskeletal.bed"

computeMatrix reference-point --missingDataAsZero -S $starr_allk562 -R $top1_myeloid $pos $random $top1_embryo $top1_muscu $top1_respi --referencePoint center -a 1000 -b 1000 -p 18 -o deeptools_matrixes/top1.mat
plotProfile -m deeptools_matrixes/top1.mat --plotTitle "EE with biotype in top 1" --averageType mean --yAxisLabel STARR-seq --refPointLabel 0 --regionsLabel "Myeloid EE (n=808)" Ctrl+ "Random regions" "Embryonic EE (n=1564)" "Musculoskeletal EE (n=1421)" -o /home/mouren/Images/tls1/supplementary_figures/supp_fig2/starr_signal/starr_encode_k562_Myeloid_Top1.pdf


#### plot maj
maj_myeloid="maj_myeloid.bed"
maj_embryo="maj_embryonic.bed"
maj_muscu="maj_musculoskeletal.bed"

computeMatrix reference-point --missingDataAsZero -S $starr_allk562 -R $maj_myeloid $pos $random $maj_embryo $maj_muscu $maj_respi --referencePoint center -a 1000 -b 1000 -p 18 -o deeptools_matrixes/maj.mat
plotProfile -m deeptools_matrixes/maj.mat --plotTitle "EE with biotype in top 1 and >50% chipseq peaks" --averageType mean --yAxisLabel STARR-seq --refPointLabel 0 --regionsLabel "Myeloid EE (n=255)" Ctrl+ "Random regions" "Embryonic EE (n=124)" "Musculoskeletal EE (n=188)" -o /home/mouren/Images/tls1/supplementary_figures/supp_fig2/starr_signal/starr_encode_k562_Myeloid_maj.pdf
