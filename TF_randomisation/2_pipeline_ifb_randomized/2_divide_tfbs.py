import pandas as pd
import numpy as np
import sys

file = sys.argv[1]

df_tf = pd.read_csv(file, sep="\t",header=None)

df_tf[0] = df_tf[0].apply(lambda x: f"chr{x}" if isinstance(x, (int, float)) or x.isdigit() else x) #for tair10

#get list of IDs
unique_ids = df_tf[3].unique()

# Split the unique IDs into 100 groups
groups = np.array_split(unique_ids, 100)

# Create a dictionary to map each ID to its group number
id_to_group = {id_: i for i, group in enumerate(groups) for id_ in group}

# Add a new column to the dataframe to assign each row to a group based on its ID
df_tf['Group'] = df_tf[3].map(id_to_group)

# Ensure groups have the same value in the first column
# Find maximum existing group number
max_group_number = max(id_to_group.values())

# Iterate over each group
for group_number in range(max_group_number + 1):
    # Subset rows in the current group
    group_rows = df_tf[df_tf['Group'] == group_number]
    
    # Check if there are multiple values in the first column
    unique_first_col_values = group_rows[0].unique()
    
    if len(unique_first_col_values) > 1:
        # Assign new group numbers based on the first column values
        for value in unique_first_col_values:
            max_group_number += 1
            # Update rows with this value in the first column to the new group number
            df_tf.loc[(df_tf['Group'] == group_number) & (df_tf[0] == value), 'Group'] = max_group_number


# Make dictionnary of nb of tf per elements 
value_counts = df_tf[3].value_counts().to_dict()
with open('/shared/projects/exonhancer/data/matching_tfbs/to_treat/nb_tf_per_elements.tsv', 'w') as file:
    for key, value in value_counts.items():
        file.write(f'{key}\t{value}\n')

# Save each group to a separate file
for group_num in range(max_group_number+1):
    group_df = df_tf[df_tf['Group'] == group_num]

    if group_df.empty:
        continue

    # Sort by the first column (0) and then numerically by the second column (1)
    group_df = group_df.sort_values(by=[0, 1], ascending=[True, True])

    group_df.drop(columns=['Group'], inplace=True)

    file_name = f"group_{group_num}"
    group_df.to_csv("/shared/projects/exonhancer/data/matching_tfbs/to_treat/remap/"+file_name,sep='\t',index=False,header=False,na_rep='NA')
