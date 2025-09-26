import pandas as pd

# Bash
#awk '{print "chr"$5,$6,$7,$9,$11,$12,$13,$14,$16,$17,$18,$19,$40,$41,$42,$43,$44,$45}' OFS='\t' mc3.v0.2.8.PUBLIC.maf.gz > mc3.v0.2.8.PUBLIC_AF_analysis_hg19.maf

# Load the data from your TCGA SNP file
file_path = '/mnt/project/exonhancer/ZENODO_REPO_DISCARDED_JC_DONT_TOUCH/PanCancer_analysis/treat_mc3_file/mc3.v0.2.8.PUBLIC_AF_analysis_hg19.maf'
df = pd.read_csv(file_path, sep='\t')

# Calculate tumor allele frequency
df['Tumor_AF'] = df['t_alt_count'] / (df['t_ref_count'] + df['t_alt_count'])

# Calculate normal allele frequency
df['Normal_AF'] = df['n_alt_count'] / (df['n_ref_count'] + df['n_alt_count'])

# Save or display results
output_path = '/mnt/project/exonhancer/ZENODO_REPO_DISCARDED_JC_DONT_TOUCH/PanCancer_analysis/treat_mc3_file/mc3_tcga_snp_AF_hg19.tsv'
df.to_csv(output_path, sep='\t', index=False, header=False)

# Save header separately
header_only_path = '/mnt/project/exonhancer/ZENODO_REPO_DISCARDED_JC_DONT_TOUCH/PanCancer_analysis/treat_mc3_file/mc3_tcga_snp_AF_hg19_header.tsv'
with open(header_only_path, 'w') as header_file:
    header_file.write('\t'.join(df.columns) + '\n')

# Classify SNP as Somatic or Germline based on normal allele frequency
# Typically, Normal_AF near 0 indicates somatic; significantly greater than 0 indicates germline.
#df['Variant_Class'] = df['Normal_AF'].apply(lambda x: 'Germline' if x > 0.02 else 'Somatic')   #âctually we dont need to do that, because the mc3 file is a curated file that supposely only have somatic mutations 

# TCGA
# PanCanAtlas
# Cell Systems. Volume 6 Issue 3: p271-281.e7, 28 March 2018 10.1016/j.cels.2018.03.002
# Abstract

# The Cancer Genome Atlas (TCGA) cancer genomics dataset includes over 10,000 tumor-normal exome pairs across 33 different cancer types, in total >400 TB of raw data files requiring analysis. 
# Here we describe the Multi-Center Mutation Calling in Multiple Cancers project, our effort to generate a comprehensive encyclopedia of somatic mutation calls for the TCGA data to enable robust
#  cross-tumor-type analyses. Our approach accounts for variance and batch effects introduced by the rapid advancement of DNA extraction, hybridization-capture, sequencing, and analysis methods over time. 
# We present best practices for applying an ensemble of seven mutation-calling algorithms with scoring and artifact filtering. The dataset created by this analysis includes 3.5 million somatic variants
#  and forms the basis for PanCan Atlas papers. The results have been made available to the research community along with the methods used to generate them. This project is the result of collaboration
# from a number of institutes and demonstrates how team science drives extremely large genomics projects.

# 2% is low enough to confidently say there's no real evidence of the variant in the normal sample.

# It allows for:

#     Error tolerance (sequencing error rate is often ~0.1–1%)

#     Biological noise without mislabeling real somatic mutations

# Example:

# If n_ref_count + n_alt_count = 100:

#     2% = 2 ALT reads allowed

#     This accounts for random error without falsely classifying a somatic mutation as germline.


# 2% is a balanced default: low enough to minimize false positives, high enough to allow for sequencing noise.