# ------Purpose: The following code connect the Oracle database and  Extract the tables and columns with proprties for the required system
# Write the output to two  csv files.
#-------Author: Faouzi Ali.
#-------Date: November 18 TH 2024. Updated November 29TH 2024 
#-------Project: TNO.
#-------Scope: Data Architecture.
#Connects to a Oracle database using pyodbc

import pyodbc
import pandas as pd
import csv
import string as f
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
v_sys_suffix = "'TH_%'"
SQL_Get_Tables ="SELECT TABLE_NAME  from ALL_TABLES WHERE TABLE_NAME LIKE " + v_sys_suffix + " ORDER BY TABLE_NAME"
cursor.execute(SQL_Get_Tables)
#print (cursor.fetchall())
rows_tab = cursor.fetchall()
print("Total Number of Tables is :  ", len(rows_tab))
#Debug the tabe Name
#for row_tab in rows_tab:
    #print ( row_tab.TABLE_NAME )


F_Table_Name = 'STH_Tables.csv'
with open('STH_Tables.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    field = ["Table Name"]
    writer.writerow(field)
    writer.writerows(rows_tab)
file.close()

SQL_Get_Columns =" SELECT T.TABLE_NAME , ATC.COLUMN_NAME,ATC.DATA_TYPE,ATC.DATA_LENGTH,ATC.DATA_PRECISION,ATC.DATA_SCALE,ATC.NULLABLE,ATC.data_default ,DCC.COMMENTS FROM   ALL_TABLES T INNER JOIN ALL_TAB_COLUMNS ATC ON (ATC.OWNER = T.OWNER AND ATC.TABLE_NAME = T.TABLE_NAME ) LEFT OUTER JOIN  ALL_COL_COMMENTS DCC ON  (ATC.OWNER = DCC.OWNER AND ATC.TABLE_NAME = DCC.TABLE_NAME AND ATC.COLUMN_NAME = DCC.COLUMN_NAME) WHERE  T.OWNER = 'DBA_ORACLE' AND T.TABLE_NAME  LIKE " + v_sys_suffix + " ORDER BY T.TABLE_NAME,ATC.COLUMN_NAME " 

cursor.execute(SQL_Get_Columns)
#print (cursor.fetchall())
#rows = cursor.fetchmany(100000)
rows_col = cursor.fetchall()
print("Total Number of Columns is :  ", len(rows_col))

F_Column_Name = 'STH_Culumns.csv'
with open('STH_Culumnss.csv', 'w', newline='') as file:
    writer = csv.writer(file,delimiter='|')
   
    field = ["TABLE_NAME","COLUMN_NAME", "DATA_TYPE", "DATA_LENGTH" , "DATA_PRECISION", "DATA_SCALE", "NULLABLE", "DEFAULT_VALUE", "COMMENTS"]
    writer.writerow(field)
    #for r in rows_col:
        #writer.writerow(r)
    writer.writerows(rows_col,)
#file.flush
file.close()

conn.close()
""" 
file1= open('C:\\Users\\foual05\\Prototype_STH\\STH_Tables.csv', 'r')
datafile= open('C:\\Users\\foual05\\Prototype_STH\\STH_poweramc.txt', 'r')
print(datafile)
for line in datafile:
        if line in file1:
            print ('%s found' % line)
        else:
            print ('%s not found' % line)

 """          
#set(open('C:\Users\foual05/STH_Tables.csv', 'r')) - set(open('C:\Users\foual05/STH_poweramc.txt'))

  #for row in rows:
        #print(row[0])
        #writer.writerows(row)
    #cursor.close()  
#df = pd.read_sql(SQL, conn)
#df = pd.read_sql_query(sa.text("SELECT TABLE_NAME  from DBA_TABLES WHERE TABLE_NAME LIKE 'TH_%'"), conn)
#df





#import oracledb as cx_Oracle
#import getpass
#cx_Oracle.init_oracle_client()
#conn = cx_Oracle.connect('envproc/envproc@APPL00S1')
#conn = cx_Oracle.connect('envproc/envproc@worsgbdnaxce10.prod.local:1521/appl00s1.mef.gouv.qc.ca')
#pw = getpass.getpass("Enter password: ")
#conn = cx_Oracle.connect(user="envproc", password=pw, dsn="worsgbdnaxce10.prod.local/appl00s1.mef.gouv.qc.ca")

#CONN_INFO = {
    #'host': 'worsgbdnaxce10.prod.local',
    #'port': 1521,
    #'user': 'envproc',
    #'psw': 'envproc',
    #'service': 'appl00s1.mef.gouv.qc.ca',
#}
#CONN_STR = '{user}/{psw}@{host}:{port}/{service}'.format(**CONN_INFO)
#conn = cx_Oracle.connect(CONN_STR)


#curs = conn.cursor()

#curs.execute('select * from table1;')
#print (curs.description)
#for row in curs:
   #print (row)
#conn.close()


