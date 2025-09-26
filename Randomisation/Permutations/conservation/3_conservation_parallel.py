import random
import sys

#### filter all exons merged with tes tss for the test to be relevant 
# awk '{if ($22=="NA") print $0}' OFS=$'\t' hg38_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp1 #tss
# awk '{if ($23=="NA") print $4}' OFS=$'\t' tmp1 > hg38_all_exons_merged_tss_tes_filtered.txt #tes

# awk '{if ($22=="NA") print $0}' OFS=$'\t' mm39_bilan_remap_ccre_CAGEtss_fantomEnh_NC1_TSS_TES_UTR5_UTR3_density50bp_NbAll_correl_DnaseENCODEChipAtlas_ATAC.tsv > tmp1 #tss
# awk '{if ($23=="NA") print $4}' OFS=$'\t' tmp1 > mm39_all_exons_merged_tss_tes_filtered.txt #tes
# rm tmp1
#####

# Read arguments: start and end iteration
start = int(sys.argv[1])
end = int(sys.argv[2])
output_file = sys.argv[3]

dic = {}
with open("/shared/projects/exonhancer/data/revisions/permut_test/conservation/hg_mmus_all_exons_lastz_dic.tsv") as f:
    for line in f:
        key, values = line.strip().split()
        dic[key] = set(values.split(","))

hg_exons = []
with open("/shared/projects/exonhancer/data/revisions/permut_test/conservation/hg38_all_exons_merged_tss_tes_filtered.txt") as f:
    for line in f:
        hg_exons.append(line.strip().split()[0])

mm_exons = []
with open("/shared/projects/exonhancer/data/revisions/permut_test/conservation/mm39_all_exons_merged_tss_tes_filtered.txt") as f:
    for line in f:
        mm_exons.append(line.strip().split()[0])

with open(output_file, "w") as f:
    for iteration in range(start, end):
        sampled_hg = random.sample(hg_exons, 13481)
        sampled_mm = set(random.sample(mm_exons, 12244))

        # Faster intersection-based count
        count = sum(
            1 for a in sampled_hg
            if a in dic and dic[a].intersection(sampled_mm)
        )

        percentage = (count / 13481) * 100
        f.write(f"{percentage:.4f}\n")
