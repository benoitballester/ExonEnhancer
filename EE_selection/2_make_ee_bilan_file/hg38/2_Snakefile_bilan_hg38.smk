rule all:
    input: 
        "hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv",

rule bilan_remap:
    input:
        exon_file="coding_exons_50pb_merge_Hsap_tls1.tsv",
        remap_file="/home/mouren/Data/final_files_tokeep/tls1/overlap_remap_result/exact_summit_overlap_remap2022_nr_macs2_hg38_v1_0.bed",
    output:
        "bilan_remap"
    shell:
        "/home/mouren/Data/repoexonhancer/exonhancers_catalog_making_filtering/scripts_ovlp_datasets/bedBilan.sh {input} > {output}"

rule encode_ccre:
    input:
        exon_file="bilan_remap",
        encode="encode_ccre_hg38",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/ccres_encode_bilan.py {input.encode}
        awk 'NR==FNR{{a[$4]=$11"\t"$12; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_ccre {input.exons} > tmp
        awk '{{if ($16=="") $16="NA"; if ($17=="") $17="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_ccre tmp {input.exons}
        """

rule fantom:
    input:
        fantom1="fantom_tss_hg38",
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs.bed",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/fantom_bilan.py {input.fantom}
        awk 'NR==FNR{{a[$4]=$11"\t"$12; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_fantom {input.exons} > tmp
        awk '{{if ($18=="") $18="NA"; if ($19=="") $19="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_fantom tmp {input.exons}
        """

rule fantom_enh:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5.bed",
        fantom1="/home/mouren/Data/final_files_tokeep/fantom5/fantom_enh_hg38",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/ENHfantom_bilan.py {input.fantom}
        awk 'NR==FNR{{a[$4]=$11"\t"$12; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_fantom {input.exons} > tmp
        awk '{{if ($20=="") $20="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_fantom tmp {input.exons}
        """

rule NC1:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh.bed",
        nc1="nc1_5_hg38",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/non_coding_bilan.py {input.nc1}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_nc1 {input.exons} > tmp
        awk '{{if ($21=="") $21="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm res tmp_nc1 tmp {input.exons}
        """

rule TSS:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding.bed",
        tss="TSS_hg38",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/TSS_bilan.py {input.tss}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_tss {input.exons} > tmp
        awk '{{if ($22=="") $22="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_tss tmp {input.exons}
        """

rule TES:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS.bed",
        tes="TES_hg38",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/TES_bilan.py {input.tes}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_tes {input.exons} > tmp
        awk '{{if ($23=="") $23="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_tes tmp {input.exons}
        """

rule UTR5:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES.bed",
        utr5="utr5_hg38",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/UTR5_bilan.py {input.utr}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_utr {input.exons} > tmp
        awk '{{if ($24=="") $24="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_utr tmp {input.exons}
        """

rule UTR3:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5.bed",
        utr3="utr3_hg38",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/UTR3_bilan.py {input.utr}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp_utr {input.exons} > tmp
        awk '{{if ($25=="") $25="NA"; print $0}}' OFS=$'\t' tmp > {output} 
        rm tmp_utr tmp {input.exons}
        """

rule density:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3.bed",
        density_file="hg38_density",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/density_bilan.py {input.density}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($26=="") $26="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule density50bp:
    input:
        exon_file="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity.bed",
        density50bp_file="hg38_density_50",
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb.bed"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/50density_bilan.py {input.density}
        awk 'NR==FNR{{a[$4]=$11; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($27=="") $27="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule numbers_and_correlation:
    input:
        exons="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb.bed",
        remap_summits="/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_summit_overlap_remap2022_all_macs2_hg38_v1_0.bed",
        remap_peaks="/home/mouren/Data/final_files_tokeep/other_species/data/overlap_remap/exact_peaks_overlap_remap2022_all_macs2_hg38_v1_0.bed"
    output:
        "coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb_AllSummitsPeaksDensitySum_correl.bed"
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
        exons="coding_exons_bilan_ovlpTF_NR_cCREs_FANTOM5+Enh_NonCoding_TSS_TES_UTR5_UTR3_peakDensity_density50pb_AllSummitsPeaksDensitySum_correl.bed",
        dnase="hg38_dnase_encode",
        dic="/mnt/project/exonhancer/ZENODO_REPO/Chromatin_accessibility/ENCODE_DNAse/hg38/encode_cellLine_clean.tsv"
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODE"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/dnase_encode.py {input.dnase} {input.dic}
        awk 'NR==FNR{{a[$1]=$2"\t"$3; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($33=="") $33="NA"; if ($34=="") $34="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule dnase_chipatlas:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODE",
        dnase="hg38_dnase_chipatlas",
        dic="chipAtlas_expID_biotype.tsv"
    output:
        "bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas"
    shell:
        """
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/dnase_chipAtlas.py {input.dnase} {input.dic}
        awk 'NR==FNR{{a[$1]=$2"\t"$3"\t"$4"\t"$5; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($35=="") $35="NA"; if ($36=="") $36="NA"; if ($37=="") $37="NA"; if ($38=="") $38="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm tmp tmp1 {input.exons}
        """

rule atac_chipatlas:
    input:
        exons="bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas",
        atac="hg38_atac_chipatlas",
        dic="chipAtlas_expID_biotype.tsv"
    output:
        "hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv"
    shell:
        """
        grep chr1 {input.atac} > chr1
        grep -v chr1 {input.atac} > chrall
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/atac_chipAtlas.py chr1 {input.dic}
        mv tmp res
        python /home/mouren/Data/repoexonhancer/other_species/overlap/hg38/scripts_ovlp_datasets/atac_chipAtlas.py chrall {input.dic}
        cat res >> tmp
        awk 'NR==FNR{{a[$1]=$2"\t"$3"\t"$4"\t"$5; next}} {{print $0, a[$4]}}' OFS=$'\t' tmp {input.exons} > tmp1
        awk '{{if ($39=="") $39="NA"; if ($40=="") $40="NA"; if ($41=="") $41="NA"; if ($42=="") $42="NA"; print $0}}' OFS=$'\t' tmp1 > {output} 
        rm chr1 chrall res tmp tmp1 {input.exons}
        """
