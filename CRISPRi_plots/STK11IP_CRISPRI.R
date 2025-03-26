setwd("/shared/home/bballester/2.exons/crispri_individual_plots/")



# Load necessary libraries
library(ggplot2)
library(reshape2)

# Read the data
data <- read.csv("STK11IP_CRISPRI.csv")

# Convert Target to a factor to preserve order
data$Target <- factor(data$Target, levels = data$Target)

# Reshape data to long format for ggplot2
long_data <- melt(data, id.vars = "Target", measure.vars = c("NTmoy", "EEmoy"), 
                  variable.name = "Condition", value.name = "Mean")

# Create a corresponding standard deviation column
long_data$STD <- c(data$`NT.STD`, data$`Exon.STD`)

pdf("STK11IP_CRISPRI-barplot1.pdf", width=5, height=5)

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
# 2) Create your STK11IP data
# -------------------------------------------------------------
df <- tribble(
  ~Target,         ~NT1,       ~NT2,       ~NT3,       ~EE1,       ~EE2,       ~EE3,       ~`gRNA NT`, ~`NT STD`, ~`gRNA EE STK11IP`, ~`Exon STD`, ~p.values,
  "STK11IP up",    0.983284169,0.991150442,1.025565388,0.600786627,0.637168142,0.677482793, 1,          0.022486916, 0.638479187,       0.038364887, 7.3812e-05,
  "STK11IP down",  0.874890639,0.91776028, 1.207349081,0.65791776, 0.733158355,0.63079615,  1,          0.18084436,  0.673957422,       0.053032615, 0.020039824,
  "CHPF part",     0.92879257, 1.019814241,1.051393189,0.637151703,0.645510836,0.702167183, 1,          0.063656744, 0.661609907,       0.035371432, 0.00064696
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
# 4) Reshape means and SD columns similarly
#    "gRNA NT" => "NTmoy", "gRNA EE STK11IP" => "EEmoy"
# -------------------------------------------------------------
df_means <- df %>%
  # rename columns so they're consistent with previous scripts:
  rename(NTmoy = `gRNA NT`, EEmoy = `gRNA EE STK11IP`) %>%
  pivot_longer(
    cols         = c(NTmoy, EEmoy),
    names_to     = "Condition",
    values_to    = "Mean",
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
    Target = factor(Target, levels = c("STK11IP up", "STK11IP down", "CHPF part")),
    Condition = factor(Condition, levels = c("NT","EE"))
  )

df_means <- df_means %>%
  mutate(
    Target = factor(Target, levels = c("STK11IP up", "STK11IP down", "CHPF part")),
    Condition = factor(Condition, levels = c("NT","EE"))
  )


pdf("STK11IP_CRISPRI-barplot2.pdf", width=5, height=5)
# -------------------------------------------------------------
# 6) Plot
# -------------------------------------------------------------
ggplot() +
  # bars + error bars for means
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
  # points for replicates
  geom_point(
    data = df_reps,
    aes(x = Target, y = Value, fill = Condition),
    shape = 21,
    size = 3,
    position = position_dodge(width = 0.9)
  ) +
  # optional custom colors for NT/EE
  scale_fill_manual(values = c("NT" = "steelblue", "EE" = "orange")) +
  # optional: control y-axis ticks (e.g. every 0.2 up to 1.4)
  scale_y_continuous(breaks = seq(0, 1.4, 0.2)) +
  theme_bw(base_size = 14) +
  labs(
    fill = "Condition",
    x = NULL,
    y = "Expression"
  )


dev.off()
