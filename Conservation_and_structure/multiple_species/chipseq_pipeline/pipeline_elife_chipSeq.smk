# sbatch /shared/projects/exonhancer/repoexonhancer/conservation/launcher.sh

# macs2 2.2.7.1 sambamba 1.0.0 samtools 1.18 bowtie2 2.5.1 fastp 0.23.1 snakemake 8.9.0

# fastqc and multiqc for reads quality control : https://github.com/hbctraining/Intro-to-ChIPseq-flipped/blob/main/lessons/03_QC_FASTQC.md
# Bowtie2 for alignment : https://github.com/hbctraining/Intro-to-ChIPseq-flipped/blob/main/lessons/04_alignment_using_bowtie2.md
# MACS2 for peak calling : https://github.com/hbctraining/Intro-to-ChIPseq-flipped/blob/main/lessons/06_peak_calling_macs.md

# Genome indexes have been built prior to the pipeline with the following command : 
    # bowtie2-build --threads 4 /shared/projects/exonhancer/data/conservation/genome_files/hg38.fa /shared/projects/exonhancer/data/conservation/genome_files/bowtie2_indexes/hg38/hg38
    # bowtie2-build --threads 4 /shared/projects/exonhancer/data/conservation/genome_files/rheMac10.fa /shared/projects/exonhancer/data/conservation/genome_files/bowtie2_indexes/mml10/mml10
    # bowtie2-build --threads 4 /shared/projects/exonhancer/data/conservation/genome_files/rn7.fa /shared/projects/exonhancer/data/conservation/genome_files/bowtie2_indexes/rnor7/rnor7
    # bowtie2-build --threads 4 /shared/projects/exonhancer/data/conservation/genome_files/mm39.fa /shared/projects/exonhancer/data/conservation/genome_files/bowtie2_indexes/mm39/mm39
    # bowtie2-build --threads 4 /shared/projects/exonhancer/data/conservation/genome_files/Cfam_1.0_ChromNamesCorrect_noUnplacedScaffolds.fasta /shared/projects/exonhancer/data/conservation/genome_files/bowtie2_indexes/cfam1/cfam1

# Reads are 40-45 bp long 

