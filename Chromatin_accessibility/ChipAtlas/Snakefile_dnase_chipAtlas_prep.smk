#snakemake -c8 -s /home/mouren/Data/repoexonhancer/dnase/Snakefile_dnase_chipAtlas_prep.smk
rule all:
    input: 
        "chipAtlas_expID_biotype.tsv",
        "DNase_chipAtlas_hg38.bed",
        "ATAC_chipAtlas_hg38.bed"

rule exp_dic_prerID:
    input:
        "/home/mouren/Data/final_files_tokeep/dnase_atac/dnase_atac_chipAtlas/experimentList.tab",
    output:
        "chipAtlas_expID_biotype.tsv",
    shell:
        """
        awk '{{if ($2=="hg38" && $3=="DNase-seq") print $1}}' {input} > dnase_hg38_id.txt
        awk '{{if ($2=="hg38" && $3=="ATAC-Seq") print $1}}' {input} > atac_hg38_id.txt
        
        python /home/mouren/Data/repoexonhancer/dnase/scripts_prep_chipAtlas/script_dnase_chipAtlas_prepV2.py {input}
        """

### Download dnase
#cat dnase_hg38_id.txt |xargs -n 1 -P 18 -I {} wget -O ./output_exp_dnase/{} https://chip-atlas.dbcls.jp/data/hg38/eachData/bb10/{}.10.bb

rule treat_dnase_data:
    params:
        path="/home/mouren/Data/final_files_tokeep/dnase_atac/dnase_atac_chipAtlas/output_exp_dnase"
    output:
        "DNase_chipAtlas_hg38.bed"
    shell:
        """
        source_folder={params.path}

        for file in "$source_folder"/*
        do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            ~/UCSC_commands/bigBedToBed "$file" tmp ||continue
            awk -v filename="$filename" '{{if ($5=="") $5=filename; print;}}' OFS=$'\t' tmp >> tmp_f
        fi
        done
        sort -k1,1 -k2,2 tmp_f > {output}
        rm tmp tmp_f
        """

### Download atac
#cat atac_hg38_id.txt |xargs -n 1 -P 18 -I {} wget -O ./output_exp_atac/{} https://chip-atlas.dbcls.jp/data/hg38/eachData/bb10/{}.10.bb

rule treat_atac_data:
    params:
        path="/home/mouren/Data/final_files_tokeep/dnase_atac/dnase_atac_chipAtlas/output_exp_atac"
    output:
        "ATAC_chipAtlas_hg38.bed"
    shell:
        """
        source_folder={params.path}

        for file in "$source_folder"/*
        do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            ~/UCSC_commands/bigBedToBed "$file" tmp ||continue
            awk -v filename="$filename" '{{if ($5=="") $5=filename; print;}}' OFS=$'\t' tmp >> tmp_f
        fi
        done
        sort -k1,1 -k2,2 tmp_f > {output}
        rm tmp tmp_f
        """

#tar -zcvf dnase_chipAtlas_bigBed_hg38.tar.gz output_exp_dnase
#tar -zcvf atac_chipAtlas_bigBed_hg38.tar.gz output_exp_atac