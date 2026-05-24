import psycopg2
import openpyxl
import numpy as np
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
import random
import string
from datetime import datetime
from sqlalchemy import create_engine, select, Table, MetaData
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

json_file_path = r"config//credentials_ora_Element_Ass.json"
with open(json_file_path, "r") as f:
    credentials = json.load(f)

# get credentials username, password and database
USERNAME = credentials["USERNAME"]
PASSWORD = credentials["PASSWORD"]
DATABASE = credentials["DATABASE"]

#conString= f'DRIVER={{Oracle dans Ora12c_home64}};DBQ={DATABASE};Uid={USERNAME};Pwd={PASSWORD}'

host = 'worsgbdndxce10.prod.local'
user = 'APPEA01'
pwd = 'APPEA01'
service = 'assl00d1.mef.gouv.qc.ca'
port = 1521
import getpass
import oracledb

connection = oracledb.connect(
    user="APPEA01",
    password="APPEA01",
    dsn="worsgbdndxce10.prod.local/assl00d1.mef.gouv.qc.ca")
#engine = create_engine('oracle://APPEA01:APPEA01@worsgbdndxce10.prod.local:1521/assl00d1.mef.gouv.qc.ca')


#DF_EA.to_sql(output_table, engine, index=False, if_exists='append')
table_name="LOI11"
df_Loi = pd.read_excel('RA_LOI.xlsx', sheet_name='RA_LOI',index_col =None,header=None)
print(df_Loi)
#df_Loi.to_sql(name=table_name, con=connection, index=False, if_exists='replace') #replace cx_oracle is required !! Install issue ??
with connection.cursor() as cursor:
    cursor.executemany("insert into LOI (ID_LOI, ATIF, CD_ADM, NOM_LOI) VALUES (:1,:2,:3,:4)", df_Loi) 
    cursor.commit()

SQL = 'SELECT * FROM ARTICLE_LOI'

#df_ora = pd.read_sql(SQL, con=connection)
#print(df_ora)

