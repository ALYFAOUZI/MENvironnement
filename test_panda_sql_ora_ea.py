# ------Purpose: The following code connect the Oracle database and  connect the EA SQL Database and compare table and columns.
# Write the output to two  csv files.
#-------Author: Faouzi Ali.
#-------Date: October 10 TH 2025.  
#-------Project: TNO.
#-------Scope: Data Architecture.
#Connects to a Oracle database using pyodbc

import pyodbc
import pandas as pd
import csv
import string as f
import json
import pyodbc
import pandas as pd
from pandas import DataFrame
from datetime import datetime
import getpass
from getpass import getpass
import json

json_file_path = r"config//credentials_ora.json"
with open(json_file_path, "r") as f:
    credentials = json.load(f)

# get credentials username, password and database
USERNAME = credentials["USERNAME"]
PASSWORD = credentials["PASSWORD"]
DATABASE = credentials["DATABASE"]


#conn = pyodbc.connect('DRIVER={Oracle dans Ora12c_home64};DBQ=APPL00S1;Uid=envproc;Pwd=envproc;MAXROWS=1000000')
conString= f'DRIVER={{Oracle dans Ora12c_home64}};DBQ={DATABASE};Uid={USERNAME};Pwd={PASSWORD}'
#test the connection
conn = pyodbc.connect(conString)
cursor = conn.cursor()

#Use the v_sys_suffix for system as parameter
#v_sys_suffix = "'GB_%'"
v_sys_suffix = "GB"
v_sys_suffix_serach = "'GB_%'"

Search_sys = v_sys_suffix 
SQL_Get_Tab_Col ="SELECT TABLE_NAME, COLUMN_NAME from ALL_TAB_COLUMNS WHERE TABLE_NAME LIKE " + v_sys_suffix_serach  + " ORDER BY TABLE_NAME, COLUMN_NAME"
cursor.execute(SQL_Get_Tab_Col)
#print (cursor.fetchall())
rows_tab = cursor.fetchall()
print("Total Number of Tables is :  ", len(rows_tab))


df_ora = pd.read_sql(SQL_Get_Tab_Col, con=conn)
print(df_ora)
conn.close()

json_file_path = r"config//credentials_sql.json"
with open(json_file_path, "r") as f:
    credentials = json.load(f)

USERNAME = credentials["USERNAME"]
PASSWORD = credentials["PASSWORD"]
DATABASE = credentials["DATABASE"]
SERVER = credentials["SERVER"]


conString = f'DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
conn = pyodbc.connect(conString)
cursor = conn.cursor()

SQL_EA= """
 select 
V.table_BD AS TABLE_NAME ,
atg.value AS COLUMN_NAME
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
objprop1.value  Table_BD , oBJ.Object_ID
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
)
) v , t_attribute a, t_attributetag atg
where 
a.Object_ID = v.Object_ID
and 
v.package_parent not like 'Source Migration de Power Designer%'
and v.table_BD LIKE 'GB_%'
and a.ID = atg.ElementID
and atg.Property ='Code'
order by 
V.table_BD ,
atg.value 
;
 ;
 """

DF_EA =  pd.read_sql_query(SQL_EA,conn)
print(df_ora)
conn.close()

diff = pd.merge(DF_EA, df_ora, how='outer', indicator='Exist')
#diff = DF_EA.compare(df_ora)
diff_filter = diff[diff['Exist'] != 'both']
diff_filter = diff_filter[["TABLE_NAME", "COLUMN_NAME"]]
diff_right = diff[diff['Exist'] == 'right_only']
diff_right = diff_right[["TABLE_NAME", "COLUMN_NAME"]]
diff_left = diff[diff['Exist'] == 'left_only']
diff_left = diff_left[["TABLE_NAME", "COLUMN_NAME"]]

print(diff_filter)

Current_dt = datetime.now().strftime("_%Y_%m_%d_%H_%M_%S")
S_FILE_ORA = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + v_sys_suffix + '_DB_' + Current_dt   +'.csv' 
S_FILE_EA = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + v_sys_suffix + '_EA_' + Current_dt   +'.csv' 
S_FILE_DIFF = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + v_sys_suffix + '_ALL_DIFF_' + Current_dt   +'.csv' 
S_FILE_DIFF_Right = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + v_sys_suffix + '_DB_ONLY_' + Current_dt   +'.csv' 
S_FILE_DIFF_Left = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + v_sys_suffix + '_EA_ONLY_' + Current_dt   +'.csv' 


df_ora.to_csv(S_FILE_ORA, sep='|', header=True, index=False)
DF_EA.to_csv(S_FILE_EA, sep='|', header=True, index=False)
diff_filter.to_csv(S_FILE_DIFF, sep='|', header=True, index=False)
diff_right.to_csv(S_FILE_DIFF_Right, sep='|', header=True, index=False)
diff_left.to_csv(S_FILE_DIFF_Left, sep='|', header=True, index=False)