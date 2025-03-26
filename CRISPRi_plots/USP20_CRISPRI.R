setwd("/shared/home/bballester/2.exons/crispri_individual_plots/")



# Load necessary libraries
library(ggplot2)
library(reshape2)

# Read the data
data <- read.csv("USP20_CRISPRI.csv")

# Convert Target to a factor to preserve order
data$Target <- factor(data$Target, levels = data$Target)

# Reshape data to long format for ggplot2
long_data <- melt(data, id.vars = "Target", measure.vars = c("NTmoy", "EEmoy"), 
                  variable.name = "Condition", value.name = "Mean")

# Create a corresponding standard deviation column
long_data$STD <- c(data$`NT.STD`, data$`Exon.STD`)

pdf("USP20_CRISPRI-barplot1.pdf", width=5, height=5)

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

# 1) Load libraries
library(tidyverse)

# 2) New data
df <- tribble(
  ~Target,         ~NT1,     ~NT2,     ~NT3,     ~EE1,     ~EE2,     ~EE3, ~NTmoy, ~`NT STD`, ~EEmoy, ~`Exon STD`, ~p.values,
  "USP20 up",      0.9917,   0.9898,   1.0185,   0.6952,   0.5643,   0.4949,   1,    0.01606,   0.5848, 0.10173,    0.001106061,
  "USP20 down",    0.8532,   1.0205,   1.1263,   0.6305,   0.6186,   0.6092,   1,    0.13767,   0.6195, 0.01069,    0.004408742,
  "Corf78",        0.8626,   0.9988,   1.1386,   0.7582,   0.9480,   0.9652,   1,    0.13801,   0.8905, 0.11486,    0.175123927
)

# 3) Reshape replicates (NT1–3, EE1–3) into long form
df_reps <- df %>%
  select(Target, NT1, NT2, NT3, EE1, EE2, EE3) %>%
  pivot_longer(
    cols       = c(NT1, NT2, NT3, EE1, EE2, EE3),
    names_to   = "Rep",
    values_to  = "Value"
  ) %>%
  mutate(
    # Identify NT vs EE from the column name prefix
    Condition = if_else(str_detect(Rep, "^NT"), "NT", "EE")
  )

# 4) Reshape means (NTmoy, EEmoy) and SDs (NT STD, Exon STD) similarly
df_means <- df %>%
  select(Target, NTmoy, `NT STD`, EEmoy, `Exon STD`) %>%
  pivot_longer(
    cols         = c(NTmoy, EEmoy),
    names_to     = "Condition",
    values_to    = "Mean",
    names_pattern = "(NT|EE).*"  # extracts 'NT' or 'EE' from column names
  ) %>%
  mutate(
    SD = if_else(Condition == "NT", `NT STD`, `Exon STD`)
  )

# 5) Convert both data frames to factor variables
df_reps <- df_reps %>%
  mutate(
    Target = factor(Target, levels = c("USP20 up", "USP20 down", "Corf78")),
    Condition = factor(Condition, levels = c("NT", "EE"))  # ensures NT is first
  )

df_means <- df_means %>%
  mutate(
    Target = factor(Target, levels = c("USP20 up", "USP20 down", "Corf78")),
    Condition = factor(Condition, levels = c("NT", "EE"))
  )

# 6) Plot

pdf("USP20_CRISPRI-barplot2.pdf", width=5, height=5)
ggplot() +
  # Bars & error bars for means
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
  # Points for replicates
  geom_point(
    data = df_reps,
    aes(x = Target, y = Value, fill = Condition),
    position = position_dodge(width = 0.9),
    shape = 21,  
    size = 3
  ) +
  # Custom color scheme for NT / EE
  scale_fill_manual(values = c("NT" = "steelblue", "EE" = "orange")) +
  # Set y-axis breaks every 0.2 from 0 to 1.4 (adjust as you wish)
  scale_y_continuous(breaks = seq(0, 1.4, 0.2)) +
  theme_bw(base_size = 14) +
  labs(
    fill = "Condition",
    x    = NULL,
    y    = "Expression"
  )



dev.off()
