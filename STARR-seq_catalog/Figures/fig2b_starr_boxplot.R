setwd("/shared/home/bballester/2.exons/starrseq-boxplot")

df = read.table("STARR-seq_catalogs_bilan - active_peaks.tsv",  sep ="\t", header=TRUE)

# Replace commas with dots and convert to numeric in 'Percentage_EE_overlapped'
df$Percentage_EE_overlapped <- as.numeric(gsub(",", ".", df$Percentage_EE_overlapped))


df_hsap = df[df$Species == "H.sapiens", ]
df_mmus = df[df$Species == "M.musculus", ]
df_dmel = df[df$Species == "D.melanogaster", ]
df_atha = df[df$Species == "A.thaliana", ]



##################
# Nb of peaks

pdf("STARR-seq_catalogs_nb_peaks2.pdf", width=3, height=5)
boxplot(df$Nb_peaks, col = "white", 
        ylab="Nb peaks",
        las=2,
        log="y")
stripchart(df_hsap$Nb_peaks,
           method = "jitter", jitter = 0.2,
           pch = 19,          # Pch symbols
           col = "red",           # Color of the symbol
           vertical = TRUE  ,  # Vertical mode
           add = TRUE,
           las=2,
           log="y"
)        # Add it over
stripchart(df_mmus$Nb_peaks,
           method = "jitter", jitter = 0.2,
           pch = 19,          # Pch symbols
           col = "grey",           # Color of the symbol
           vertical = TRUE,   # Vertical mode
           log="y",
           add = TRUE)        # Add it over
stripchart(df_dmel$Nb_peaks,
           method = "jitter", jitter = 0.2,
           pch = 19,          # Pch symbols
           col = "orange",           # Color of the symbol
           vertical = TRUE,   # Vertical mode
           log="y",
           add = TRUE)        # Add it over
stripchart(df_atha$Nb_peaks,
           method = "jitter", jitter = 0.2,
           pch = 19,          # Pch symbols
           col = "green",           # Color of the symbol
           vertical = TRUE,   # Vertical mode
           log="y",
           add = TRUE)        # Add it over
dev.off()




















