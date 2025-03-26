## Translate UUIDs >> TCGA Barcode

# https://rdrr.io/github/waldronlab/TCGAutils/man/ID-translation.html

library("waldronlab/TCGAutils")


file_path <- '/home/mouren/Data/variants/tcga_MC3/normal_barcodes/allTCGA_GeneCounts_fileID.txt'
values <- readLines(file_path)
uuids <- c(values)

var1 <- UUIDtoBarcode(uuids, from_type = "file_id")

write.table(var1, file = "/home/mouren/Data/variants/tcga_MC3/normal_barcodes/all_UUID_TAGCBarcodes_dic.tsv", row.names = FALSE, col.names = FALSE, quote = FALSE, sep = "\t")

#ex
#uuids <- c("7a9de79e-7eaf-41f3-b7fd-bd59cbf64443")
#UUIDtoBarcode("ae55b2d3-62a1-419e-9f9a-5ddfac356db4", from_type = "case_id")
#UUIDtoBarcode("d85d8a17-8aea-49d3-8a03-8f13141c163b", "aliquot_ids")