# Reads have been merged in advance:
    # cat do401_Input_liver_none_hsaCRI3_CRI01.fq.gz do401_Input_liver_none_hsaCRI3_CRI01.fq.gz do205_Input_liver_none_hsa1294_CRI01.fq.gz do205_Input_liver_none_hsa1294_CRI02.fq.gz do203_Input_liver_none_hsa1323_CRI01.fq.gz do137_Input_liver_none_hsaHH1308_CRI01.fq.gz > ../hsa_Input_liver.fq.gz

    # cat do404_FoxA1_liver_ab5089_hsaCRI3_CRI01.fq.gz do389_FoxA1_liver_ab5089_hsaHH1294_CRI01.fq.gz > ../hsa_FOXA1_liver.fq.gz
    # cat do199_HNF4a_liver_ARP31046_hsaHH1308_CRI01.fq.gz do199_HNF4a_liver_ARP31046_hsaHH1308_CRI02.fq.gz do505_HNF4a_liver_ARP31046_hsaHH1294_CRI01.fq.gz > ../hsa_HNF4A_liver.fq.gz
    # cat do204_CEBPA_liver_sc9314_hsa1323_CRI01.fq.gz do204_CEBPA_liver_sc9314_hsa1323_CRI02.fq.gz do206_CEBPA_liver_sc9314_hsa1294_CRI01.fq.gz do206_CEBPA_liver_sc9314_hsa1294_CRI02.fq.gz > ../hsa_CEBPA_liver.fq.gz
    # cp do507_HNF6_liver_sc13050_hsaHH1294_CRI01.fq.gz ../hsa_HNF6_liver.fq.gz


    # cat do100_Input_liver_none_cfa4_CRI01.fq.gz do107_Input_liver_none_cfa4_CRI01.fq.gz do261_Input_liver_none_cfa3_CRI01.fq.gz > ../cfa_Input_liver.fq.gz

    # cat do76_HNF4a_liver_ARP31046_cfa4_SAN01.fq.gz do76_HNF4a_liver_ARP31046_cfa4_SAN02.fq.gz do75_HNF4a_liver_ARP31046_cfa3_CRI01.fq.gz do75_HNF4a_liver_ARP31046_cfa3_SAN02.fq.gz do75_HNF4a_liver_ARP31046_cfa3_SAN03.fq.gz > ../cfa_HNF4A_liver.fq.gz
    # cat do61_CEBPA_liver_sc9314_cfa4_CRI01.fq.gz do61_CEBPA_liver_sc9314_cfa4_CRI02.fq.gz do61_CEBPA_liver_sc9314_cfa4_CRI03.fq.gz do79_CEBPA_liver_sc9314_cfa3_CRI01.fq.gz do79_CEBPA_liver_sc9314_cfa3_CRI02.fq.gz do79_CEBPA_liver_sc9314_cfa3_CRI03.fq.gz > ../cfa_CEBPA_liver.fq.gz
    # cat do255_FoxA1_liver_ab5089_cfa4_CRI01.fq.gz do255_FoxA1_liver_ab5089_cfa4_CRI02.fq.gz do318_FoxA1_liver_ab5089_cfa3_CRI01.fq.gz > ../cfa_FOXA1_liver.fq.gz
    # cat do77_HNF6_liver_sc13050_cfa3_CRI02.fq.gz do77_HNF6_liver_sc13050_cfa3_SAN03.fq.gz do77_HNF6_liver_sc13050_cfa3_SAN04.fq.gz > ../cfa_HNF6_liver.fq.gz


    # cat do566_Input_liver_none_mmuOON489_CRI01.fq.gz do851_Input_liver_none_mmuBL60ON562_CRI01.fq.gz > ../mmu_Input_liver.fq.gz

    # cat do560_CEBPA_liver_sc9314_mmuOON489_CRI01.fq.gz do843_CEBPA_liver_sc9314_mmuBL60ON562_CRI01.fq.gz > ../mmu_CEBPA_liver.fq.gz
    # cat do463_FoxA1_liver_ab5089_mmuOON404_CRI01.fq.gz do466_FoxA1_liver_ab5089_mmuOON405_CRI01.fq.gz > ../mmu_FOXA1_liver.fq.gz
    # cat do562_HNF4a_liver_ARP31046_mmuOON489_CRI01.fq.gz do732_HNF4a_liver_ARP31946_mmu0h490+491_CRI01.fq.gz > ../mmu_HNF4A_liver.fq.gz
    # cat do735_HNF6_liver_sc13050_mmu0h490+491_CRI01.fq.gz do798_HNF6_liver_sc13050_mmu12_CRI01.fq.gz > ../mmu_HNF6_liver.fq.gz


    # cat do810_Input_liver_none_rno7_CRI01.fq.gz do811_Input_liver_none_rno8_CRI01.fq.gz > ../rno_Input_liver.fq.gz

    # cat do374_HNF4a_liver_ARP31046_rno5_CRI01.fq.gz do859_HNF4a_liver_ARP31046_rno7_CRI01.fq.gz > ../rno_HNF4A_liver.fq.gz
    # cat do901_FoxA1_liver_ab5089_rno8_CRI02.fq.gz do376_FoxA1_liver_ab5089_rno5_CRI01.fq.gz > ../rno_FOXA1_liver.fq.gz
    # cat do377_CEBPA_liver_sc9314_rno5_CRI01.fq.gz do860_CEBPA_liver_sc9314_rno7_CRI01.fq.gz > ../rno_CEBPA_liver.fq.gz
    # cat do373_HNF6_liver_sc13050_rno5_CRI01.fq.gz do902_HNF6_liver_sc13050_rno8_CRI01.fq.gz > ../rno_HNF6_liver.fq.gz


    # cat do132_Input_liver_none_mmlBlues_CRI01.fq.gz do133_Input_liver_none_mmlBlues_CRI01.fq.gz do133_Input_liver_none_mmlBlues_CRI02.fq.gz do855_Input_liver_none_mmlBob_CRI01.fq.gz > ../mml_Input_liver.fq.gz

    # cat do118_CEBPA_liver_sc9314_mmlBlues_CRI01.fq.gz do149_CEBPA_liver_sc9314_mmlBlues_CRI01.fq.gz do149_CEBPA_liver_sc9314_mmlBlues_CRI02.fq.gz do149_CEBPA_liver_sc9314_mmlBlues_CRI03.fq.gz do149_CEBPA_liver_sc9314_mmlBlues_CRI04.fq.gz > ../mml_CEBPA_liver.fq.gz
    # cat do557_HNF4a_liver_ARP31046_mmlBlues_CRI01.fq.gz do558_HNF4a_liver_ARP31046_mmlBlues_CRI01.fq.gz > ../mml_HNF4A_liver.fq.gz
    # cat do762_HNF6_liver_sc13050_mmlBlues_CRI01.fq.gz do836_HNF6_liver_sc13050_mmlBob_CRI01.fq.gz > ../mml_HNF6_liver.fq.gz
    # cp do474_FoxA1_liver_ab5089_mmlBlues_CRI01.fq.gz ../mml_FOXA1_liver.fq.gz

