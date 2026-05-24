# ------Purpose: The following code connect the Oracle database and  connect the EA SQL Database and compare table and columns.
# Write the output to two  csv files.
#-------Author: Faouzi Ali.
#-------Date: October 10 TH 2025.  
#-------Project: TNO.
#-------Scope: Data Architecture.
#Connects to a Oracle database using pyodbc
import psycopg2
import openpyxl
#import pyodbc
import numpy as np
#import pandas as pd
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
import sys
#import pandas as pd
import random
import string
from datetime import datetime
from sqlalchemy import create_engine, select, Table, MetaData
from sqlalchemy import create_engine
from sqlalchemy.engine import URL


# Create a connection to existing DB
# conn_postgres = psycopg2.connect(
	# database = 'postgres',
	# user = 'postgres',
	# password = 'postgres',
	# host = 'localhost',
	# port = '5432'
# )

DATABASE_URL = URL.create(
    drivername="postgresql",
    username="postgres",
    password='postgres',
    host="localhost",
    database="postgres",
    port=5432
)

engine = create_engine(DATABASE_URL)
output_table = 'daily_results'



# Open a cursor object to perform database operations
#cur_postgres = conn_postgres.cursor()

json_file_path = r"config//credentials_ora.json"
with open(json_file_path, "r") as f:
    credentials = json.load(f)

# get credentials username, password and database
USERNAME = credentials["USERNAME"]
PASSWORD = credentials["PASSWORD"]
DATABASE = credentials["DATABASE"]
# get credentials username, password and database
#print(USERNAME)
#sys.exit() 
#data_sources =  {'GBP':{'Code': 'GP', 'Database': 'APPLS002', 'Username':'envproc', 'Password':'envproc'}, 'REP':{'Code': 'BP', 'Database': 'APPLS001', 'Username':'envpro', 'Password':'envpro'}}
#data_sources =  {'GBP':{'Code': 'GB', 'Database': 'APPL00S2', 'Username':'envproc', 'Password':'envproc'}, 'REP':{'Code': 'GB', 'Database': 'APPL00S3', 'Username':'envproc', 'Password':'envproc'}}

data_sources = {
    "GBP_SRC1":{"system":"GBP","code":'GB',"database": 'APPL00S2',  "dbtype": 'Oracle',"username": 'envproc', "password": 'envproc' }  ,  
    "GBP_SRC2":{"system":"GBP","code":'GB',"database": 'APPL00S3', "dbtype": 'Oracle',"username": 'envproc', "password": 'envproc'   },
    "REP_SRC1":{"system":"REP","code":'BP',"database": 'APPL00S1', "dbtype": 'Oracle',"username": 'envproc', "password": 'envproc' } ,
    "SEBP_SRC1":{"system":"SEBP","code":'SE',"database": 'APPL00S1', "dbtype": 'Oracle',"username": 'envproc', "password": 'envproc' } ,
    "HC_SRC1":{"system":"HC","code":'HC',"database": 'APPL00S1', "dbtype": 'Oracle',"username": 'envproc', "password": 'envproc' } 
      } 

json_file_path_SQL = r"config//credentials_sql.json"
with open(json_file_path_SQL, "r") as f:
    credentials_SQL = json.load(f)

USERNAME = credentials_SQL["USERNAME"]
PASSWORD = credentials_SQL["PASSWORD"]
DATABASE = credentials_SQL["DATABASE"]
SERVER = credentials_SQL["SERVER"]


conString_SQL = f'DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
conn_SQL = pyodbc.connect(conString_SQL)
cursor_SQL = conn_SQL.cursor()

pdf_sys = pd.DataFrame({'SYS_CODE': ['XX', 'YY']})
#pdf_sys = pd.DataFrame(columns=['SYS_CODE'])

