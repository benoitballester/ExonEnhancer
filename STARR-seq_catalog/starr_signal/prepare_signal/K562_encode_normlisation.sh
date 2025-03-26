#!/bin/bash

### narrowPeaks ENCODE files used                           
# ENCFF454ZKK             wg-starrseq-NA18517-k562    -> output signal bw : ENCFF906QND <- input signal bw : ENCFF814CNR
# ENCFF919UHO             wg-starrseq-NA18517-k562    -> output signal bw : ENCFF817HOX <- input signal bw : ENCFF814CNR
# ENCFF549QUG             wg-starrseq-NA18517-k562    -> output signal bw : ENCFF338YDG <- input signal bw : ENCFF814CNR

# ENCFF717VJK             WHG-STARRseq-K562           -> control normalized signal : ENCFF611ZHY
# ENCFF394DBM             WHG-STARRseq-K562           -> control normalized signal : ENCFF611ZHY
# bigwigCompare -b1 ENCFF906QND.bigWig -b2 ENCFF814CNR_inputDNA.bigWig --numberOfProcessors 18 --outFileName ENCFF454ZKK_log2ratio_K562.bw --outFileFormat bigwig
# bigwigCompare -b1 ENCFF817HOX.bigWig -b2 ENCFF814CNR_inputDNA.bigWig --numberOfProcessors 18 --outFileName ENCFF919UHO_log2ratio_K562.bw --outFileFormat bigwig
# bigwigCompare -b1 ENCFF338YDG.bigWig -b2 ENCFF814CNR_inputDNA.bigWig --numberOfProcessors 18 --outFileName ENCFF549QUG_log2ratio_K562.bw --outFileFormat bigwig

~/UCSC_commands/bigWigMerge ENCFF611ZHY_K562.bigWig ENCFF454ZKK_log2ratio_K562.bw ENCFF919UHO_log2ratio_K562.bw ENCFF549QUG_log2ratio_K562.bw allENCODE_STARR_signal_K-562.bedGraph

LC_COLLATE=C sort -k1,1 -k2,2n allENCODE_STARR_signal_K-562.bedGraph > allENCODE_STARR_signal_K-562_sorted.bedGraph
rm allENCODE_STARR_signal_K-562.bedGraph

awk '(NR>1)' /home/mouren/Data/final_files_tokeep/genomes_sizes/hg38_sizes.genome > tmp
~/UCSC_commands/bedGraphToBigWig allENCODE_STARR_signal_K-562_sorted.bedGraph tmp allENCODE_STARR_signal_K-562.bw 
rm tmp