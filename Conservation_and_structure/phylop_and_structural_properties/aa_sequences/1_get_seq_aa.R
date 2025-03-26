#install.packages("geno2proteo")
library("geno2proteo")
library(stringr)

### check for directories and paths
library(rstudioapi)
get_script_path <- function() {
  # 1) If we're in RStudio, try using rstudioapi
  if (requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::isAvailable()) {
    path <- rstudioapi::getActiveDocumentContext()$path
    if (nzchar(path)) {
      return(normalizePath(path))
    }
  }
  # 2) If we're running via Rscript, check command line args
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg) > 0) {
    return(normalizePath(sub("^--file=", "", file_arg)))
  }
  # 3) Otherwise (e.g., sourced interactively), no reliable script path
  return(NULL)
}
script_path <- get_script_path()
if (!is.null(script_path)) {
  script_dir <- dirname(script_path)
  cat("This script is located in:\n", script_dir, "\n")
  
  # List all files in that directory
  all_files <- list.files(script_dir)
  cat("Files in that directory:\n")
  print(all_files)
} else {
  cat("Could not determine script file path.\n")
}
file.exists("/shared/projects/exonhancer/repoexonhancer/structure_prot/aa_sequences/getDNAseqsFromGenome_loci.perl")
###

### Custom functions to adapt to thaliana and drosophilia
generatingCDSaaFile <- function(geneticCodeFile_line, gtfFile, DNAfastaFile, 
                                outputFolder='./', perlExec='perl') {
  
  scriptFolder= system.file("exec", package="geno2proteo")
  # the perl script used to get the DNA for the CDS from the fasta file.
  perlScript_getDNAseq=file.path("/shared/projects/exonhancer/repoexonhancer/structure_prot/aa_sequences/getDNAseqsFromGenome_loci.perl")
  # the perl script for translating a DNA sequence into a AA sequence, 
  # using the genetic codes provided.
  perlScript_getAAseq=file.path(scriptFolder, "DNAseqTranslation_CDS.perl") 
  filenamePrefix = sub('.*/', '', gtfFile)
  # read the CDS information from the GTF file 
  kk21 = read.table(gtfFile, sep='\t', stringsAsFactors=FALSE)
  
  ### DEFINE OWN CHROMOSOMES 
  #kk = c(1:22, 'X', 'Y', 'MT') #ORIGINAL
  #kk = c("chr3R","chr3L","chr2L","chr2R","chr4","chrX","chrY","chrM") #DM
  kk = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY") #HSAP
  #kk = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY") #MMUS
  #kk = c("1","2","3","4","5","Cp","Mt") #Athaliana
  
  ###
  
  kk = kk21[,1] %in% kk
  kk21 = kk21[kk,]
  kk = kk21[,3] =='CDS' # CDS are those coding regions
  kk22 = kk21[kk,]
  kkt = kk22[,9]
  # get all the transcript ids
  kk = sub('.*transcript_id ', '',kkt); kk=sub(';.*', '', kk)

  # for each transcipt, get all its CDS (indexes of them)
  kk9991 = tapply(1:length(kk), kk, sort ) 

  # get all the protein ids
  kkt1 = sub('.*protein_id ', '',kkt); kkt1=sub(';.*', '', kkt1)
  
  # get all the protein ids
  kkt2 = sub('.*gene_name ', '',kkt); kkt2=sub(';.*', '', kkt2)
  
  pIDgene = cbind(proteinId=kkt1, geneName=kkt2)

  rownames(pIDgene) = kk

  #### get the genomic position information of each CDS, and frame for 
  # protein translation
  kk9992 = kk22[,c(1, 4,5, 7, 8)] 

  kk9993 = lapply(kk9991, function(a) kk9992[a,] )
  
  # order the CDS of each transcript by their start
  kk9994 = lapply(kk9993, function(a) a[order(a[,2]),] )

  kk99941 = lapply(kk9994, as.matrix)

  kk = names(kk99941)
  
  kk9995 = lapply(1:length(kk), function(n) {
    kkt=kk99941[[n]]; kkt1=1:nrow(kkt); 
    if(kkt[1,4]=='-') kkt1=rev(kkt1); 
    cbind(paste(kk[n], kkt1, sep='_'), kkt) 
  } )
  
  
  kk99951 = lapply(kk9995, t)
  kk = unlist(kk99951)
  kk = t(matrix(kk, nrow=6))
  
  # the 6th column is for the frame of translation
  kk9996 = kk[,c(2:5, 1, 6)] #reorder the column
  
  #######
  #kk = strsplit(kk9996[,5], split='_') #original
  #kk <- str_split_fixed(kk9996[,5], "_(?=[^_]*$)", 2)
  kk <- strsplit(kk9996[,5], split = "_(?=[^_]*$)", perl = TRUE)
  #######

  kk = t(matrix(unlist(kk), nrow=2))
 
  # matrix containing the ordered CDS for each transcript
  kk9996 = cbind(kk9996[,1:4], kk, kk9996[,6]) 

  ## get a proper bed format
  #kk9996 = kk9996[,c(1:3, 5:6, 4, 7)] # now using the
  
  #kk9996[,2] = as.numeric(kk9996[,2])
  
  filenameAllCDS = paste(outputFolder, '/', filenamePrefix, 
                         '_CDS_transcript.txt', sep='');
  
  write.table(kk9996, file=filenameAllCDS, sep='\t', 
              quote=FALSE, row.names=FALSE, col.names=FALSE)
  
  # then run the perl script to get the DNA sequence of the CDS regions
  
  filenameAllCDSdnaSeq = paste(outputFolder, '/', 
                               filenamePrefix, '_CDS_transcript_DNAseq.txt', sep='');
  DNAfastaFile00 = DNAfastaFile
  # uncompress the fasta file, not remove the compressed
  if(grepl('\\.gz$', DNAfastaFile)[1]) { 
    #R.utils::gunzip(DNAfastaFile, remove=FALSE)
    #DNAfastaFile = sub('\\.gz$','', DNAfastaFile)
    destName=paste(outputFolder, '/', 
                   sub('.gz$', '', sub('.*\\/', '', DNAfastaFile)), sep='')
    R.utils::decompressFile(filename=DNAfastaFile, destname=destName, 
                            ext='gz', FUN=gzfile, remove=FALSE)
    DNAfastaFile = destName;
    
  }
  # using the double quotation to address the problem associate with blank
  # spaces in the command.
  command = paste('"', perlExec, '" "', perlScript_getDNAseq, '" "', 
                  filenameAllCDS, '" "', DNAfastaFile, '" "', 
                  filenameAllCDSdnaSeq, '"', sep='')
  
  system(command)
  
  if(grepl('\\.gz$', DNAfastaFile00)[1]) { # if uncompressed the fasta file 
    if (file.exists(DNAfastaFile)) { 
      invisible(file.remove(DNAfastaFile)) 
    }
    DNAfastaFile= DNAfastaFile00
  }
  
  # then run the perl script to get the AA sequences from the DNA sequence 
  # of a transcipts from its CDS.
  
  filenameAllCDSdnaSeqAA = paste(outputFolder, '/', 
                                 filenamePrefix, '_AAseq.txt', sep='');
  
  command = paste('"', perlExec, '" "', perlScript_getAAseq, '" "', 
                  filenameAllCDSdnaSeq, '" "', geneticCodeFile_line, '" "', 
                  filenameAllCDSdnaSeqAA, '"', sep='')
  
  system(command)
  
  resultsNow = read.table(filenameAllCDSdnaSeqAA, stringsAsFactors=FALSE,
                          sep='\t')
  
  kk = pIDgene[resultsNow[,5],]
  rownames(kk) = NULL
  
  # append the protein ID and gene symbol to the table.
  resultsNow = cbind(resultsNow, kk) 
  
  write.table(resultsNow, file=filenameAllCDSdnaSeqAA, sep='\t', 
              row.names=FALSE, col.names=FALSE, quote=FALSE)
  
  R.utils::gzip(filenameAllCDSdnaSeqAA, overwrite=TRUE) # compress the file
  
  if (file.exists(filenameAllCDSdnaSeq)) { 
    invisible(file.remove(filenameAllCDSdnaSeq)) 
  }
  
  if ( file.exists(filenameAllCDS) ) { 
    invisible(file.remove(filenameAllCDS)) 
  }
}


