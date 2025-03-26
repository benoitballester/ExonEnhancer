#!/bin/bash

# overlap the hi c data with exons and control datasets
# baited interaction type means the two fragments contains a promoter designed to be caught; unbaited means the contacted fragment doesnt have promoter


# We need two files : one with all the interactions (meaning the EE can be in a target fragment without or with a promoter)
# The other file where we will overlap the EE with the bait fragments, because the EE can be in bait, BUT target needs to be also baited,
# it means that the EE in the bait fragment needs another promoter in the target frament to interact with, so a baited target)

# 1 : Get exons coords
awk '{print $1,$2,$3,$4}' OFS=$'\t' hg38_EE.bed > exons_coords

# 2 : Overlap exons with the targets coordinates (which can be baited also or unbaited)
awk '(NR>1)' OFS=$'\t' allTargets_interactions_hg38.tsv |sort -k1,1 -k2,2n - > coords
bedtools intersect -a exons_coords -b coords -wa -wb > promHiC_interactions_EE_in_targets.tsv

# 3 : Overlap exons with the baits coordinates, but only if the target was also baited (meaning if the EE is in the bait fragment, it needs another promoter in the target frament to interact with, so a baited target)
awk '(NR>1)' OFS=$'\t' baitTobait_interactions_hg38.tsv |sort -k1,1 -k2,2n - > coords
bedtools intersect -a exons_coords -b coords -wa -wb > promHiC_interactions_EE_in_baits.tsv

rm exons_coords coords 

# 4 : Join all interactions in one file
cat promHiC_interactions_EE_in_targets.tsv promHiC_interactions_EE_in_baits.tsv |sort -k1,1 -k2,2n - >> promHiC_allEE_interactions.tsv


### CONTROL
# 1 : Get ctrl coords
awk '{print $1,$2,$3,$4}' OFS=$'\t' control_neg_NoTF_NoTSS_TES_prom.tsv > ctrlneg
awk '{print $1,$2,$3,$4}' OFS=$'\t' control_pos_enhD_NoTSS_TES_10TFmin.tsv > ctrlpos

# 2 : Overlap exons with the targets coordinates (which can be baited also or unbaited)
awk '(NR>1)' OFS=$'\t' allTargets_interactions_hg38.tsv |sort -k1,1 -k2,2n - > coords
bedtools intersect -a ctrlneg -b coords -wa -wb > promHiC_interactions_ctrlneg_in_targets.tsv
bedtools intersect -a ctrlpos -b coords -wa -wb > promHiC_interactions_ctrlpos_in_targets.tsv

# 3 : Overlap exons with the baits coordinates, but only if the target was also baited (meaning if the EE is in the bait fragment, it needs another promoter in the target frament to interact with, so a baited target)
awk '(NR>1)' OFS=$'\t'baitTobait_interactions_hg38.tsv |sort -k1,1 -k2,2n - > coords
bedtools intersect -a ctrlneg -b coords -wa -wb > promHiC_interactions_ctrlneg_in_baits.tsv
bedtools intersect -a ctrlpos -b coords -wa -wb > promHiC_interactions_ctrlpos_in_baits.tsv

rm ctrlneg ctrlpos coords 

# 4 : Join all interactions in one file
cat promHiC_interactions_ctrlneg_in_targets.tsv promHiC_interactions_ctrlneg_in_baits.tsv |sort -k1,1 -k2,2n - >> promHiC_allctrlneg_interactions.tsv
cat promHiC_interactions_ctrlpos_in_targets.tsv promHiC_interactions_ctrlpos_in_baits.tsv |sort -k1,1 -k2,2n - >> promHiC_allctrlpos_interactions.tsv