# Reads quality control :
    # fastqc -o ../fastqc *.fq.gz
    # multiqc ./fastqc -o ./multiqc
    # Read the report to choose trim and filter parameters (if needed) 

import os

FASTQ_FILES = [f for f in os.listdir("/shared/projects/exonhancer/data/conservation/elife_ballester_reads") if f.endswith(".fq.gz")]
FASTQ_FILES_CONTROL = [f for f in FASTQ_FILES if "Input" in f]
FASTQ_FILES_TREATED = [f for f in FASTQ_FILES if f not in FASTQ_FILES_CONTROL]

rule all:
    input: 
        expand("/shared/projects/exonhancer/data/conservation/elife_ballester_reads_qc/{sample}_qc.fq.gz", sample=[f.replace(".fq.gz", "") for f in FASTQ_FILES]),
        expand("/shared/projects/exonhancer/data/conservation/bowtie_output/{sample}.bam", sample=[f.replace(".fq.gz", "") for f in FASTQ_FILES]),
        expand("/shared/projects/exonhancer/data/conservation/bowtie_output/{sample_treated}_sorted_filtered.bam", sample_treated=[f.replace(".fq.gz", "") for f in FASTQ_FILES_TREATED]),
        expand("/shared/projects/exonhancer/data/conservation/bowtie_output/control/{control}_sorted_filtered.bam", control=[f.replace(".fq.gz", "") for f in FASTQ_FILES_CONTROL]),
        expand("/shared/projects/exonhancer/data/conservation/macs2_output/{sample_treated}_peaks.narrowPeak", sample_treated=[f.replace(".fq.gz", "") for f in FASTQ_FILES_TREATED]),

#Based on the multiqc results, we cut reads at the 36th base pair, then we cut bases at the tail until a base quality of 25 is reached. We discard reads with an average quality less than 20.
rule quality_control_reads:
    resources:
        partition="fast",
        runtime=1440,
        mem_mb=100000
    input:
        fastq="/shared/projects/exonhancer/data/conservation/elife_ballester_reads/{sample}.fq.gz"
    output:
        reads_qc="/shared/projects/exonhancer/data/conservation/elife_ballester_reads_qc/{sample}_qc.fq.gz"
    shell:
        """
        fastp -i {input.fastq} -o {output.reads_qc} --thread 4 --max_len1 36 --cut_tail --cut_tail_mean_quality 25 --average_qual 20
        """