generatingCDSaaFile_RAW <- function(geneticCodeFile_line, gtfFile, DNAfastaFile, 
                                outputFolder='./', perlExec='perl') {
  
  scriptFolder= system.file("exec", package="geno2proteo")
  # the perl script used to get the DNA for the CDS from the fasta file.
  perlScript_getDNAseq=file.path(scriptFolder, 
                                 "getDNAseqsFromGenome_loci.perl")
  # the perl script for translating a DNA sequence into a AA sequence, 
  # using the genetic codes provided.
  perlScript_getAAseq=file.path(scriptFolder, "DNAseqTranslation_CDS.perl") 
  filenamePrefix = sub('.*/', '', gtfFile)
  # read the CDS information from the GTF file 
  kk21 = read.table(gtfFile, sep='\t', stringsAsFactors=FALSE)
  kk = c(1:22, 'X', 'Y', 'MT')
  kk = kk21[,1] %in% kk
  kk21 = kk21[kk,]
  kk = kk21[,3] =='CDS' # CDS are those coding regions
  kk22 = kk21[kk,]
  kkt = kk22[,9]
  # get all the transcript ids
  kk = sub('.*transcript_id ', '',kkt); kk=sub(';.*', '', kk)
  # for each transcipt, get all its CDS (indexes of them)
  kk9991 = tapply(1:length(kk), kk, sort ) 
  
  # get all the protein ids
  kkt1 = sub('.*protein_id ', '',kkt); kkt1=sub(';.*', '', kkt1)
  # get all the protein ids
  kkt2 = sub('.*gene_name ', '',kkt); kkt2=sub(';.*', '', kkt2)
  
  pIDgene = cbind(proteinId=kkt1, geneName=kkt2)
  rownames(pIDgene) = kk
  # get the genomic position information of each CDS, and frame for 
  # protein translation
  kk9992 = kk22[,c(1, 4,5, 7, 8)] 
  kk9993 = lapply(kk9991, function(a) kk9992[a,] )
  # order the CDS of each transcript by their start
  kk9994 = lapply(kk9993, function(a) a[order(a[,2]),] )
  
  kk99941 = lapply(kk9994, as.matrix)
  
  kk = names(kk99941)
  
  kk9995 = lapply(1:length(kk), function(n) {
    kkt=kk99941[[n]]; kkt1=1:nrow(kkt); 
    if(kkt[1,4]=='-') kkt1=rev(kkt1); 
    cbind(paste(kk[n], kkt1, sep='_'), kkt) 
  } )
  
  kk99951 = lapply(kk9995, t)
  kk = unlist(kk99951)
  kk = t(matrix(kk, nrow=6))
  
  # the 6th column is for the frame of translation
  kk9996 = kk[,c(2:5, 1, 6)] 
  
  kk = strsplit(kk9996[,5], split='_')
  
  kk = t(matrix(unlist(kk), nrow=2))
  
  # matrix containing the ordered CDS for each transcript
  kk9996 = cbind(kk9996[,1:4], kk, kk9996[,6]) 
  
  ## get a proper bed format
  #kk9996 = kk9996[,c(1:3, 5:6, 4, 7)] # now using the
  
  #kk9996[,2] = as.numeric(kk9996[,2])
  
  filenameAllCDS = paste(outputFolder, '/', filenamePrefix, 
                         '_CDS_transcript.txt', sep='');
  
  write.table(kk9996, file=filenameAllCDS, sep='\t', 
              quote=FALSE, row.names=FALSE, col.names=FALSE)
  
  # then run the perl script to get the DNA sequence of the CDS regions
  
  filenameAllCDSdnaSeq = paste(outputFolder, '/', 
                               filenamePrefix, '_CDS_transcript_DNAseq.txt', sep='');
  DNAfastaFile00 = DNAfastaFile
  # uncompress the fasta file, not remove the compressed
  if(grepl('\\.gz$', DNAfastaFile)[1]) { 
    #R.utils::gunzip(DNAfastaFile, remove=FALSE)
    #DNAfastaFile = sub('\\.gz$','', DNAfastaFile)
    destName=paste(outputFolder, '/', 
                   sub('.gz$', '', sub('.*\\/', '', DNAfastaFile)), sep='')
    R.utils::decompressFile(filename=DNAfastaFile, destname=destName, 
                            ext='gz', FUN=gzfile, remove=FALSE)
    DNAfastaFile = destName;
    
  }
  # using the double quotation to address the problem associate with blank
  # spaces in the command.
  command = paste('"', perlExec, '" "', perlScript_getDNAseq, '" "', 
                  filenameAllCDS, '" "', DNAfastaFile, '" "', 
                  filenameAllCDSdnaSeq, '"', sep='')
  
  system(command)
  
  if(grepl('\\.gz$', DNAfastaFile00)[1]) { # if uncompressed the fasta file 
    if (file.exists(DNAfastaFile)) { 
      invisible(file.remove(DNAfastaFile)) 
    }
    DNAfastaFile= DNAfastaFile00
  }
  
  # then run the perl script to get the AA sequences from the DNA sequence 
  # of a transcipts from its CDS.
  
  filenameAllCDSdnaSeqAA = paste(outputFolder, '/', 
                                 filenamePrefix, '_AAseq.txt', sep='');
  
  command = paste('"', perlExec, '" "', perlScript_getAAseq, '" "', 
                  filenameAllCDSdnaSeq, '" "', geneticCodeFile_line, '" "', 
                  filenameAllCDSdnaSeqAA, '"', sep='')
  
  system(command)
  
  resultsNow = read.table(filenameAllCDSdnaSeqAA, stringsAsFactors=FALSE,
                          sep='\t')
  
  kk = pIDgene[resultsNow[,5],]
  rownames(kk) = NULL
  
  # append the protein ID and gene symbol to the table.
  resultsNow = cbind(resultsNow, kk) 
  
  write.table(resultsNow, file=filenameAllCDSdnaSeqAA, sep='\t', 
              row.names=FALSE, col.names=FALSE, quote=FALSE)
  
  R.utils::gzip(filenameAllCDSdnaSeqAA, overwrite=TRUE) # compress the file
  
  if (file.exists(filenameAllCDSdnaSeq)) { 
    invisible(file.remove(filenameAllCDSdnaSeq)) 
  }
  
  if ( file.exists(filenameAllCDS) ) { 
    invisible(file.remove(filenameAllCDS)) 
  }
}

