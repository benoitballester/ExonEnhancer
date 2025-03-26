#snakemake -c8 -s /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/2_Snakefile_bilan_dm6.smk
rule all:
    input:
        "dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv" 

rule bilan_remap:
    input:
        "coord",
        "/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_nr_macs2_dm6_v1_0.bed",
    output:
        "bilan_remap"
    shell:
        "/home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/bedBilan.sh {input} > {output}"

rule tss_dataset:
    input:
        exons="bilan_remap",
        tss="tss_dm6",
    output:
        "bilan_remap_CAGEtss"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/tss_dataset_bilan.py {input.tss}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($16=="") $16="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule NC1:
    input:
        exons="bilan_remap_CAGEtss",
        nc1_3="nc1_3_dm6",
        nc1_5="nc1_5_dm6"
    output:
        "bilan_remap_CAGEtss_NC1"
    shell:
        """
        cat {input.nc1_3} {input.nc1_5} >> res
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/non_coding_bilan.py res
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_nc1 {input.exons} > tmp
        awk '{{if ($17=="") $17="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm res tmp_nc1 tmp {input.exons}
        """

rule TSS:
    input:
        exons="bilan_remap_CAGEtss_NC1",
        tss="TSS_dm6",
    output:
        "bilan_remap_CAGEtss_NC1_TSS"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/TSS_bilan.py {input.tss}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_tss {input.exons} > tmp
        awk '{{if ($18=="") $18="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_tss tmp {input.exons}
        """

rule TES:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS",
        tes="TES_dm6",
    output:
        "bilan_remap_CAGEtss_NC1_TSS_TES"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/TES_bilan.py {input.tes}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_tes {input.exons} > tmp
        awk '{{if ($19=="") $19="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_tes tmp {input.exons}
        """

rule UTR5:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS_TES",
        utr="utr5_dm6",
    output:
        "bilan_remap_CAGEtss_NC1_TSS_TES_UTR5"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/UTR5_bilan.py {input.utr}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_utr {input.exons} > tmp
        awk '{{if ($20=="") $20="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_utr tmp {input.exons}
        """

rule UTR3:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS_TES_UTR5",
        utr="utr3_dm6",
    output:
        "bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/UTR3_bilan.py {input.utr}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_utr {input.exons} > tmp
        awk '{{if ($21=="") $21="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_utr tmp {input.exons}
        """

rule density:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3",
        density="dm6_density",
    output:
        "bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/density_bilan.py {input.density}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($22=="") $22="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule density_50bp:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density",
        density="dm6_density_50",
    output:
        "bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/50density_bilan.py {input.density}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($23=="") $23="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule numbers_and_correlation:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp",
        remap_summits="/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_all_macs2_dm6_v1_0.bed",
        remap_peaks="/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_peaks_overlap_remap2022_all_macs2_dm6_v1_0.bed"
    output:
        "bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl"
    shell:
        """
        awk -F'\t' '{{print $4}}' {input.remap_summits} | sort | uniq -c  > tmp_summits
        awk -F'\t' '{{print $4}}' {input.remap_peaks} | sort | uniq -c  > tmp_peaks

        awk 'NR==FNR{{a[$2]=$1; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_summits {input.exons} > tmp1
        awk '{{if ($24=="") $24="NA"; print $0}}' OFS=$'\t' tmp1 > tmp2

        awk 'NR==FNR{{a[$2]=$1; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_peaks tmp2 > tmp3
        awk '{{if ($25=="") $25="NA"; print $0}}' OFS=$'\t' tmp3 > tmp4

        awk -F'\t' '{{t=$24*100; $26=t/$25; print;}}' OFS='\t' tmp4 > tmp5
        awk -F'\t' '{{t=$22*100; $27=t/$25; print;}}' OFS='\t' tmp5 > tmp6
        awk -F'\t' '{{$28=int($26+$27); print;}}' OFS=$'\t' tmp6 > {output}

        rm tmp_summits tmp_peaks tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 {input.exons}
        """

rule dnase_chipatlas:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl",
        dnase="dm6_dnase_chipatlas",
        dic="/home/mouren/Data/final_files_tokeep/other_species/data/dnase_atac/dic_chipAtlas/dic_chipAtlas_dm6.tsv"
    output:
        "bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/dnase_chipAtlas.py {input.dnase} {input.dic}
        awk 'NR==FNR{{a[$1]=$2"\t"$3"\t"$4"\t"$5; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($29=="") $29="NA"; if ($30=="") $30="NA"; if ($31=="") $31="NA"; if ($32=="") $32="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule atac_chipatlas:
    input:
        exons="bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase",
        atac="dm6_atac_chipatlas",
        dic="/home/mouren/Data/final_files_tokeep/other_species/data/dnase_atac/dic_chipAtlas/dic_chipAtlas_dm6.tsv"
    output:
        "dm6_bilan_remap_CAGEtss_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_ChipAtlasDnase_ATAC.tsv"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/dm6/scripts_ovlp_datasets/atac_chipAtlas.py {input.atac} {input.dic}
        awk 'NR==FNR{{a[$1]=$2"\t"$3"\t"$4"\t"$5; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($33=="") $33="NA"; if ($34=="") $34="NA"; if ($35=="") $35="NA"; if ($36=="") $36="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """