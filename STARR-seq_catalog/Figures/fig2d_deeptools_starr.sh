#!/bin/bash

starr_alla549="bigwig/a549/allENCODE_STARR_signal_A-549_normalized.bw"
starr_allk562="bigwig/k562/allENCODE_STARR_signal_K-562.bw"

random="random_regions.bed"
pos="control_pos_limited_coordinates.bed"
top1_hammal_myeloid="top1_myeloid.bed"
top1_hammal_respi="top1_respiratory.bed"

computeMatrix reference-point --missingDataAsZero -S $starr_alla549 -R $pos $random $top1_hammal_myeloid $top1_hammal_respi --referencePoint center -a 1000 -b 1000 -p 18 -o deeptools_matrixes/allexons_a549.mat
plotProfile -m deeptools_matrixes/allexons_k562.mat --averageType mean --yAxisLabel STARR-seq --refPointLabel 0 --regionsLabel Ctrl+ "Random regions" "Myeloid EE (n=808)" "Respiratory EE (n=408)" -o starr_signal_encode_a549_normalized.pdf

computeMatrix reference-point --missingDataAsZero -S $starr_allk562 -R $pos $random $top1_hammal_myeloid $top1_hammal_respi --referencePoint center -a 1000 -b 1000 -p 18 -o deeptools_matrixes/allexons_k562.mat
plotProfile -m deeptools_matrixes/allexons_a549.mat --averageType mean --yAxisLabel STARR-seq --refPointLabel 0 --regionsLabel Ctrl+ "Random regions" "Myeloid EE (n=808)" "Respiratory EE (n=408)" -o starr_signal_encode_k562_normalized.pdf