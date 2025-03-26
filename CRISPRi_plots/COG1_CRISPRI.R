setwd("/shared/home/bballester/2.exons/crispri_individual_plots/")

# Load necessary libraries
library(ggplot2)
library(reshape2)

# Read the data
data <- read.csv("COG1_CRISPRI.csv")

# Convert Target to a factor to preserve order
data$Target <- factor(data$Target, levels = data$Target)

# Reshape data to long format for ggplot2
long_data <- melt(data, id.vars = "Target", measure.vars = c("NTmoy", "EEmoy"), 
                  variable.name = "Condition", value.name = "Mean")

# Create a corresponding standard deviation column
long_data$STD <- c(data$`NT.STD`, data$`Exon.STD`)

pdf("COG1_CRISPRI-barplot1.pdf", width=5, height=5)

# Create the bar plot with error bars
ggplot(long_data, aes(x = Target, y = Mean, fill = Condition)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.6) +
  geom_errorbar(aes(ymin = Mean - STD, ymax = Mean + STD), 
                width = 0.2, position = position_dodge(width = 0.7)) +
  scale_fill_manual(values = c("NTmoy" = "steelblue", "EEmoy" = "darkorange")) +
  scale_y_continuous(breaks = seq(0, max(long_data$Mean + long_data$STD), by = 0.2)) +  # Set y-axis increments by 0.2
  theme_minimal() +
  labs(y = "", x = "", fill = "") +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))

dev.off()




# -------------------------------------------------------------
# Script to plot replicate points alongside means
# -------------------------------------------------------------



# -------------------------------------------------------------
# Example R script to plot replicate points alongside means
# -------------------------------------------------------------

# -------------------------------------------------------------
# 1) Load libraries
# -------------------------------------------------------------
library(tidyverse)

# -------------------------------------------------------------
# 2) Create your COG1 data (with new rows & numeric values)
#    Notice we rename "NTmoy" -> "gRNA NT" and "EEmoy" -> "gRNA EE STK11IP"
#    so the rest of the script matches exactly the old code structure.
# -------------------------------------------------------------
df <- tribble(
  ~Target,     ~NT1,          ~NT2,          ~NT3,          ~EE1,          ~EE2,          ~EE3,
  ~`gRNA NT`,  ~`NT STD`,     ~`gRNA EE STK11IP`, ~`Exon STD`,     ~p.values,
  
  "COG1 up",    1.007725899,   0.973463218,   1.018810883,   0.808196171,   0.883775613,   0.789049379,
  1,             0.023640428,   0.827007054,        0.050086444,   0.002827277,
  
  "COG1 down",  0.994365264,   1.032151144,   0.973483593,   0.822340073,   0.630427577,   0.702021876,
  1,             0.029736897,   0.718263175,        0.096981629,   0.004290668,
  
  "VCF1 part",  1.162340178,   0.983339791,   0.854320031,   1.100736149,   0.72065091,    0.855482371,
  1,             0.154684436,   0.89228981,         0.192697399,   0.246136059
)

# -------------------------------------------------------------
# 3) Reshape replicates (NT1, NT2, NT3, EE1, EE2, EE3) into long form
# -------------------------------------------------------------
df_reps <- df %>%
  select(Target, NT1, NT2, NT3, EE1, EE2, EE3) %>%
  pivot_longer(
    cols      = c(NT1, NT2, NT3, EE1, EE2, EE3),
    names_to  = "Rep",
    values_to = "Value"
  ) %>%
  mutate(
    # Identify condition: "NT" vs "EE"
    Condition = if_else(str_detect(Rep, "^NT"), "NT", "EE")
  )

# -------------------------------------------------------------
# 4) Reshape means + SD columns
#    "gRNA NT" => "NTmoy", "gRNA EE STK11IP" => "EEmoy"
# -------------------------------------------------------------
df_means <- df %>%
  rename(NTmoy = `gRNA NT`, EEmoy = `gRNA EE STK11IP`) %>%
  pivot_longer(
    cols          = c(NTmoy, EEmoy),
    names_to      = "Condition",
    values_to     = "Mean",
    names_pattern = "(NT|EE).*"  # picks up 'NT' or 'EE' from 'NTmoy','EEmoy'
  ) %>%
  mutate(
    # Match SD to the Condition
    SD = if_else(
      Condition == "NT",
      `NT STD`,
      `Exon STD`
    )
  )

# -------------------------------------------------------------
# 5) Convert to factor and specify plotting order
# -------------------------------------------------------------
df_reps <- df_reps %>%
  mutate(
    Target = factor(Target, levels = c("COG1 up", "COG1 down", "VCF1 part")),
    Condition = factor(Condition, levels = c("NT","EE"))
  )

df_means <- df_means %>%
  mutate(
    Target = factor(Target, levels = c("COG1 up", "COG1 down", "VCF1 part")),
    Condition = factor(Condition, levels = c("NT","EE"))
  )

# -------------------------------------------------------------
# 6) Plot and save to PDF
# -------------------------------------------------------------
pdf("COG1_CRISPRI-barplot2.pdf", width=5, height=5)

ggplot() +
  # Bars + error bars for means
  geom_col(
    data = df_means,
    aes(x = Target, y = Mean, fill = Condition),
    position = position_dodge(width = 0.9),
    width = 0.7
  ) +
  geom_errorbar(
    data = df_means,
    aes(x = Target, ymin = Mean - SD, ymax = Mean + SD, group = Condition),
    position = position_dodge(width = 0.9),
    width = 0.2
  ) +
  # Points for individual replicates
  geom_point(
    data = df_reps,
    aes(x = Target, y = Value, fill = Condition),
    shape = 21,
    size = 3,
    position = position_dodge(width = 0.9)
  ) +
  scale_fill_manual(values = c("NT" = "steelblue", "EE" = "orange")) +
  # optional: control y-axis breaks (e.g., 0 to 1.4 in 0.2 increments)
  scale_y_continuous(breaks = seq(0, 1.4, 0.2)) +
  theme_bw(base_size = 14) +
  labs(
    fill = "Condition",
    x = NULL,
    y = "Expression"
  )

dev.off()


