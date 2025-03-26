setwd("/shared/home/bballester/2.exons/crispri_individual_plots/")



# Load necessary libraries
library(ggplot2)
library(reshape2)

# Read the data
data <- read.csv("GARRE1_CRISPRI.csv")

# Convert Target to a factor to preserve order
data$Target <- factor(data$Target, levels = data$Target)

# Reshape data to long format for ggplot2
long_data <- melt(data, id.vars = "Target", measure.vars = c("NTmoy", "EEmoy"), 
                  variable.name = "Condition", value.name = "Mean")

# Create a corresponding standard deviation column
long_data$STD <- c(data$`NT.STD`, data$`Exon.STD`)

pdf("GARRE1_CRISPRI-barplot1.pdf", width=5, height=5)

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

# 1) Load libraries
library(tidyverse)

# 2) Example data
df <- tribble(
  ~Target,       ~NT1,    ~NT2,    ~NT3,    ~EE1,    ~EE2,    ~EE3, ~NTmoy, ~`NT STD`, ~EEmoy, ~`Exon STD`, ~p.values,
  "GARRE1 up",   1.109,   0.986,   0.904,   0.835,   0.768,   0.780,    1,     0.1033,   0.7944,  0.03607,     0.0156,
  "GARRE1 down", 0.924,   1.024,   1.052,   0.746,   0.658,   0.641,    1,     0.0674,   0.6816,  0.05610,     0.00163,
  "GPI",         1.111,   1.052,   0.837,   0.861,   0.662,   0.714,    1,     0.1445,   0.7459,  0.10311,     0.03413
)

# 3) Reshape replicates into long form: one row per Target–Condition–Replicate
df_reps <- df %>%
  select(Target, NT1, NT2, NT3, EE1, EE2, EE3) %>%
  pivot_longer(
    cols       = c(NT1, NT2, NT3, EE1, EE2, EE3),
    names_to   = "Rep",
    values_to  = "Value"
  ) %>%
  mutate(
    # Identify NT vs EE by the prefix in the column name
    Condition = if_else(str_detect(Rep, "^NT"), "NT", "EE")
  )

# 4) Reshape means and SDs similarly
df_means <- df %>%
  select(Target, NTmoy, `NT STD`, EEmoy, `Exon STD`) %>%
  pivot_longer(
    cols       = c(NTmoy, EEmoy),
    names_to   = "Condition",
    values_to  = "Mean",
    names_pattern = "(NT|EE).*"  # extracts 'NT' or 'EE' from 'NTmoy','EEmoy'
  ) %>%
  mutate(
    # Match up the correct SD column
    SD = if_else(Condition == "NT", `NT STD`, `Exon STD`)
  )

# 5) Convert both data frames to factor variables
#    so we can control the order of Targets and Conditions
df_reps <- df_reps %>%
  mutate(
    Target = factor(Target, levels = c("GARRE1 up", "GARRE1 down", "GPI")),
    Condition = factor(Condition, levels = c("NT", "EE"))  # NT first, then EE
  )

df_means <- df_means %>%
  mutate(
    Target = factor(Target, levels = c("GARRE1 up", "GARRE1 down", "GPI")),
    Condition = factor(Condition, levels = c("NT", "EE"))
  )

# 6) Plot it
pdf("GARRE1_CRISPRI-barplot2.pdf", width=5, height=5)

ggplot() +
  # Bars + error bars
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
  scale_fill_manual(values = c("NT" = "steelblue", "EE" = "orange")) +
  # specify the y-axis tick spacing
  scale_y_continuous(breaks = seq(0, 1.4, 0.2)) +
  theme_bw(base_size = 14) +
  labs(
    fill = "Condition",
    x = NULL,
    y = "Expression"
  )
dev.off()




