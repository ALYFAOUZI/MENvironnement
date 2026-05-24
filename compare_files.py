import csv
# Function to search for strings from one file in another file 
def search_strings_in_file(strings_file, target_file): 
    # Read the strings from the first file 
    with open(strings_file, 'r') as f: 
        strings_to_search = f.read().splitlines()  # Read lines and strip newline characters 
 
    # Read the content of the second file 
    with open(target_file, 'r') as f: 
        target_content = f.read()  # Read the entire content 
 
    # Search for each string in the target content 
    Not_found_strings = {} 
    for string in strings_to_search: 
        if not string in target_content: 
            print(string)
            Not_found_strings[string] = False  # String not found in target file 
 
    return Not_found_strings 
 
# Example usage 
strings_file = 'strings.txt'  # File containing strings to search 
target_file = 'target.txt'      # File where to search for strings 
 
Notfound12 = search_strings_in_file('C:\\Users\\foual05\\Prototype_STH\\STH_Tables.csv', 'C:\\Users\\foual05\\Prototype_STH\\STH_poweramc.txt') 
print("Not Found strings:", Notfound12) 

print('----------------------------------------------------------------------------------------------------------')
Notfound21 = search_strings_in_file('C:\\Users\\foual05\\Prototype_STH\\STH_poweramc.txt','C:\\Users\\foual05\\Prototype_STH\\STH_Tables.csv') 
print("Not Found strings:", Notfound21) 

with open('Diff_STH_Tables.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    field = ["Table Name found in Database but not in Power AMC"]
    writer.writerow(field)
    
    writer.writerows(Notfound12)

    field = ["Table Name found in Power AMC  but not in Database "]
    writer.writerow(field)
    writer.writerows(Notfound21)