for outer_key, inner_dict in data_sources.items():
    #print (data_sources[outer_key]["Code"] )
    #print (data_sources[outer_key]["Database"] )
    #print (data_sources[outer_key]["Username"] )
    #print (data_sources[outer_key]["Password"] )    
    SYSTEM = data_sources[outer_key]["system"]
    SYSTEM_CODE =data_sources[outer_key]["code"]
    USERNAME = data_sources[outer_key]["username"]
    PASSWORD = data_sources[outer_key]["password"]
    DATABASE = data_sources[outer_key]["database"]
    DBTYPE = data_sources[outer_key]["dbtype"]

    
    
    
    
    conString= f'DRIVER={{Oracle dans Ora12c_home64}};DBQ={DATABASE};Uid={USERNAME};Pwd={PASSWORD}'
    conn = pyodbc.connect(conString)
    cursor = conn.cursor()

    v_sys_suffix = SYSTEM_CODE
    v_sys_suffix_serach = SYSTEM_CODE + "_%"
    v_sys_suffix_serach_reg =  'REGEXP_LIKE(TABLE_NAME,' + chr(39) + '^' + SYSTEM_CODE + '_' + chr(39) + ')'
    
    #print (v_sys_suffix_serach)
    #SQL_Get_Tab_Col ="SELECT TABLE_NAME, COLUMN_NAME from ALL_TAB_COLUMNS WHERE TABLE_NAME LIKE " + "'" +v_sys_suffix_serach + "'" + " ORDER BY TABLE_NAME, COLUMN_NAME"
    SQL_Get_Tab_Col ="SELECT " + "'" + SYSTEM + "'" +  " AS SYSTEME ,"  + "'" + SYSTEM_CODE + "'" + " AS CODE_SYSTEME ," + "'" + DATABASE + "'" + " AS DB_SOURCE ," + "'" + DBTYPE +  "'" + " AS DB_TYPE ," +" TABLE_NAME, COLUMN_NAME from ALL_TAB_COLUMNS WHERE  NOT REGEXP_LIKE(TABLE_NAME,'_V_') AND "  +v_sys_suffix_serach_reg  + " ORDER BY TABLE_NAME, COLUMN_NAME"
    print(SQL_Get_Tab_Col)
    cursor.execute(SQL_Get_Tab_Col)
    #print (cursor.fetchall())
    rows_tab = cursor.fetchall()
    print("Total Number of Rows is :  ", len(rows_tab))
    print(SQL_Get_Tab_Col)
   

    df_ora = pd.read_sql(SQL_Get_Tab_Col, con=conn)

    df_ora.to_sql(output_table, engine, index=False, if_exists='append')
    print("'"+ SYSTEM_CODE + "'")
    print(pdf_sys['SYS_CODE'])
    #if not (pdf_sys['SYS_CODE'] == SYSTEM_CODE  ).any().any():
    print(pdf_sys.isin(["'"+ SYSTEM_CODE + "'"]).any().any())
    #if ("'"+ SYSTEM_CODE + "'"  not in pdf_sys.values ):
    if not (pdf_sys.isin(["'"+ SYSTEM_CODE + "'"]).any().any()):
        print('system code is '+ SYSTEM_CODE )
        pdf_sys_tmp = pd.DataFrame({'SYS_CODE': ["'" +SYSTEM_CODE +"'" ]})
        pdf_sys = pd.concat([pdf_sys, pdf_sys_tmp], ignore_index=True)
        #print(not (pdf_sys['SYS_CODE'] == "'" + SYSTEM_CODE +"'"  ).any())
        
    #if not (pdf_sys['SYS_CODE'] == "'" + SYSTEM_CODE +"'"  ).any():
        
        SQL_EA= """
        ;WITH PackHierarchy AS (
            SELECT PACKAGE_ID AS PKG_ID , Name AS PKG_NAME,  PARENT_ID AS PKG_PARID, 1 AS Level
            FROM T_PACKAGE
            WHERE NAME = 'Catalogue Entités de données' -- Start with top-level root
            AND Package_ID = 14233
            UNION ALL
            SELECT E.PACKAGE_ID, e.Name, e.PARENT_ID, eh.Level + 1
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.parent_id = eh.PKG_ID
        )
        SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name, 
        'Entreprise Architect' as SYSTEME ,
        """
        SQL_EA = SQL_EA  + "'" + SYSTEM_CODE + "'" 
        SQL_EA = SQL_EA + """
        AS CODE_SYSTEME , 'SPARXSYSTEM' AS DB_SOURCE, 'SQL Server' AS DB_TYPE,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg 
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id 
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        AND objprop.value LIKE
        """
        SQL_EA = SQL_EA + "'" + v_sys_suffix_serach +  "'"  
        SQL_EA = SQL_EA +     """
        order by TABLE_NAME,COLUMN_NAME
        ;
        """


        print(SQL_EA)
        
        DF_EA =  pd.read_sql_query(SQL_EA,conn_SQL)
        DF_EA.to_sql(output_table, engine, index=False, if_exists='append')
    

