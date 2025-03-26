#!/bin/bash

#1000genome phase3 vcfs were filtered by Plink (v1.9) (56) from 5 super populations (European, African, American, East Asian and South Asian) #meaning in 1000genomes there are only those five, we do not filter that its already done
#using the following parameters: the proportion of missing genotypes 5%, MAE 1%, Hardy-Weinberg equilibrium 1e-6.

# Example script to filter 1000 Genomes VCF for chromosome 1 using Plink v1.9
# Filters used:
#   --geno 0.05   (exclude SNPs with >5% missing data)
#   --maf 0.01    (exclude SNPs with MAF <1%)
#   --hwe 1e-6    (exclude SNPs with HWE p-value <1e-6)

for chr in {1..22} X Y; do
    VCF_IN="ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v3plus_nounphased.rsID.genotypes.GRCh38_dbSNP.vcf.gz"
    OUT_PREFIX="filtered_chr${chr}"

    /home/mouren/Data/variants/gwas/ld_pipe/plink/plink --vcf "${VCF_IN}" --vcf-half-call missing --maf 0.01 --geno 0.05 --hwe 1e-6 --make-bed --threads 8 --out "${OUT_PREFIX}"
done

#remove duplicates
for chr in {1..22} X; do #No Y 
    /home/mouren/Data/variants/gwas/ld_pipe/plink/plink --bfile filtered_chr${chr} --write-snplist --threads 8 --out all_snps_${chr} # write all SNP IDs to all_snps.snplist, duplicates occur multiple times; this operation can also be performed with e.g. cut or awk
    cat all_snps_${chr}.snplist |sort |uniq -d > duplicated_snps_${chr}.snplist # write the duplicate IDs to duplicated_snps.snplist
    OUT_PREFIX="filtered_nodups_chr${chr}"
    /home/mouren/Data/variants/gwas/ld_pipe/plink/plink --bfile filtered_chr${chr} --exclude duplicated_snps_${chr}.snplist --make-bed --threads 8 --out "${OUT_PREFIX}"
done