#Reads are unpaired so -U. We would need --local if we don't trim the reads to allow soft-clipping. 
rule alignment:
    resources:
        partition="fast",
        runtime=1440,
        mem_mb=100000
    input:
        fastq="/shared/projects/exonhancer/data/conservation/elife_ballester_reads_qc/{sample}_qc.fq.gz"
    output:
        bam="/shared/projects/exonhancer/data/conservation/bowtie_output/{sample}.bam",
        log="/shared/projects/exonhancer/data/conservation/bowtie_output/alignment_logs/{sample}.log"
    params:
        indexes_path="/shared/projects/exonhancer/data/conservation/genome_files/bowtie2_indexes"
    shell:
        """
        if [ ! -d "/shared/projects/exonhancer/data/conservation/bowtie_output" ]; then
            mkdir -p "/shared/projects/exonhancer/data/conservation/bowtie_output"
            mkdir -p "/shared/projects/exonhancer/data/conservation/bowtie_output/alignment_logs"
        fi

        pattern=$(cut -d_ -f1 <<< "{wildcards.sample}")
        if [[ "hsa" =~ $pattern ]]; then
            bowtie2 -p 8 -q -x {params.indexes_path}/hg38/hg38 -U {input.fastq} -S /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam 2> {output.log}
            samtools view -h -S -b -o {output.bam} /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam
            rm /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam

        elif [[ "mmu" =~ $pattern ]]; then
            bowtie2 -p 8 -q -x {params.indexes_path}/mm39/mm39 -U {input.fastq} -S /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam 2> {output.log}
            samtools view -h -S -b -o {output.bam} /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam
            rm /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam

        elif [[ "mml" =~ $pattern ]]; then
            bowtie2 -p 8 -q -x {params.indexes_path}/mml10/mml10 -U {input.fastq} -S /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam 2> {output.log}
            samtools view -h -S -b -o {output.bam} /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam
            rm /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam

        elif [[ "cfa" =~ $pattern ]]; then
            bowtie2 -p 8 -q -x {params.indexes_path}/cfam1/cfam1 -U {input.fastq} -S /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam 2> {output.log}
            samtools view -h -S -b -o {output.bam} /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam
            rm /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam

        elif [[ "rno" =~ $pattern ]]; then
            bowtie2 -p 8 -q -x {params.indexes_path}/rnor7/rnor7 -U {input.fastq} -S /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam 2> {output.log}
            samtools view -h -S -b -o {output.bam} /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam
            rm /shared/projects/exonhancer/data/conservation/bowtie_output/{wildcards.sample}.sam
        fi
        """

#https://github.com/biod/sambamba/wiki/%5Bsambamba-view%5D-Filter-expression-syntax
# We filter out unmapped reads by specifying in the filter not unmapped, and duplicates with not duplicate.
# Also, among the reads that are aligned, we filter out multimappers by specifying [XS] == null.
# XS is a tag generated by Bowtie2 that gives an alignment score for the second-best alignment, and it is only present if the read is aligned and more than one alignment is found for the read.
# ! Always remove multimapping reads for Chip-seq data !
rule sort_filter_bam: 
    resources:
        partition="fast",
        runtime=1440,
        mem_mb=100000
    input:
        bam="/shared/projects/exonhancer/data/conservation/bowtie_output/{sample}.bam"
    output:
        bam_filtered="/shared/projects/exonhancer/data/conservation/bowtie_output/{sample}_sorted_filtered.bam"
    shell:
        """
        samtools sort {input.bam} -o {wildcards.sample}_sorted.bam
        sambamba view -h -t 8 -f bam -F "[XS] == null and not unmapped and not duplicate" {wildcards.sample}_sorted.bam > {output.bam_filtered}
        rm {wildcards.sample}_sorted.bam
        """

rule move_control: 
    resources:
        partition="fast",
        runtime=1440,
        mem_mb=100000
    input:
        bam_filtered="/shared/projects/exonhancer/data/conservation/bowtie_output/{control}_sorted_filtered.bam"
    output:
        bam_control="/shared/projects/exonhancer/data/conservation/bowtie_output/control/{control}_sorted_filtered.bam"
    shell:
        """
        if [ ! -d "/shared/projects/exonhancer/data/conservation/bowtie_output/control" ]; then
            mkdir -p "/shared/projects/exonhancer/data/conservation/bowtie_output/control"
        fi

        pattern=$(cut -d_ -f2 <<< "{wildcards.control}")
        if [[ "Input" =~ $pattern ]]; then
            mv {input.bam_filtered} {output.bam_control}
        fi
        """

