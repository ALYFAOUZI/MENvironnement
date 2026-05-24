# ------Purpose: The following code compare the content of the 2 input files in 2 ways and generate 2 input files
#-------Author: Faouzi Ali.
#-------Date: November 18 TH 2024. Updated November 29TH 2024 
#-------Project: TNO.
#-------Scope: Data Architecture.


# Input files to compare in 2-ways
In_File1path = 'C:\\Users\\foual05\\Prototype_STH\\EA_STH_PHY.csv'
In_File2path ='C:\\Users\\foual05\\Prototype_STH\\EA_STH_LOG.csv'
#Output files as result of difference in 2-ways
Out_File3path = 'C:\\Users\\foual05\\Prototype_STH\\PHY_MINUS_LOG.csv'
Out_File4path = 'C:\\Users\\foual05\\Prototype_STH\\LOG_MINUS_PHY.csv'

with open(In_File1path, 'r') as file1:
    with open(In_File2path, 'r') as file2:
        difference12 = set(file1).difference(file2)

difference12.discard('\n')

with open(Out_File3path, 'w') as file1_out:
    for line in difference12:
        file1_out.write(line)

with open(In_File1path, 'r') as file1:
    with open(In_File2path, 'r') as file2:
        difference21 = set(file2).difference(file1)

difference21.discard('\n')

with open(Out_File4path, 'w') as file2_out:
    for line in difference21:
        file2_out.write(line)