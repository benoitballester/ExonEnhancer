#!bin/bash
# To call with the coding exons files treated of other species and the species suffix (like "mm39")
# Sort
sort -k 1,1 -k 2,2n $1 > tmp

# Calculating the size of each exon and adding it to the file
awk 'BEGIN { OFS = "\t" } { $7 = $3 - $2 } 1' tmp > tmp1 #This command works only if there is no header 

# Initial merging of all exactly identical exons : same CHR, START, END, STRAND
bedmap --echo-map --fraction-both 1 tmp1 | awk '$1>1' | sort-bed -| uniq - > tmp2
# --echo-map gives the line collapsed; --fraction-both 1 means we merge only element with 100% overlap on each other (the --exact option is supposed to do the same but it contains mistakes while this one got the same result as the awk '!seen[$1,$2,$3,$6]++' command)
# awk $1>1 permet de filter les éléments qui s'overlappe eux-même (parce qu'on map le fichier sur lui même); le "-" dans sort-bed signifie qu'on sort l'entrée stdin; "-" = stdin entry pour uniq (qui filtre les doubles de lignes ar on overlap le fichier sur lui même)

# Previous step collapse line on the 7 column (exon size) with a ; separator (ex : 126;chrX). We remove the ";" and what is after.
awk '{sub(/;.*/,"",$7)} 1' tmp2 > tmp3

# Bedmap echo-map-id doesn't work so we need to collapse the whole line. Thus, we will now put id of same exon (5 step) into one column (N°8) each of them delimited by a ";"
sed -e 's/  */\t/g' < tmp3 > tmp4 # To change every sequence of one or more space to a single tab -> We enforce tab delimitation within the file

# We get the ID of the collapsed exon and put it into the column N°8
cut -f1-7,10- tmp4 > tmp5

# We join the ID of collapsed exon in column 8 with the next one (separated by a ";"), then we cut again to the next one (loop)
while :  
do
    cpt=$(awk '{print $9}' tmp5)
    if [ -z "$cpt" ] # We check if cpt is empty
    then
        break
    else
        cut -f1-8,14- tmp5 > cut.bed # Get next good ID in column 9
        sed 's/\t/;/8' cut.bed > tmp5 # Join column 8 and 9 with ;
    fi
done

mv tmp5 coding_exons_exact_merge_${2}.bed

# Prepare file for 50bp merge
awk '{print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' coding_exons_exact_merge_${2}.bed > exact
awk '{print $1,$2,$3,$4,$5,$6,$7}' OFS=$'\t' coding_exons_exact_merge_${2}.bed > copy

bedtools intersect -a copy -b exact -wa -wb > ovlp.txt
awk '{print>$1}' OFS=$'\t' ovlp.txt

rm tmp tmp1 tmp2 tmp3 tmp4 cut.bed copy exact ovlp.txt