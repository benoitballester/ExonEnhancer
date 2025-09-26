import sys

observed = float(sys.argv[1])
aggregated_file = sys.argv[2]
output_file = sys.argv[3]

# Read permutation values from aggregated file
permutation_values = []

with open(aggregated_file) as f:
    for line in f:
        try:
            permutation_values.append(float(line.strip().split()[1]))
        except ValueError:
            continue  # skip malformed lines

# Compute empirical p-value
n = len(permutation_values)
mean_expected = sum(permutation_values) / n

enrichment = observed / mean_expected if mean_expected != 0 else float("inf")
# Two-tailed p-value based on direction of deviation
if observed > mean_expected:
    tail_p = sum(1 for x in permutation_values if x >= observed) / n
else:
    tail_p = sum(1 for x in permutation_values if x <= observed) / n

p_value = min(tail_p * 2, 1.0)


# Write result
with open(output_file, "w") as out:
    out.write(f"Number of permutations: {n}\n")
    out.write(f"Observed overlap: {observed:.4f}%\n")
    out.write(f"Mean of permutations (expected): {mean_expected:.4f}%\n")
    out.write(f"Enrichment (observed / expected): {enrichment:.2f}x\n")
    out.write(f"Empirical p-value: {p_value:.6f}\n")