#!/bin/bash
echo -e "CATEGORY\tID\tCHR\tSTART\tEND\tSTRAND\tSEQUENCE" > STARR_AllSequences.tsv
cat allExons_REF_sequences.tsv K562_MUT_sequences.tsv K562_MultiMUT_sequences.tsv allCtrl_sequences.tsv >> STARR_AllSequences.tsv
