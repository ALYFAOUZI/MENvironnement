import pandas as pd
import re

# Read the plain text file
with open('Test_file.MON', 'r') as file:
    lines = file.readlines()

# Find the start and end indices of the Inspection Summary section
start_index = next(i for i, line in enumerate(lines) if line.startswith('411'))
end_index = next(i for i, line in enumerate(lines[start_index:]) if line.strip() == '') + start_index

# Extract column headings
columns = re.split(r' {2,}', lines[start_index].strip())

# Extract summary lines and split based on multiple spaces
summary_lines = [re.split(r' {2,}', line.strip()) for line in lines[start_index+2:end_index]]

# Create a DataFrame from the list of lists
df = pd.DataFrame(summary_lines, columns=columns)

# Remove the 'Total' row
df = df.drop('TOTAL', axis=1)

# Transpose the DataFrame, set the first row as column headers, and reset the index
df_transposed = df.transpose().reset_index()
df_transposed.columns = df_transposed.iloc[0]
df_transposed = df_transposed[1:].reset_index(drop=True)

# Print the resulting DataFrame
print(df)
# Print the transposed DataFrame
print(df_transposed)

# Get the sum of the 'Units Inspected' column
column_sum = df_transposed['Units Inspected'].astype(float).sum()
print(column_sum)