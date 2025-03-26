#!/bin/bash

### ee
bedtools intersect -a ee/human_coords.bed -b elife_bed_results/hsa_CEBPA_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_hsa_CEBPA.tsv
bedtools intersect -a ee/human_coords.bed -b elife_bed_results/hsa_FOXA1_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_hsa_FOXA1.tsv
bedtools intersect -a ee/human_coords.bed -b elife_bed_results/hsa_HNF4A_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_hsa_HNF4A.tsv
bedtools intersect -a ee/human_coords.bed -b elife_bed_results/hsa_HNF6_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_hsa_HNF6.tsv

bedtools intersect -a ee/mouse_coords.bed -b elife_bed_results/mmu_CEBPA_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mmu_CEBPA.tsv
bedtools intersect -a ee/mouse_coords.bed -b elife_bed_results/mmu_FOXA1_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mmu_FOXA1.tsv
bedtools intersect -a ee/mouse_coords.bed -b elife_bed_results/mmu_HNF4A_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mmu_HNF4A.tsv
bedtools intersect -a ee/mouse_coords.bed -b elife_bed_results/mmu_HNF6_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mmu_HNF6.tsv

bedtools intersect -a ee/rat_coords.bed -b elife_bed_results/rno_CEBPA_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_rno_CEBPA.tsv
bedtools intersect -a ee/rat_coords.bed -b elife_bed_results/rno_FOXA1_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_rno_FOXA1.tsv
bedtools intersect -a ee/rat_coords.bed -b elife_bed_results/rno_HNF4A_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_rno_HNF4A.tsv
bedtools intersect -a ee/rat_coords.bed -b elife_bed_results/rno_HNF6_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_rno_HNF6.tsv

bedtools intersect -a ee/dog_coords.bed -b elife_bed_results/cfa_CEBPA_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_cfa_CEBPA.tsv
bedtools intersect -a ee/dog_coords.bed -b elife_bed_results/cfa_FOXA1_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_cfa_FOXA1.tsv
bedtools intersect -a ee/dog_coords.bed -b elife_bed_results/cfa_HNF4A_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_cfa_HNF4A.tsv
bedtools intersect -a ee/dog_coords.bed -b elife_bed_results/cfa_HNF6_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_cfa_HNF6.tsv

bedtools intersect -a ee/macaque_coords.bed -b elife_bed_results/mml_CEBPA_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mml_CEBPA.tsv
bedtools intersect -a ee/macaque_coords.bed -b elife_bed_results/mml_FOXA1_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mml_FOXA1.tsv
bedtools intersect -a ee/macaque_coords.bed -b elife_bed_results/mml_HNF4A_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mml_HNF4A.tsv
bedtools intersect -a ee/macaque_coords.bed -b elife_bed_results/mml_HNF6_liver_peaks.narrowPeak -wa -wb > ee/ovlp/ee_mml_HNF6.tsv

### ctrl neg 
bedtools intersect -a controlneg/human_coords.bed -b elife_bed_results/hsa_CEBPA_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_hsa_CEBPA.tsv
bedtools intersect -a controlneg/human_coords.bed -b elife_bed_results/hsa_FOXA1_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_hsa_FOXA1.tsv
bedtools intersect -a controlneg/human_coords.bed -b elife_bed_results/hsa_HNF4A_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_hsa_HNF4A.tsv
bedtools intersect -a controlneg/human_coords.bed -b elife_bed_results/hsa_HNF6_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_hsa_HNF6.tsv

bedtools intersect -a controlneg/mouse_coords.bed -b elife_bed_results/mmu_CEBPA_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mmu_CEBPA.tsv
bedtools intersect -a controlneg/mouse_coords.bed -b elife_bed_results/mmu_FOXA1_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mmu_FOXA1.tsv
bedtools intersect -a controlneg/mouse_coords.bed -b elife_bed_results/mmu_HNF4A_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mmu_HNF4A.tsv
bedtools intersect -a controlneg/mouse_coords.bed -b elife_bed_results/mmu_HNF6_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mmu_HNF6.tsv

bedtools intersect -a controlneg/rat_coords.bed -b elife_bed_results/rno_CEBPA_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_rno_CEBPA.tsv
bedtools intersect -a controlneg/rat_coords.bed -b elife_bed_results/rno_FOXA1_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_rno_FOXA1.tsv
bedtools intersect -a controlneg/rat_coords.bed -b elife_bed_results/rno_HNF4A_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_rno_HNF4A.tsv
bedtools intersect -a controlneg/rat_coords.bed -b elife_bed_results/rno_HNF6_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_rno_HNF6.tsv

