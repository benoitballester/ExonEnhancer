#!/bin/bash

### DM6
#Get ncbiRefSeq gtf from ucsc link and full fasta genome from ucsc table browser (choose assembly and sequence)
http://hgdownload.soe.ucsc.edu/goldenPath/dm6/bigZips/genes/dm6.ncbiRefSeq.gtf.gz

#Treat gtf file to add the required fields for the geno2proteo script
awk -F'\t' '{
  # Use regex to find transcript_id within the 9th field
  match($9, /transcript_id "([^"]+)"/, arr);
  
  # If a transcript_id was found, construct protein_id string
  if (arr[1] != "") {
    protein = " protein_id \"prot-" arr[1] "\"; ";
  } else {
    protein = "";
  }
  
  # Prepend the new protein_id attribute to the existing 9th column content
  $9 = $9 protein;
  
  # Print the modified line
  print;
}' OFS='\t' dm6.ncbiRefSeq.gtf > dm6.ncbiRefSeq_idprot.gtf

#treat fasta file to only keep the chromosome for the name of sequences (e.g >aseembly_aa range=chr4:1:30000   -> >chr4)
sed -E 's/^>.*range=(chr[^:]*).*/>\1/' dm6_bdgp6_dm6.fa > dm6_bdgp6_dm6_curated.fa

gzip dm6.ncbiRefSeq_idprot.gtf
gzip dm6_bdgp6_dm6_curated.fa

### MM39
#ensembl 110 (gencode vm33)
https://ftp.ensembl.org/pub/release-110/gtf/mus_musculus/Mus_musculus.GRCm39.110.gtf.gz
https://ftp.ensembl.org/pub/release-110/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz


### ATHALIANA
#gtf from ensembl
https://ftp.ebi.ac.uk/ensemblgenomes/pub/release-44/plants/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.44.gtf.gz

#get fasta sequence of genome from ensemble since used gtf is ensembl one too 
https://ftp.ebi.ac.uk/ensemblgenomes/pub/release-44/plants/fasta/arabidopsis_thaliana/dna/
#concatenate fastas into one


### HSAP
gtf and fasta from ensembl 107 (corresponds to gencode 41)