### 

### Generate CDS_aa file first
gtfFile = file.path("/shared/projects/exonhancer/data/aa_seq/files/Mus_musculus.GRCm39.110.gtf.gz");
DNAfastaFile = file.path("/shared/projects/exonhancer/data/aa_seq/files/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz");

dataFolder = system.file("extdata", package="geno2proteo");
geneticCodeFile = file.path(dataFolder, "geneticCode_standardTable_lines.txt");

#Used for Dmel and Thaliana
generatingCDSaaFile(geneticCodeFile_line=geneticCodeFile, gtfFile=gtfFile, DNAfastaFile=DNAfastaFile, outputFolder="/shared/projects/exonhancer/data/aa_seq/tool_CDSaa_files", perlExec="perl")

#Used for Hsap and Mmus
generatingCDSaaFile_RAW(geneticCodeFile_line=geneticCodeFile, gtfFile=gtfFile, DNAfastaFile=DNAfastaFile, outputFolder="/shared/projects/exonhancer/data/aa_seq/tool_CDSaa_files", perlExec="perl")


#####################

### Get AA seq for DNA coords 
CDSaaFile=file.path("/shared/projects/exonhancer/data/aa_seq/tool_CDSaa_files/Mus_musculus.GRCm39.110.gtf.gz_AAseq.txt.gz")

