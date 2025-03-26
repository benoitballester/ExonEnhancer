#!/bin/bash

# Prior to this script, split positive controls and all coding exons per chromosome in chr_regions folders
input_file="vcf_links.txt"


#do the same for all coding exons below

while IFS= read -r line; do
    wget $line
    if [[ $line == *".tbi" ]]; then
        filename=$(basename "$line")
        base_filename="${filename%.tbi}"  # Remove the trailing ".tbi" extension
        chr=$(echo "$filename" |grep -oE 'chr[0-9]+|chrX|chrY')

        tabix -R /home/mouren/Data/variants/gnomad/v3.1.2/enhd/chr_regions/$chr $base_filename > tmp.vcf
        rm $filename $base_filename
        sort -k 1,1 -k 2,2n --parallel=8 tmp.vcf |uniq > /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/${chr}.vcf
        rm tmp.vcf
        bgzip --threads 10 /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/${chr}.vcf
    fi

done < "$input_file"

cat /home/mouren/Data/variants/gnomad/v3.1.2/enhd/allVariants_enhD.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr1.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr2.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr3.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr4.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr5.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr6.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr7.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr8.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr9.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr10.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr11.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr12.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr13.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr14.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr15.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr16.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr17.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr18.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr19.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr20.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr21.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chr22.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chrX.vcf.gz /home/mouren/Data/variants/gnomad/v3.1.2/enhd/vcf_by_chr/chrY.vcf.gz
tabix -p vcf /home/mouren/Data/variants/gnomad/v3.1.2/enhd/allVariants_enhD.vcf.gz  