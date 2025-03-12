# ExonEnhancer

This repository contains code and resources used in the study **"Exonic Enhancers Emerge as a Common Feature of Gene Regulation,"** in which we investigate how certain protein-coding exons can also act as bona fide enhancers (EEs). Our analyses integrate transcription factor binding, chromatin accessibility, and reporter assays to characterize these dual-function regulatory elements across multiple species.

---

## Overview

- **Paper:** “Exonic Enhancers Emerge as a Common Feature of Gene Regulation” (see `EE_Draft3.docx` for the current manuscript draft).
- **Scope:** This project provides scripts, data processing workflows, and experimental validations (e.g., luciferase assays, STARR-seq screens, CRISPRi targeting) that support the identification and characterization of exonic enhancers.
- **Goal:** Facilitate reproducible research into the dual coding and regulatory functions of exonic sequences, including:
  - Large-scale TF ChIP-seq integration
  - DNase-seq / ATAC-seq intersection
  - STARR-seq and luciferase reporter validation
  - CRISPR interference assays
  - Variant impact analyses (e.g., from gnomAD, TCGA)

---
## Data Availability
The data used in this study is publicly available via Zenodo at doi:xxxx.
Additional data sources include:
ChIP-seq, DNase/ATAC-seq, and STARR-seq data integrated from ENCODE, ChIP-Atlas, and public repositories.
Cancer mutation profiles sourced from TCGA PanCancer Atlas.
Processed data and final outputs can also be found in the manuscript’s supplementary files.

## Citation
If you use this repository or data in your research, please cite:

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/benoitballester/ExonEnhancer.git
   cd ExonEnhancer

## License
This project is licensed under the MIT License. Please see the LICENSE file for details.

## Contact
Corresponding Author:
Benoit Ballester – benoit.ballester@inserm.fr
Please open an issue in this repository or contact the authors directly for questions, bug reports, or suggestions.