inputFile_loci_ee=file.path("/shared/projects/exonhancer/data/aa_seq/coords/mm39_ee")
inputFile_loci_neg=file.path("/shared/projects/exonhancer/data/aa_seq/coords/mm39_neg")

inputLoci_ee = read.table(inputFile_loci_ee, sep='\t', stringsAsFactors=FALSE, header=TRUE)
inputLoci_ee = inputLoci_ee[,1:5]
inputLoci_neg = read.table(inputFile_loci_neg, sep='\t', stringsAsFactors=FALSE, header=TRUE)
inputLoci_neg = inputLoci_neg[,1:5]

proteinSeq_ee = genomicLocsToProteinSequence(inputLoci=inputLoci_ee, CDSaaFile=CDSaaFile)
proteinSeq_neg = genomicLocsToProteinSequence(inputLoci=inputLoci_neg, CDSaaFile=CDSaaFile)

write.table(proteinSeq_ee, "/shared/projects/exonhancer/data/aa_seq/results/mm39_ee_aa_seq.tsv", sep = "\t", row.names = FALSE,quote = FALSE)
write.table(proteinSeq_neg, "/shared/projects/exonhancer/data/aa_seq/results/mm39_neg_aa_seq.tsv", sep = "\t", row.names = FALSE,quote = FALSE)

#proteinSeq_ee[c(0,9),]