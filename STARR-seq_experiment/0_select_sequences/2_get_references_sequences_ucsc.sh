#!/bin/bash

### 1 : get the 3144 references sequences from UCSC 

#upload the file on UCSC, then go the table browser, select the track and "sequence" type of output, it will gives the fasta of the coordiantes

### 2 : divide sequences

cat K562_coords_GoodSizes.fasta K562_coords_TrimmedSizes.fasta >> K562_REF_sequences.fasta
cat A549_GM12878_Uniques_coords_TrimmedSizes.fasta A549_GM12878_Uniques_coords_GoodSizes.fasta >> A549_GM12878_REF_sequences.fasta