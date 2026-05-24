import csv

# Function to search for strings from one file in another file 
def search_strings_in_file(strings_file, target_file, output_file_diff): 
    # Read the strings from the first file 
    with open(strings_file, 'r') as f: 
        strings_to_search = f.read().splitlines()  # Read lines and strip newline characters 
 
    # Read the content of the second file 
    with open(target_file, 'r') as f: 
        target_content = f.read()  # Read the entire content 
 
    # Search for each string in the target content 
    Not_found_strings = {} 
    with open(output_file_diff, 'w', newline='') as file:
        writer = csv.writer(file)
        #field = ["Table Name found in Database but not in Power AMC"]
        #writer.writerow(field)
        #string1 = ''
        for string in strings_to_search: 
            if not string in target_content: 
                #string1 = string1+ string + '\r\n'
                print(string)
                Not_found_strings[string] = False  # String not found in target file 
                writer.writerow(string)
        #writer.writerow(Not_found_strings)
        #string1 = string1.replace(",","")
        #writer.writerow(string1)
    return Not_found_strings 
 
# Example usage 
strings_file = 'strings.txt'  # File containing strings to search 
target_file = 'target.txt'      # File where to search for strings 
 
Notfound12 = search_strings_in_file('C:\\Users\\foual05\\Prototype_STH\\STH_Tables.csv', 'C:\\Users\\foual05\\Prototype_STH\\STH_poweramc.txt', 'C:\\Users\\foual05\\Prototype_STH\\TAB_DB_DIFF_PAMC.csv') 
#print("Not Found strings:", Notfound12) 

print('----------------------------------------------------------------------------------------------------------')
Notfound21 = search_strings_in_file('C:\\Users\\foual05\\Prototype_STH\\STH_poweramc.txt','C:\\Users\\foual05\\Prototype_STH\\STH_Tables.csv','C:\\Users\\foual05\\Prototype_STH\\TAB_PAMC_DIFF_DB.csv') 
#print("Not Found strings:", Notfound21) 

