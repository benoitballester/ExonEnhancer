import json

# Load the JSON data from the file
with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/allGeneCounts.json', 'r') as file:
    data = json.load(file)

# Filter the data based on project_id containing "TCGA"
filtered_data = []
for item in data:
    # Iterate through the cases for each item
    for case in item['cases']:
        if 'TCGA' in case['project']['project_id']:
            # If TCGA is found, add the item to the filtered list and break out of the inner loop
            filtered_data.append(item['file_id'])
            break  # This ensures each item is added only once, even if it has multiple cases matching the condition

# Now filtered_data contains only the items where a case's project_id includes 'TCGA'
# You can proceed with your analysis or save the filtered data to a new file

with open('/home/mouren/Data/variants/tcga_MC3/normal_barcodes/allTCGA_GeneCounts_fileID.txt', 'w') as file:
    for item in filtered_data:
        file.write(str(item) + '\n')