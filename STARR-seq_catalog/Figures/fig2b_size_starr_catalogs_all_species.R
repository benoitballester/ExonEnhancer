setwd("/shared/home/bballester/2.exons/starrseq-barplot")
# Load necessary library
library(ggplot2)
library(scales)  # For full number formatting


pdf("starrseq-barplot.pdf",width=4, height=7)

# Define data
categories <- c('A.tha', 'M.mus', 'D.mel', 'H.sap')
nb_peaks <- c(4339, 87255, 413509, 28731867)

# Define colors in the correct order
colors <- c("A.tha" = "#008C45",  # Green for A.tha
            "M.mus" = "#808080",  # Grey for M.mus
            "D.mel" = "#F4A500",  # Orange for D.mel
            "H.sap" = "#D52B1E")  # Red for H.sap

# Create data frame
df <- data.frame(categories, nb_peaks)

# Reorder categories based on nb_peaks (smallest to largest)
df$categories <- factor(df$categories, levels = df$categories[order(df$nb_peaks)])

# Create the bar plot
ggplot(df, aes(x = categories, y = nb_peaks, fill = categories)) +
  geom_bar(stat = "identity") +
  scale_y_log10(labels = scales::comma) +  # Log scale with full numbers
  scale_fill_manual(values = colors) +
  theme_minimal() +
  labs(y = "Nb of peaks", x = "") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

dev.off()
