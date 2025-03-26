library("LOLA")
library("GenomicRanges")
library("rtracklayer")
library("simpleCache")

#unloadNamespace("LOLA")

regionDB = loadRegionDB("/shared/projects/exonhancer/data/LOLA/tf_catalogs/tf_nr_tair10")

userUniverse = import("/shared/projects/exonhancer/data/LOLA/universe/tair10_nochr_proms_ee.bed")

userSets = import("/shared/projects/exonhancer/data/species_ee_coords/tair10_EE_nochr_coords.bed")

locResults = runLOLA(userSets, userUniverse, regionDB, cores=30)

#colnames(locResults)
#head(locResults)

## -----------------------------------------------------------------------------
locResults[order(support, decreasing=TRUE),]
locResults[order(maxRnk, decreasing=TRUE),]

## ----Write results------------------------------------------------------------
writeCombinedEnrichment(locResults, outFolder= "/shared/projects/exonhancer/data/LOLA/results/")


#awk '{print $1,$2,$3}' OFS=$'\t' Hs_EPDnew_006_hg38.bed > hg38_proms
#cat ../../species_ee_coords/hg38_EE_coords.bed hg38_proms |sort -k1,1 -k2,2n > ../universe/hg38_proms_ee.bed