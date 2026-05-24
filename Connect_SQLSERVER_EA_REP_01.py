# ------Purpose: The following code connect the SQL database Entreprise Architect Repository  Extract the tables and attributes with metadata 
# Write the output to a csv file using panda dataframe
#-------Author: Faouzi Ali
#-------Date: November 26TH 2024
#-------Project: TNO
#-------Scope: Data Architecture
"""
Connects to a SQL database using pyodbc
"""
import pyodbc
import pandas as pd
from pandas import DataFrame
from datetime import datetime

#The following parameter will be provided as input string to avoid security issues
SERVER = 'S00SQP20\PROD_01'
DATABASE = 'SPARXSYSTEM'
USERNAME = 'APPEAS01'
PASSWORD = 'p@ppsku26f!' 
conString = f'DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
conn = pyodbc.connect(conString)
cursor = conn.cursor()
#SQL_QUERY = """
#SELECT top 17 NAME FROM [dbo].[t_package];
#"""
# The following variable could be input parameters 
Current_dt = datetime.now().strftime("_%Y_%m_%d_%H_%M_%S.csv")
S_SYS = 'STH'
S_TABLE = 'TH_TRANC_FINNC'
S_FILE_OUTPUT = 'C:\\Users\\foual05\\Prototype_STH\\EA.csv' 
S_FILE_OUTPUT_DT = 'C:\\Users\\foual05\\Prototype_STH\\EA_' + S_SYS + '_' +Current_dt  + '.csv' 
SQL_QRY =  """
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
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p3.name = '""" + S_SYS +  """'
and package_p1.name = --'STH_Physique'
'Logical Data Model'
--and class.name = '""" + S_TABLE +  """'
order by package.name,
class.name ,
 a.name  
 ;
 """
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