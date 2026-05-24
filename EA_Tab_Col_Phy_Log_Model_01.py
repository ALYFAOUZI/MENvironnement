# ------Purpose: The following code connect the SQL database Entreprise Architect Repository  Extract the tables and attributes with metadata 
# Write the output to a csv file using panda dataframe.
#-------Author: Faouzi Ali.
#-------Date: November 26TH 2024. Updated November 29TH 2024
#-------Project: TNO.
#-------Scope: Data Architecture.
#Connects to a SQL database using pyodbc
import pyodbc
import pandas as pd
from pandas import DataFrame
from datetime import datetime
import getpass
from getpass import getpass
import json

#This code coud be used  to provide the password as input or other parameters
#PASSWORD = getpass('Please enter your password')


json_file_path = r"config//credentials_sql.json"
with open(json_file_path, "r") as f:
    credentials = json.load(f)

# get credentials username, password and database
USERNAME = credentials["USERNAME"]
PASSWORD = credentials["PASSWORD"]
DATABASE = credentials["DATABASE"]
SERVER = credentials["SERVER"]


conString = f'DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
conn = pyodbc.connect(conString)
cursor = conn.cursor()

Current_dt = datetime.now().strftime("_%Y_%m_%d_%H_%M_%S")
S_SYS = 'STH'
S_TABLE = 'TH_TRANC_FINNC'

# # Input parameter should be PHYSICAL or LOGICAL
INPUT_MOD_LEVEL = input('-------What is your model level : PHYSICAL or LOGICAL?-------------------\n')
if INPUT_MOD_LEVEL =='PHYSICAL':
    S_MODEL_LEVEL = 'STH_Physique'
elif INPUT_MOD_LEVEL =='LOGICAL':
    S_MODEL_LEVEL = 'Logical Data Model'

# Generate the query dynamically according to the input parameters
STR1 =  """
select 
UPPER(class.name) as 'Table Name',
 UPPER(a.name) as 'Column Name'
 """

STR2= """
select 
--package_p1.name as 'Parent Folder' , 
--package_p2.name as 'Parent Folder1',
package_p3.name as 'Parent Folder2',
--package.name as 'Data Source' ,
class.name as 'Table Name',
 a.name as 'Column Name',
 a.notes,
 a.Type as 'Type',
 a.length,
 a.Precision, 
 a.Scale, 
 a.Derived,
 a.[Default] as 'Default_Value',
 a.AllowDuplicates
"""

STR3= """
 from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p3.name = '""" + S_SYS +  """'
and package_p1.name = '""" + S_MODEL_LEVEL +  """'
--'Logical Data Model'
--and class.name = '""" + S_TABLE +  """'
order by package.name,
class.name ,
 a.name  
 ;
 """
# We can enhance the code by checking the input parameters
# Input parameter should be TABLES or COLUMNS
INPUT_GRAIN_LEVEL = input('What is your Granularity : TABLES or COLUMNS Details?-------------------\n')
if INPUT_GRAIN_LEVEL =='TABLES':
    SQL_QRY = STR1 + STR3
    
elif INPUT_GRAIN_LEVEL =='COLUMNS':
   SQL_QRY = STR2 + STR3


S_FILE_OUTPUT = 'C:\\Users\\foual05\\Prototype_STH\\EA_' + S_SYS + '_' + INPUT_MOD_LEVEL + '_' + INPUT_GRAIN_LEVEL + '.csv' 
S_FILE_OUTPUT_DT = 'C:\\Users\\foual05\\Prototype_STH\\EA_' + S_SYS + '_' +Current_dt  + '_' + INPUT_MOD_LEVEL +  '_' + INPUT_GRAIN_LEVEL +'.csv' 

# SQL query 


#cursor.execute(SQL_QUERY)
#cursor.execute(SQL_STH)
#rows = cursor.fetchall()
df = pd.read_sql_query(SQL_QRY,conn)
#df = DataFrame(cursor.fetchall())
#col_name = list(df.columns.values)
#print(rows)
#print(col_name)
print(df)
df.to_csv(S_FILE_OUTPUT_DT, sep='|', header=True, index=False)
conn.close()