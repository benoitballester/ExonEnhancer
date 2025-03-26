#!/bin/bash
#
# The lead SNPs from GWAS Catalog were linked with common SNPs from 1000 Genomes Project by Plink with parameters of –ld-window-kb 1000 –ld-window-r2 0.8,
# allowing to retrieve SNPs within 1 Mb in high linkage disequilibrium (r2 > 0.8) of each lead SNP

### SNP LIST
for chr in {1..22} X; do
  BFILE="filtered_nodups_chr${chr}"   # e.g. filtered_chr1.bed/bim/fam, etc.

  # List of lead SNPs on this chromosome
  SNP_LIST="/home/mouren/Data/variants/gwas/ld_pipe/lead_snps_chr${chr}.txt"

  OUT_PREFIX="ld_chr${chr}"
  
  /home/mouren/Data/variants/gwas/ld_pipe/plink/plink --bfile "${BFILE}" --r2 --ld-snp-list "${SNP_LIST}" --ld-window-kb 1000 --ld-window-r2 0.8 --threads 8 --out "./ld_res/${OUT_PREFIX}"
  # Explanation of parameters:
  #   --r2: produce pairwise LD statistics
  #   --ld-snp <ID>: specify the "index" (lead) SNP
  #   --ld-snp-list
  #   --ld-window-kb 1000: only consider SNPs within 1,000 kb (1 Mb)
  #   --ld-window-r2 0.8: only report SNP pairs with r² >= 0.8

done

head -1 ./ld_res/ld_chr1.ld > all_LD_snps_merged.ld

for f in ./ld_res/ld_chr*.ld; do
    tail -n +2 "$f"
done >> all_LD_snps_merged.ld