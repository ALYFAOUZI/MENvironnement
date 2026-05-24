# ------Purpose: The following code compare the content of the 2 input files in 2 ways and generate 2 input files
#-------Author: Faouzi Ali.
#-------Date: November 18 TH 2024. Updated November 29TH 2024 
#-------Project: TNO.
#-------Scope: Data Architecture.


# Input files to compare in 2-ways
In_File1path = 'C:\\Users\\foual05\\Prototype_STH\\STH_Tables_P.csv'
In_File2path ='C:\\Users\\foual05\\Prototype_STH\\STH_Tables_S.csv'
#Output files as result of difference in 2-ways
Out_File3path = 'C:\\Users\\foual05\\Prototype_STH\\Table_P_Minus_S.csv'
Out_File4path = 'C:\\Users\\foual05\\Prototype_STH\\Table_S_Minus_P.csv'

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


In_File1path = 'C:\\Users\\foual05\\Prototype_STH\\STH_Columns_P.csv'
In_File2path ='C:\\Users\\foual05\\Prototype_STH\\STH_Columns_S.csv'
#Output files as result of difference in 2-ways
Out_File3path = 'C:\\Users\\foual05\\Prototype_STH\\Columns_P_Minus_S.csv'
Out_File4path = 'C:\\Users\\foual05\\Prototype_STH\\Columns_S_Minus_P.csv'

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