# -g is the effective genome size of species. MACS2 has the size for only 4 species, we have to tell the size for the species we don't have: It can be 1.0e+9 or 1000000000
# Effective genome size is mappability, look at file "genome_mappability.sh" for more information. Multimapped reads are discarded so we use the second method (kmers) for gene mappability.
# -k ->  k-mer size to use. It corresponds here to the reads length (on the deeptools page)
# unique-kmers.py -k 36 rn7.fa # 2294466248
# unique-kmers.py -k 36 rheMac10.fa # 2583925190
# unique-kmers.py -k 36 Cfam_1.0_ChromNamesCorrect_noUnplacedScaffolds.fasta # 2208273981
# unique-kmers.py -k 36 mm39.fa # 2229727300
# unique-kmers.py -k 36 hg38.fa # 2564553930

rule peak_calling: 
    resources:
        partition="fast",
        runtime=1440,
        mem_mb=100000
    input: #Make sure all control have been generated before peak calling 
        control_hsa="/shared/projects/exonhancer/data/conservation/bowtie_output/control/hsa_Input_liver_sorted_filtered.bam",
        control_mmu="/shared/projects/exonhancer/data/conservation/bowtie_output/control/mmu_Input_liver_sorted_filtered.bam",
        control_mml="/shared/projects/exonhancer/data/conservation/bowtie_output/control/mml_Input_liver_sorted_filtered.bam",
        control_cfa="/shared/projects/exonhancer/data/conservation/bowtie_output/control/cfa_Input_liver_sorted_filtered.bam",
        control_rno="/shared/projects/exonhancer/data/conservation/bowtie_output/control/rno_Input_liver_sorted_filtered.bam",
        bam_filtered="/shared/projects/exonhancer/data/conservation/bowtie_output/{sample_treated}_sorted_filtered.bam"
    output:
        sample_peak="/shared/projects/exonhancer/data/conservation/macs2_output/{sample_treated}_peaks.narrowPeak",
        log="/shared/projects/exonhancer/data/conservation/macs2_output/peak_calling_logs/{sample_treated}.log"
    params:
        output_path="/shared/projects/exonhancer/data/conservation/macs2_output",
    shell:
        """
        if [ ! -d "{params.output_path}" ]; then
            mkdir -p "{params.output_path}"
            mkdir -p "{params.output_path}/peak_calling_logs"
        fi

        pattern=$(cut -d_ -f1 <<< "{wildcards.sample_treated}")
        if [[ "hsa" =~ $pattern ]]; then
            macs2 callpeak -t {input.bam_filtered} -c {input.control_hsa} -f BAM -g 2564553930 -n {wildcards.sample_treated} --outdir {params.output_path} 2> {output.log}

        elif [[ "mmu" =~ $pattern ]]; then
            macs2 callpeak -t {input.bam_filtered} -c {input.control_mmu} -f BAM -g 2229727300 -n {wildcards.sample_treated} --outdir {params.output_path} 2> {output.log}

        elif [[ "mml" =~ $pattern ]]; then
            macs2 callpeak -t {input.bam_filtered} -c {input.control_mml} -f BAM -g 2583925190 -n {wildcards.sample_treated} --outdir {params.output_path} 2> {output.log}

        elif [[ "cfa" =~ $pattern ]]; then
            macs2 callpeak -t {input.bam_filtered} -c {input.control_cfa} -f BAM -g 2208273981 -n {wildcards.sample_treated} --outdir {params.output_path} 2> {output.log}

        elif [[ "rno" =~ $pattern ]]; then
            macs2 callpeak -t {input.bam_filtered} -c {input.control_rno} -f BAM -g 2294466248 -n {wildcards.sample_treated} --outdir {params.output_path} 2> {output.log}
        fi
        """