#snakemake -c8 -s /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/2_Snakefile_bilan_mm39.smk
rule all:
    input:
        "mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv" 

rule bilan_remap:
    input:
        "coord",
        "/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_nr_macs2_mm39_v1_0.bed",
    output:
        "bilan_remap"
    shell:
        "/home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/bedBilan.sh {input} > {output}"

rule encode_ccre:
    input:
        exons="bilan_remap",
        encode="encode_ccre_mm39",
    output:
        "bilan_remap_ccre"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/ccres_encode_bilan.py {input.encode}
        awk 'NR==FNR{{a[$4]=$11"\t"$12; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_ccre {input.exons} > tmp
        awk '{{if ($16=="") $16="NA"; if ($17=="") $17="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_ccre tmp {input.exons}
        """

rule fantom:
    input:
        exons="bilan_remap_ccre",
        fantom="fantom_tss_mm39",
    output:
        "bilan_remap_ccre_CAGEtss"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/fantom_bilan.py {input.fantom}
        awk 'NR==FNR{{a[$4]=$11"\t"$12; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_fantom {input.exons} > tmp
        awk '{{if ($18=="") $18="NA"; if ($19=="") $19="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_fantom tmp {input.exons}
        """

rule fantom_enh:
    input:
        exons="bilan_remap_ccre_CAGEtss",
        fantom="fantom_enh_mm39",
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/ENHfantom_bilan.py {input.fantom}
        awk 'NR==FNR{{a[$4]=$11"\t"$12; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_fantom {input.exons} > tmp
        awk '{{if ($20=="") $20="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_fantom tmp {input.exons}
        """

rule NC1:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh",
        nc1_3="nc1_3_mm39",
        nc1_5="nc1_5_mm39"
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1"
    shell:
        """
        cat {input.nc1_3} {input.nc1_5} >> res
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/non_coding_bilan.py res
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_nc1 {input.exons} > tmp
        awk '{{if ($21=="") $21="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm res tmp_nc1 tmp {input.exons}
        """

rule TSS:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1",
        tss="TSS_mm39",
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/TSS_bilan.py {input.tss}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_tss {input.exons} > tmp
        awk '{{if ($22=="") $22="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_tss tmp {input.exons}
        """

rule TES:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS",
        tes="TES_mm39",
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/TES_bilan.py {input.tes}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_tes {input.exons} > tmp
        awk '{{if ($23=="") $23="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_tes tmp {input.exons}
        """

rule UTR5:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES",
        utr="utr5_mm39",
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/UTR5_bilan.py {input.utr}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_utr {input.exons} > tmp
        awk '{{if ($24=="") $24="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_utr tmp {input.exons}
        """

rule UTR3:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5",
        utr="utr3_mm39",
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/UTR3_bilan.py {input.utr}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_utr {input.exons} > tmp
        awk '{{if ($25=="") $25="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_utr tmp {input.exons}
        """

rule density:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3",
        density="mm39_density",
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/density_bilan.py {input.density}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($26=="") $26="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule density_50bp:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density",
        density="mm39_density_50",
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/50density_bilan.py {input.density}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($27=="") $27="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule numbers_and_correlation:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp",
        remap_summits="/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_all_macs2_mm39_v1_0.bed",
        remap_peaks="/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_peaks_overlap_remap2022_all_macs2_mm39_v1_0.bed"
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl"
    shell:
        """
        awk -F'\t' '{{print $4}}' {input.remap_summits} | sort | uniq -c  > tmp_summits
        awk -F'\t' '{{print $4}}' {input.remap_peaks} | sort | uniq -c  > tmp_peaks

        awk 'NR==FNR{{a[$2]=$1; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_summits {input.exons} > tmp1
        awk '{{if ($28=="") $28="NA"; print $0}}' OFS=$'\t' tmp1 > tmp2

        awk 'NR==FNR{{a[$2]=$1; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_peaks tmp2 > tmp3
        awk '{{if ($29=="") $29="NA"; print $0}}' OFS=$'\t' tmp3 > tmp4

        awk -F'\t' '{{t=$28*100; $30=t/$29; print;}}' OFS='\t' tmp4 > tmp5
        awk -F'\t' '{{t=$26*100; $31=t/$29; print;}}' OFS='\t' tmp5 > tmp6
        awk -F'\t' '{{$32=int($31+$30); print;}}' OFS=$'\t' tmp6 > {output}

        rm tmp_summits tmp_peaks tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 {input.exons}
        """

rule dnase_encode:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl",
        dnase="mm39_dnase_encode",
        dic="/home/mouren/Data/final_files_tokeep/other_species/data/dnase_atac/mm10_dnase_encode/Breeze_et_al_TABLE_S1.tsv"
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODE"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/dnase_encode.py {input.dnase} {input.dic}
        awk 'NR==FNR{{a[$1]=$2"\t"$3; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($33=="") $33="NA"; if ($34=="") $34="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule dnase_chipatlas:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODE",
        dnase="mm39_dnase_chipatlas",
        dic="/home/mouren/Data/final_files_tokeep/other_species/data/dnase_atac/dic_chipAtlas/dic_chipAtlas_mm39.tsv"
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/dnase_chipAtlas.py {input.dnase} {input.dic}
        awk 'NR==FNR{{a[$1]=$2"\t"$3"\t"$4"\t"$5; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($35=="") $35="NA"; if ($36=="") $36="NA"; if ($37=="") $37="NA"; if ($38=="") $38="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule atac_chipatlas:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas",
        atac="mm39_atac_chipatlas",
        dic="/home/mouren/Data/final_files_tokeep/other_species/data/dnase_atac/dic_chipAtlas/dic_chipAtlas_mm39.tsv"
    output:
        "mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv"
    shell:
        """
        grep chr1 {input.atac} > chr1
        grep -v chr1 {input.atac} > chrall
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/atac_chipAtlas.py chr1 {input.dic}
        mv tmp res
        python /home/mouren/Data/repoexonhancer/other_species/overlap/mm39/scripts_ovlp_datasets/atac_chipAtlas.py chrall {input.dic}
        cat res >> tmp
        awk 'NR==FNR{{a[$1]=$2"\t"$3"\t"$4"\t"$5; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($39=="") $39="NA"; if ($40=="") $40="NA"; if ($41=="") $41="NA"; if ($42=="") $42="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm chr1 chrall res tmp tmp1 {input.exons}
        """