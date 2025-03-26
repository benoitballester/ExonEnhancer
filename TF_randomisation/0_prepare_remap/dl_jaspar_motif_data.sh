# Download jaspar matrixes 
#https://jaspar.elixir.no/api/overview -> Pagination section
#https://jaspar.elixir.no/api/v1/docs/
"""(base) mouren@DLX3HR3:~/Data/jaspar_files$ coreapi action matrix list -p page=1 -p page_size=1000 -p collection=CORE -p tax_id=9606 -p release=2022 > jaspar2022_hg_all_matrix_CORE_collection.json
(base) mouren@DLX3HR3:~/Data/jaspar_files$ coreapi action matrix list -p page=1 -p page_size=1000 -p collection=CORE -p tax_id=10090 -p release=2022 > jaspar2022_mmus_all_matrix_CORE_collection.json"""

#actually in the paper  the vertebrate scan all species so we take all of them vvv
"""One of the primary uses of PFMs is to predict binding sites. To facilitate this, we created ready-made prediction tracks for genome visualization and interpretation. Specifically, we scanned the genomes of
 eight organisms (Arabidopsis thaliana, Caenorhabditis elegans, Ciona intestinalis, Danio rerio, Drosophila melanogaster, Homo sapiens, Mus musculus,andSaccharomyces cerevisiae) with the JASPAR CORE PFMs associated 
 with the same taxon to predict TFBSs and update the JASPAR TFBS genomic tracks"""


#coreapi action matrix list -p page=1 -p page_size=1000 -p collection=CORE -p tax_group=Vertebrates -p release=2022 > jaspar2022_vertebrates_all_matrix_CORE_collection.json
#coreapi action matrix list -p page=2 -p page_size=1000 -p collection=CORE -p tax_group=Vertebrates -p release=2022 >> jaspar2022_vertebrates_all_matrix_CORE_collection.json

#grep name jaspar2022_vertebrates_all_matrix_CORE_collection.json |cut -d: -f2 |cut -d\" -f2 |sort -u > jaspar2022_vertebrates_all_matrix_name.txt

#coreapi action matrix list -p page=1 -p page_size=1000 -p collection=CORE -p tax_group=Plants -p release=2022 > jaspar2022_plants_all_matrix_CORE_collection.json
#grep name jaspar2022_plants_all_matrix_CORE_collection.json |cut -d: -f2 |cut -d\" -f2 |sort -u > jaspar2022_plants_all_matrix_name.txt

#coreapi action matrix list -p page=1 -p page_size=1000 -p collection=CORE -p tax_group=Insects -p release=2022 > jaspar2022_insects_all_matrix_CORE_collection.json
#grep name jaspar2022_insects_all_matrix_CORE_collection.json |cut -d: -f2 |cut -d\" -f2 |sort -u > jaspar2022_insects_all_matrix_name.txt