#snakemake -c8 -s /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/3_Snakefile_filtering_addTag_hg38.smk

rule all:
    input: 
         "EE_summary_hg38.tsv"

rule filter:
    input:
        "hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv"
    output:
        "hg38_bilan.bed",
    shell:
        """
        awk '{{if ($22=="NA") print $0}}' OFS=$'\t' {input} > tmp1      #tss
        awk '{{if ($23=="NA") print $0}}' OFS=$'\t' tmp1 > tmp2         #tes
        awk '{{if ($26>=$27) print $0}}' OFS=$'\t' tmp2 > tmp3          #shape of remap density
        awk '{{if ($18=="NA") print $0}}' OFS=$'\t' tmp3 > tmp4         #tss fantom
        awk -F'\t' '$17!~/.*prom.*/{{print $0}}' OFS=$'\t' tmp4 > tmp5   #prom encode
        awk '{{if ($28!="NA") print $0}}' OFS=$'\t' tmp5 > tmp6         #peak remap
        awk '{{if ($28>=10) print $0}}' OFS=$'\t' tmp6 > tmp_r          #robust
        awk '{{if ($30>=50) print $0}}' OFS=$'\t' tmp_r > {output}      #density 50%
        rm tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp_r
        """

rule divide_robust:
    input:
        "hg38_bilan.bed",
    output:
        "robust_bilan_without_nonCoding_firstExon.tsv"
    shell: 
        """
        mkdir /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_exons_filtered/robust
        awk -F'\t' '{{if ($21!="NA") print $0}}' OFS=$'\t' {input} > R_NC1.tsv
        awk -F'\t' '{{if ($21=="NA") print $0}}' OFS=$'\t' {input} > {output}
        awk -F'\t' '{{if ($24!="NA" || $25!="NA") print $0}}' OFS=$'\t' {output} > R_UTR.tsv
        awk -F'\t' '{{if ($24=="NA" && $25=="NA") print $0}}' OFS=$'\t' {output} > R_C.tsv
        mv R_* /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_exons_filtered/robust
        """

rule addTag:
    input:
        bilan_filtered="hg38_bilan.bed",
        file_rm="robust_bilan_without_nonCoding_firstExon.tsv",
    output:
        robust_catalog="EE_summary_hg38.tsv"
    shell: 
        """
        awk '{{print $4,"R_C"}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_exons_filtered/robust/R_C.tsv > exons_tag_id
        awk '{{print $4,"R_NC1"}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_exons_filtered/robust/R_NC1.tsv >> exons_tag_id
        awk '{{print $4,"R_UTR"}}' OFS=$'\t' /home/mouren/Data/final_files_tokeep/other_species/overlap_bilan/hg38_exons_filtered/robust/R_UTR.tsv >> exons_tag_id
        awk 'NR==FNR{{a[$1]="\t"$2; next}} {{print $0, a[$4]}}' OFS=$'\t' exons_tag_id {input.bilan_filtered} > aaa
        
        grep R_ aaa |awk '{{print $1,$2,$3,$4,$5,$6,$8,$11,$12,$13,$14,$15,$17,$21,$24,$25,$28,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$40,$41,$42,$43}}' OFS=$'\t' > {output.robust_catalog}
        rm {input} exons_tag_id aaa
        """
