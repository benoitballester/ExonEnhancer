# We formate all starr-seq data in the narrowpeak format
rule all:
    input: 
        "ENCODE_GEO_active_hg38_sorted.narrowPeak",
        "ENCODE_GEO_silent_hg38_sorted.narrowPeak"

# No nlog10(qvalue) < 1.3 (0.05)
# No fold change < 0
#LC_ALL=C awk '{if ($9<=1.30) print}' ENCODE_narrowpeak_sorted.narrowPeak
#LC_ALL=C awk '{if ($7<=0) print}' ENCODE_narrowpeak_sorted.narrowPeak
rule encode_narrowpeak:
    input:
        "./hsap/encode/narrowpeak/ids"
    params:
        path="./hsap/encode/narrowpeak"
    output:
        "ENCODE_narrowpeak_sorted.narrowPeak",
    shell:
        """
        bash ./scripts_formatting/encode_starr_formating.sh {input} {params.path}
        cat {params.path}/treated_files/id_* >> tmp_encode_rule1  
        sort -k 1,1 -k 2,2n tmp_encode_rule1 |sort -u > {output}
        rm tmp_encode_rule1
        """

# No nlog10(qvalue) < 1.3 (0.05)
# No fold change < 0
#LC_ALL=C awk '{if ($9<=1.30) print}' ENCODE_narrowpeak_sorted.narrowPeak
#LC_ALL=C awk '{if ($7<=0) print}' ENCODE_narrowpeak_sorted.narrowPeak
rule encode_bed:
    input:
        "./hsap/encode/bed6+/ids"
    params:
        path="./hsap/encode/bed6+"
    output:
        "ENCODE_bed_sorted.narrowPeak",
    shell: 
        """
        bash ./scripts_formatting/encode_starr_formating.sh {input} {params.path}
        cat {params.path}/treated_files/id_* >> tmp_encode_rule2  
        awk '{{print $1,$2,$3,$4,$5,$6,$7,$9,$10,"NA"}}' OFS=$'\t' tmp_encode_rule2 |sort -k 1,1 -k 2,2n |sort -u > {output}
        rm tmp_encode_rule2
        """

rule geo_formmating:
    output:
        "./hsap/geo/geo_silent_narrowpeak.tsv",
        "./hsap/geo/geo_active_narrowpeak.tsv"
    shell: 
        """
        bash ./scripts_formatting/geo_datasets_format_active.sh
        bash ./scripts_formatting/geo_datasets_format_silent.sh
        """

rule merging_cleaning:
    input:
        encode_narr="ENCODE_narrowpeak_sorted.narrowPeak",
        encode_bed="ENCODE_bed_sorted.narrowPeak",
        geo_silent="./hsap/geo/geo_silent_narrowpeak.tsv",
        geo_active="./hsap/geo/geo_active_narrowpeak.tsv"
    output:
        narr_active="ENCODE_GEO_active_hg38_sorted.narrowPeak",
        narr_silent="ENCODE_GEO_silent_hg38_sorted.narrowPeak",
    shell: 
        """
        cat {input.encode_narr} {input.encode_bed} {input.geo_active} >> tmp_active

        awk '$1 !~ /_/ {{ print }}' OFS=$'\t' tmp_active > tmp_active_clean
        awk '$1 !~ /_/ {{ print }}' OFS=$'\t' {input.geo_silent} > tmp_silent_clean

        python ./scripts_formatting/starrseq_cleaning.py tmp_active_clean
        sort -u tmp_file_clean |sort -k 1,1 -k 2,2n > {output.narr_active}
        rm tmp_file_clean

        python ./scripts_formatting/starrseq_cleaning.py tmp_silent_clean
        sort -u tmp_file_clean |sort -k 1,1 -k 2,2n > {output.narr_silent}
        rm tmp_file_clean

        rm tmp_active tmp_active_clean tmp_silent_clean

        gzip {input.encode_narr}
        gzip {input.encode_bed}
        gzip {input.geo_active}
        gzip {input.geo_silent}
        """