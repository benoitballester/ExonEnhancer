##### Running commands ######
# COMMAND TO LAUNCH IT :
# snakemake -s extract_bc.smk -c 'qsub -V -q tagc -l nodes=1:ppn=10' -j 6 --use-conda
# sbatch --wrap="snakemake --snakefile src/mpra_count_enhancer_bowtie2.smk --use-conda --cores 20" 
# snakemake --snakefile src/mpra_count_enhancer_bowtie2.smk --use-conda --cores 20 --cluster "sbatch -c 30 --mem=3000" --jobs 10



#####################################################################
#####################################################################
########### This pipeline take as input : mpra data files  ##########
######## 1. Create the reference library file to align reads ########

import sys
sys.path.append("./src/deps")
# from function_mpra import *

configfile: "src/deps/count_snp_mpra_config.yaml"

# Fonction pour extraire tous les échantillons
def get_all_samples():
    samples = []
    for group in config["samples"].values():
        if isinstance(group, dict):  # Pour cDNA qui a des sous-groupes
            for subgroup in group.values():
                samples.extend(subgroup)
        else:
            samples.extend(group)  # Pour Input
    return samples


rule all:
    input:
        expand("{workdir}/20231212_macrogen_EN00003898/ratio/{sample}_ratio_with_input.tsv", workdir=config['workdir'], sample=config['samples']['cDNA']['NS'] + config['samples']['cDNA']['Stim']),
        expand("{workdir}/20231212_macrogen_EN00003898/info/{sample}_mapping_info.txt", workdir=config['workdir'], sample=get_all_samples())
        # expand("{workdir}/20231212_macrogen_EN00003898/count/{sample}.tsv", workdir=config['workdir'], sample=get_all_samples())

# rule cutadapt:
#     input:
#         raw=lambda wildcards: config['inp_directory'] + wildcards.sample + ".fastq.gz"
#     output:
#         trimmed=config['workdir'] + "/20231212_macrogen_EN00003898/inp_filter/{sample}.trim.fastq.gz"
#     params:
#         max_n=config['cutadapt']['max_n']
#     conda:
#         "deps/mpra_envs.yaml"
#     shell:
#         "cutadapt --max-n {params.max_n} -o {output.trimmed} {input.raw}"

# This rule mapped the enhancer on the library (need to build the bowtie2 index first) in very-sensitive mode.
# Unmapped reads and reads that map the reverse strand are filtered out as some sequences of the library are present in both orientation
rule bowtie2_mapping_and_filtering:
    input:
        raw_1=lambda wildcards: config['inp_directory'] + wildcards.sample + "_1.fastq.gz",
        raw_2=lambda wildcards: config['inp_directory'] + wildcards.sample + "_2.fastq.gz"
    output:
        bam_file=config['workdir'] + "/20231212_macrogen_EN00003898/bam/{sample}_filtered.bam",
        bam_index=config['workdir'] + "/20231212_macrogen_EN00003898/bam/{sample}_filtered.bam.bai"
    params:
        bowtie2_index=config["bowtie2_lib"]
    conda:
        "deps/mpra_envs.yaml"
    shell:
        """
        bowtie2 --very-sensitive -x {params.bowtie2_index} \
        -1 {input.raw_1} -2 {input.raw_2} | \
        samtools view -bS -F 20 - | \
        samtools sort -o {output.bam_file} - && \
        samtools index {output.bam_file}
        """

rule samtools_count:
    input:
        bam_file=config['workdir'] + "/20231212_macrogen_EN00003898/bam/{sample}_filtered.bam"
    output:
        count_file=config['workdir'] + "/20231212_macrogen_EN00003898/count/{sample}.tsv"
    conda:
        "deps/mpra_envs.yaml"
    shell:
        """
        samtools idxstats {input.bam_file} | cut -f1,3 > {output.count_file}
        """

# rule samtools_filter:
#     input:
#         sorted_bam=config['workdir'] + "/20231212_macrogen_EN00003898/bam/{sample}.bam"
#     output:
#         bam_index=config['workdir'] + "/20231212_macrogen_EN00003898/bam/{sample}.bam",
#         count_file=config['workdir'] + "/20231212_macrogen_EN00003898/count/{sample}.tsv"
#     conda:
#         "deps/mpra_envs.yaml"
#     shell:
#         """
#         samtools view -F 20 {input.sorted_bam} | \
#         cut -f 3 | sort | uniq -c > {output.count_file}
#         """

# rule bowtie2_mapping_perfect_mapping:
#     input:
#         trimmed=lambda wildcards: config['workdir'] + "/20231212_macrogen_EN00003898/inp_filter/" + wildcards.sample + ".trim.fastq.gz"
#     output:
#         count_file=config['workdir'] + "/20231212_macrogen_EN00003898/count/{sample}.tsv"
#     params:
#         bowtie2_index=config["bowtie2_lib"]
#     conda:
#         "deps/mpra_envs.yaml"
#     shell:
#         """
#         bowtie2 --end-to-end -N 0 --mp 10000 --np 10000 --rdg 10000 --rfg 10000 -a \
#         -x {params.bowtie2_index} \
#         -U {input.trimmed} | \
#         samtools view -bS - | samtools sort - | samtools view - | \
#         cut -f 3 | uniq -c > {output.count_file}
#         """



rule add_header_and_normalize:
    input:
        counts="{workdir}/20231212_macrogen_EN00003898/count/{sample}.tsv"
    output:
        normalized_counts="{workdir}/20231212_macrogen_EN00003898/count_normalized/{sample}.tsv",
        mapping_info="{workdir}/20231212_macrogen_EN00003898/info/{sample}_mapping_info.txt"
    run:
        import pandas as pd
        data = pd.read_csv(input.counts, sep='\s+', header=None, names=['ID','count_sequence'])
        # Identify and delete unmapped reads
        # unmapped_reads = data[data['ID'] == '*']['count_sequence'].iloc[0]
        data = data[data['ID'] != '*']
        # Compute total read mapped count
        total_mapped_reads = data['count_sequence'].sum()
        # Compute CPM (Counts Per Million)
        data['CPM'] = (data['count_sequence'] / total_mapped_reads) * 1e6
        # Organize the dataframe
        data = data[['ID', 'count_sequence', 'CPM']]
        data.to_csv(output.normalized_counts, sep='\t', index=False)

        # Output
        with open(output.mapping_info, 'w') as info_file:
            info_file.write(f"Total Mapped Reads: {total_mapped_reads}\n")
            # info_file.write(f"Total Unmapped Reads: {unmapped_reads}\n")


rule merge_with_reference:
    input:
        counts="{workdir}/20231212_macrogen_EN00003898/count_normalized/{sample}.tsv",
        reference=config["enh_library"]
    output:
        merged="{workdir}/20231212_macrogen_EN00003898/count_normalized/{sample}_merged_with_reference.tsv"
    run:
        import pandas as pd
        counts_data = pd.read_csv(input.counts, sep='\t')
        ref_data = pd.read_csv(input.reference, sep='\t',header=0, names=['ID', 'insert'])
        # merge files
        merged_data = pd.merge(ref_data, counts_data, on='ID', how='left')
        # Replace NaN by 0 in count and CPM columns
        merged_data['count_sequence'].fillna(0, inplace=True)
        merged_data['CPM'].fillna(0, inplace=True)
        merged_data.to_csv(output.merged, sep='\t', index=False)