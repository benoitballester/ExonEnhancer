# ExonEnhancer

This repository contains code and resources used in the study **"Exonic Enhancers Emerge as a Common Feature of Gene Regulation,"** in which we investigate how certain protein-coding exons can also act as bona fide enhancers (EEs). Our analyses integrate transcription factor binding, chromatin accessibility, and reporter assays to characterize these dual-function regulatory elements across multiple species.

---

## Overview

- **Paper:** “Exonic Enhancers Emerge as a Common Feature of Gene Regulation” (see bioRxiv DOI:).
- **Scope:** This project provides scripts, data processing workflows, and experimental validations (e.g., luciferase assays, STARR-seq screens, CRISPRi targeting) that support the identification and characterization of exonic enhancers.

## Key Analyses

- **TF ChIP-seq and Open Chromatin Integration**  
  Scripts that parse TF binding peaks (e.g., from ReMap) and intersect them with DNase-seq/ATAC-seq data.
  
- **EE Detection**  
  Code for defining exonic enhancers based on TF density and filtering out promoter-like exons.

- **Reporter Assays**  
  Protocols for running luciferase and STARR-seq experiments, plus downstream analysis scripts for fold-change calculations.

- **CRISPRi Validation**  
  Pipelines to design sgRNAs, perform CRISPR interference, and measure expression changes in putative EE-target genes.

- **Variant Analyses**  
  Tools for mapping variants (from gnomAD or TCGA) onto EEs to evaluate potential regulatory impacts.



## Data Availability

- The data used in this study is publicly available via **Zenodo** at [doi:xxxx](https://doi.org/xxxx). 
- Additional data sources include:
  - ChIP-seq, DNase/ATAC-seq, and STARR-seq data integrated from ENCODE, ChIP-Atlas, and public repositories.
  - Cancer mutation profiles sourced from TCGA PanCancer Atlas.
- Processed data and final outputs can also be found in the manuscript’s supplementary files.


## Citation

If you use this repository or data in your research, please cite:

```
Mouren et al. (2025)
Exonic Enhancers Emerge as a Common Feature of Gene Regulation
(Preprint / Journal details / DOI)
```

## Contact

- **Corresponding Author**:  
  Benoit Ballester – [benoit.ballester@inserm.fr](mailto:benoit.ballester@inserm.fr)

Please open an issue in this repository or contact the authors directly for questions, bug reports, or suggestions.

## License

This project is licensed under the [GPL-3.0 license](LICENSE). Please see the `LICENSE` file for details.
