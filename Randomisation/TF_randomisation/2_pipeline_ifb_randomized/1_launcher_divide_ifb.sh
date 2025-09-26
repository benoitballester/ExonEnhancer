#!/bin/bash
#
#SBATCH -p fast                      # partition
#SBATCH --cpus-per-task 240          # allocate CPUs
#SBATCH --mem 1400GB                 # memory
#SBATCH -t 00-23:00                  # max runtime (D-HH:MM)
#SBATCH -o slurm.%N.%j.out           # STDOUT
#SBATCH -e slurm.%N.%j.err           # STDERR

source /shared/projects/exonhancer/venv/bin/activate

# File paths
tf_file="/shared/projects/exonhancer/data/matching_tfbs/data/remap_all/ee_peak_remap_all_jaspar_to_match_hg38.bed"
tfbs_file="/shared/projects/exonhancer/data/matching_tfbs/data/tfbs_all_shuffled/ee_ovlp_jaspar_hg38_2022_full"
chr_file="/shared/projects/exonhancer/data/matching_tfbs/data/chr_hg" #file with the list of chromosomes we want, it needs to match the format in remap and jaspar files (e.g. chr1 chr2...)

### Split TFBS
# Function to process a chromosome
process_chr() {
  local value=$1
  grep "^$value" "$tfbs_file" | 
  awk '{
    split($4, a, "::"); 
    if (a[2] == "") a[2] = "NA"; 
    $4 = toupper(a[1]); 
    $5 = toupper(a[2]); 
    print $1,$2,$3,$4,$5
  }' OFS="\t" | 
  sort --parallel=10 -k1,1 -k2,2n > "/shared/projects/exonhancer/data/matching_tfbs/to_treat/tfbs/${value}"
}

export -f process_chr
export tfbs_file

# Parallel execution using xargs
cat "$chr_file" | xargs -n 1 -P "$SLURM_CPUS_PER_TASK" -I {} bash -c 'process_chr "{}"'

#rm $tfbs_file

### Split TF
srun python /shared/projects/exonhancer/repoexonhancer/divers/matching_jaspar_remap/pipeline_ifb_randomized_v2/2_divide_tfbs.py $tf_file

### TFBS for each group
# Function for the intersect
run_bedtools_intersect() {
    local file_tf="$1"
    local base_file_tf
    base_file_tf=$(basename "$file_tf")
    
    # Extract the chromosome name from the first column of the first line of the file
    local chromosome
    chromosome=$(awk 'NR==1 {print $1}' "$file_tf")
    
    local file_tfbs="/shared/projects/exonhancer/data/matching_tfbs/to_treat/tfbs/${chromosome}"
        
    bedtools intersect -sorted -a "$file_tf" -b "$file_tfbs" -wa -wb > "/shared/projects/exonhancer/data/matching_tfbs/to_treat/match_tfbs/${base_file_tf}_ovlp"

    echo "Done: $file_tf"
}

export -f run_bedtools_intersect

# Find all files and process them in parallel
find /shared/projects/exonhancer/data/matching_tfbs/to_treat/remap/ -type f | xargs -n 1 -P "$SLURM_CPUS_PER_TASK" -I {} bash -c 'run_bedtools_intersect "{}"'

### Send matching analyses
DIRECTORY="/shared/projects/exonhancer/data/matching_tfbs/to_treat/remap"

for FILE in "$DIRECTORY"/*; do
    BASENAME=$(basename "$FILE")
    # Submit the sbatch job with the file as an argument
    sbatch /shared/projects/exonhancer/repoexonhancer/divers/matching_jaspar_remap/pipeline_ifb_randomized_v2/3_launcher_matching_script_ifb.sh "$FILE" "/shared/projects/exonhancer/data/matching_tfbs/to_treat/match_tfbs/${BASENAME}_ovlp" /shared/projects/exonhancer/data/matching_tfbs/to_treat/nb_tf_per_elements.tsv
done