bedtools intersect -a controlneg/dog_coords.bed -b elife_bed_results/cfa_CEBPA_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_cfa_CEBPA.tsv
bedtools intersect -a controlneg/dog_coords.bed -b elife_bed_results/cfa_FOXA1_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_cfa_FOXA1.tsv
bedtools intersect -a controlneg/dog_coords.bed -b elife_bed_results/cfa_HNF4A_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_cfa_HNF4A.tsv
bedtools intersect -a controlneg/dog_coords.bed -b elife_bed_results/cfa_HNF6_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_cfa_HNF6.tsv

bedtools intersect -a controlneg/macaque_coords.bed -b elife_bed_results/mml_CEBPA_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mml_CEBPA.tsv
bedtools intersect -a controlneg/macaque_coords.bed -b elife_bed_results/mml_FOXA1_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mml_FOXA1.tsv
bedtools intersect -a controlneg/macaque_coords.bed -b elife_bed_results/mml_HNF4A_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mml_HNF4A.tsv
bedtools intersect -a controlneg/macaque_coords.bed -b elife_bed_results/mml_HNF6_liver_peaks.narrowPeak -wa -wb > controlneg/ovlp/controlneg_mml_HNF6.tsv

### ctrl pos 
bedtools intersect -a controlpos/human_coords.bed -b elife_bed_results/hsa_CEBPA_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_hsa_CEBPA.tsv
bedtools intersect -a controlpos/human_coords.bed -b elife_bed_results/hsa_FOXA1_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_hsa_FOXA1.tsv
bedtools intersect -a controlpos/human_coords.bed -b elife_bed_results/hsa_HNF4A_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_hsa_HNF4A.tsv
bedtools intersect -a controlpos/human_coords.bed -b elife_bed_results/hsa_HNF6_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_hsa_HNF6.tsv

bedtools intersect -a controlpos/mouse_coords.bed -b elife_bed_results/mmu_CEBPA_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mmu_CEBPA.tsv
bedtools intersect -a controlpos/mouse_coords.bed -b elife_bed_results/mmu_FOXA1_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mmu_FOXA1.tsv
bedtools intersect -a controlpos/mouse_coords.bed -b elife_bed_results/mmu_HNF4A_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mmu_HNF4A.tsv
bedtools intersect -a controlpos/mouse_coords.bed -b elife_bed_results/mmu_HNF6_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mmu_HNF6.tsv

bedtools intersect -a controlpos/rat_coords.bed -b elife_bed_results/rno_CEBPA_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_rno_CEBPA.tsv
bedtools intersect -a controlpos/rat_coords.bed -b elife_bed_results/rno_FOXA1_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_rno_FOXA1.tsv
bedtools intersect -a controlpos/rat_coords.bed -b elife_bed_results/rno_HNF4A_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_rno_HNF4A.tsv
bedtools intersect -a controlpos/rat_coords.bed -b elife_bed_results/rno_HNF6_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_rno_HNF6.tsv

bedtools intersect -a controlpos/dog_coords.bed -b elife_bed_results/cfa_CEBPA_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_cfa_CEBPA.tsv
bedtools intersect -a controlpos/dog_coords.bed -b elife_bed_results/cfa_FOXA1_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_cfa_FOXA1.tsv
bedtools intersect -a controlpos/dog_coords.bed -b elife_bed_results/cfa_HNF4A_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_cfa_HNF4A.tsv
bedtools intersect -a controlpos/dog_coords.bed -b elife_bed_results/cfa_HNF6_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_cfa_HNF6.tsv

bedtools intersect -a controlpos/macaque_coords.bed -b elife_bed_results/mml_CEBPA_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mml_CEBPA.tsv
bedtools intersect -a controlpos/macaque_coords.bed -b elife_bed_results/mml_FOXA1_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mml_FOXA1.tsv
bedtools intersect -a controlpos/macaque_coords.bed -b elife_bed_results/mml_HNF4A_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mml_HNF4A.tsv
bedtools intersect -a controlpos/macaque_coords.bed -b elife_bed_results/mml_HNF6_liver_peaks.narrowPeak -wa -wb > controlpos/ovlp/controlpos_mml_HNF6.tsv