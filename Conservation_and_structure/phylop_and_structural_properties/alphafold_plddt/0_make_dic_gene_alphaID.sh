#!/bin/bash

# Unzip alphafold collection and keep only cif files
# tar -xf $1
# rm *pdb*
# gzip -d *

# #Make dictionnary 
# _entry.id AF-Q9ZPR0-F1

# _ma_target_ref_db_details.gene_name                    At2g03690

# _struct_ref_seq.pdbx_db_accession           Q9ZPR0

output_file="alphafoldID_geneID_hsap.tsv"

# Start with a fresh/empty output file
> "../$output_file"

# Iterate over every file in the current directory
for file in *; do
  # Skip directories; only process files
  if [ -f "$file" ]; then
    
    # Extract the second field after each keyword
    accession=$(grep "^_struct_ref_seq\.pdbx_db_accession" "$file" \
      | awk '{print $2}' )
    gene_name=$(grep "^_ma_target_ref_db_details\.gene_name" "$file" \
      | awk '{print $2}' )
    entry_id=$(grep "^_entry\.id" "$file" \
      | awk '{print $2}' )
    
    # Append the three extracted values as a tab-separated line
    echo -e "${accession}\t${gene_name}\t${entry_id}" >> ../"$output_file"
  fi
done

#Need to remove some string in artefacts in the dm file
#sed -i 's/Dmel\\//g' alphafoldID_geneID_dm.tsv