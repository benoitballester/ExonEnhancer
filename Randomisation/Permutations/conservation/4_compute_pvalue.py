###
# cat /shared/projects/exonhancer/data/revisions/permut_test/conservation/results/results_*.txt > /shared/projects/exonhancer/data/revisions/permut_test/conservation/results_perm_conservation.txt
###

# Read permutation values from aggregated file
permutation_values = []

with open("/shared/projects/exonhancer/data/revisions/permut_test/conservation/results_perm_conservation.txt") as f:
    for line in f:
        try:
            permutation_values.append(float(line.strip().split()[0]))
        except ValueError:
            continue  # skip malformed lines

# Compute empirical p-value
n = len(permutation_values)
extreme_count = sum(1 for x in permutation_values if x >= 28)
p_value = extreme_count / n if n > 0 else None
mean_perm = sum(permutation_values) / n if n > 0 else 0
enrichment = 28 / mean_perm if mean_perm > 0 else None

# Write result
with open("/shared/projects/exonhancer/data/revisions/permut_test/conservation/empirical_pval_conservation.txt", "w") as out:
    out.write(f"Number of permutations: {n}\n")
    out.write(f"Observed overlap: {28:.4f}%\n")
    out.write(f"Mean of permutations (expected): {mean_perm:.4f}%\n")
    out.write(f"Enrichment (observed / expected): {enrichment:.2f}x\n")
    out.write(f"Count of permuted overlaps >= observed: {extreme_count}\n")
    out.write(f"Empirical p-value: {p_value:.6f}\n")