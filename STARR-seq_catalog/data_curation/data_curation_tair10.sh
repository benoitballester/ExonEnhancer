#!/bin/bash

#List of enhancers identified were retrived from Supplementary Table 2 from Tan et al. 10.1111/tpj.16373
awk -F'\t' '(NR>2)' ST2_Tan2022.csv |awk '{nlog10=-(log($6)/log(10)); print $1,$2,$3,"Tan2023_"NR,"0",".",$7,"NA",nlog10,"NA"}' OFS='\t' |sort -k1,1 -k2,2n > Tan2023_active_tair10_sorted.narrowPeak
