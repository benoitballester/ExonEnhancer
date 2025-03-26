#!/bin/bash
~/UCSC_commands/bigWigAverageOverBed ./files/hg38.phyloP100way.bw  /home/mouren/Data/final_files_tokeep/other_species/hg38_EE.bed hg38_EE_phylop.tsv -bedOut=hg38_EE_phylop.bed -stats=hg38_EE_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/hg38.phyloP100way.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/control_neg_NoTF_NoTSS_TES_prom.tsv hg38_ctrlneg_phylop.tsv -bedOut=hg38_ctrlneg_phylop.bed -stats=hg38_ctrlneg_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/hg38.phyloP100way.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/control_pos_enhD_NoTSS_TES_10TFmin.tsv hg38_ctrlpos_phylop.tsv -bedOut=hg38_ctrlpos_phylop.bed -stats=hg38_ctrlpos_phylop_stats.ra 

~/UCSC_commands/bigWigAverageOverBed ./files/mm39.phyloP35way.bw  /home/mouren/Data/final_files_tokeep/other_species/mm39_EE.bed mm39_EE_phylop.tsv -bedOut=mm39_EE_phylop.bed -stats=mm39_EE_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/mm39.phyloP35way.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/mm39_control_neg_NoTF_NoTSS_TES_prom.tsv mm39_ctrlneg_phylop.tsv -bedOut=mm39_ctrlneg_phylop.bed -stats=mm39_ctrlneg_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/mm39.phyloP35way.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/mm39_control_pos_enhD_NoTSS_TES_10TFmin.tsv mm39_ctrlpos_phylop.tsv -bedOut=mm39_ctrlpos_phylop.bed -stats=mm39_ctrlpos_phylop_stats.ra 

~/UCSC_commands/bigWigAverageOverBed ./files/dm6.phyloP124way.bw  /home/mouren/Data/final_files_tokeep/other_species/dm6_EE.bed dm6_EE_phylop.tsv -bedOut=dm6_EE_phylop.bed -stats=dm6_EE_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/dm6.phyloP124way.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/dm6_control_neg_NoTF_NoTSS_TES.tsv dm6_ctrlneg_phylop.tsv -bedOut=dm6_ctrlneg_phylop.bed -stats=dm6_ctrlneg_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/dm6.phyloP124way.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/dm6_control_pos_NoTSS_TES_10TFmin.tsv dm6_ctrlpos_phylop.tsv -bedOut=dm6_ctrlpos_phylop.bed -stats=dm6_ctrlpos_phylop_stats.ra 

#~/UCSC_commands/bedGraphToBigWig Ath_PhyloP.bedGraph ../../../final_files_tokeep/genomes_sizes/tair10_chr.sizes Ath_PhyloP.bw
~/UCSC_commands/bigWigAverageOverBed ./files/Ath_PhyloP.bw  /home/mouren/Data/final_files_tokeep/other_species/tair10_EE_Chr.bed tair10_EE_phylop.tsv -bedOut=tair10_EE_phylop.bed -stats=tair10_EE_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/Ath_PhyloP.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/other_species/tair10_control_neg_Chr.bed tair10_ctrlneg_phylop.tsv -bedOut=tair10_ctrlneg_phylop.bed -stats=tair10_ctrlneg_phylop_stats.ra 
~/UCSC_commands/bigWigAverageOverBed ./files/Ath_PhyloP.bw  /mnt/project/exonhancer/ZENODO_REPO/Control_selection/other_species/tair10_control_pos_Chr.bed tair10_ctrlpos_phylop.tsv -bedOut=tair10_ctrlpos_phylop.bed -stats=tair10_ctrlpos_phylop_stats.ra 