conn.close()
Ecart_table = 'Diff_Table'
#SQL_SYS_LIST = 'SELECT DISTINCT  CODE_SYSTEME FROM  public.daily_results '
#DF_SYS =  pd.read_sql_query(SQL_SYS_LIST,conn_SQL)
DF_TAB = pd.read_sql_table(output_table,engine)
DF_EA = DF_TAB[DF_TAB['SYSTEME'] == 'Entreprise Architect']
DF_EA = DF_EA[["CODE_SYSTEME","TABLE_NAME", "COLUMN_NAME"]]
DF_SYS = DF_TAB[DF_TAB['SYSTEME'] != 'Entreprise Architect']
DF_SYS = DF_SYS[["CODE_SYSTEME","TABLE_NAME", "COLUMN_NAME"]]
DF_TAB_SYS= DF_TAB['CODE_SYSTEME'].unique()
for system in DF_TAB_SYS:
     DF_EA_FILTER = DF_EA[DF_EA['CODE_SYSTEME'] == system]
     DF_SYS_FILTER = DF_SYS[DF_SYS['CODE_SYSTEME'] == system]
     diff = pd.merge(DF_EA_FILTER, DF_SYS_FILTER, how='outer', indicator='Exist')
    #diff = DF_EA.compare(df_ora)
     
     diff["Exist"] = np.where(diff['Exist'] =='both' , 'Commun EA et BD',
                         np.where(diff['Exist'] =='right_only' , 'BD Seulement', 'EA Seulement'))
     
     diff_filter = diff[diff['Exist'] == 'Commun EA et BD']
     diff_filter1 = diff_filter[['CODE_SYSTEME',"TABLE_NAME", "COLUMN_NAME", "Exist"]]
     diff_filter = diff_filter[['CODE_SYSTEME',"TABLE_NAME", "COLUMN_NAME"]]
     diff_filter1.to_sql(Ecart_table, engine, index=False, if_exists='append')
     
     diff_right = diff[diff['Exist'] == 'EA Seulement'] 
     diff_right1 = diff_right[['CODE_SYSTEME',"TABLE_NAME", "COLUMN_NAME", "Exist"]]
     diff_right = diff_right[['CODE_SYSTEME',"TABLE_NAME", "COLUMN_NAME"]]
     diff_right1.to_sql(Ecart_table, engine, index=False, if_exists='append')
     
     diff_left = diff[diff['Exist'] == 'BD Seulement']
     diff_left1 = diff_left[['CODE_SYSTEME',"TABLE_NAME", "COLUMN_NAME", "Exist"]]
     diff_left = diff_left[['CODE_SYSTEME',"TABLE_NAME", "COLUMN_NAME"]]
     diff_left1.to_sql(Ecart_table, engine, index=False, if_exists='append')

     Current_dt = datetime.now().strftime("_%Y_%m_%d_%H_%M_%S")
     S_FILE_ORA = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + system + '_DB_' + Current_dt   +'.csv' 
     S_FILE_EA = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + system + '_EA_' + Current_dt   +'.csv' 
     S_FILE_DIFF = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + system + '_ALL_DIFF_' + Current_dt   +'.csv' 
     S_FILE_DIFF_Right = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + system + '_DB_ONLY_' + Current_dt   +'.csv' 
     S_FILE_DIFF_Left = 'C:\\Users\\foual05\\Prototype_STH\\tmp\\' + system + '_EA_ONLY_' + Current_dt   +'.csv' 

     DF_SYS_FILTER.to_csv(S_FILE_ORA, sep='|', header=True, index=False)
     DF_EA_FILTER.to_csv(S_FILE_EA, sep='|', header=True, index=False)
     diff_filter.to_csv(S_FILE_DIFF, sep='|', header=True, index=False)
     diff_right.to_csv(S_FILE_DIFF_Right, sep='|', header=True, index=False)
     diff_left.to_csv(S_FILE_DIFF_Left, sep='|', header=True, index=False)


#conn.close()
conn_SQL.close()




'''

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


'''