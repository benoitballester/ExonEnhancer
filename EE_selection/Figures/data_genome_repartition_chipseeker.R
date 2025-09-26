library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(TxDb.Mmusculus.UCSC.mm39.refGene)
library(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
library(TxDb.Athaliana.BioMart.plantsmart51)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("TxDb.Dmelanogaster.UCSC.dm6.ensGene")

options(ChIPseeker.ignore_1st_exon = TRUE)
options(ChIPseeker.ignore_1st_intron = TRUE) 
options(ChIPseeker.ignore_downstream = TRUE)
options(ChIPseeker.ignore_promoter_subcategory = TRUE)

txdb_hg <- TxDb.Hsapiens.UCSC.hg38.knownGene
txdb_mm <- TxDb.Mmusculus.UCSC.mm39.refGene
txdb_dm <- TxDb.Dmelanogaster.UCSC.dm6.ensGene
txdb_tair <- TxDb.Athaliana.BioMart.plantsmart51

### Files used were
#ReMap2022 non-redundant summits peaks 
#dm6 ChipAtlas DNAse
#hg38 Meuleman DNAse
#TAIR10 PlantRegMap DNAse
#mm39 ENCODE DNAse

hg_nr <-  readPeakFile("/home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/hg_summit.bed", header=FALSE)
annot_hg_nr <- annotatePeak(hg_nr, tssRegion = c(-500,500), TxDb=txdb_hg)
plotAnnoPie(annot_hg_nr)

mm_nr <-  readPeakFile("/home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/mm_summit.bed", header=FALSE)
annot_mm_nr <- annotatePeak(mm_nr, tssRegion = c(-500,500), TxDb=txdb_mm)
plotAnnoPie(annot_mm_nr)

dm_nr <-  readPeakFile("/home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/dmel_summit.bed", header=FALSE)
annot_dm_nr <- annotatePeak(dm_nr, tssRegion = c(-500,500), TxDb=txdb_dm)
plotAnnoPie(annot_dm_nr)

dm_nr <-  readPeakFile("/shared/projects/exonhancer/data/revisions/permut_test/dnase/data/dm6_DNase_ChipAtlas_simplified.bed", header=FALSE)
annot_dm_nr <- annotatePeak(dm_nr, tssRegion = c(-500,500), TxDb=txdb_dm)
plotAnnoPie(annot_dm_nr)

tair_nr <-  readPeakFile("/home/mouren/Data/final_files_tokeep/raw_important/remap/nr_summit_switched/tair_summit.bed", header=FALSE)
annot_tair_nr <- annotatePeak(tair_nr, tssRegion = c(-500,500), TxDb=txdb_tair)
plotAnnoPie(annot_tair_nr)


