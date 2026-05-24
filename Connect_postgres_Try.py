import pandas as pd

#worksheet = pd.read_excel('Sys_Fonc_Travail.xlsx', sheet_name = 'Fonc_Aff')
#print(worksheet['B4'].iloc[0])
#print(worksheet)
import re # for regular expression
import openpyxl 
import xlrd

# excel_data_df = pd.read_excel('Sys_Fonc_Travail.xlsx', sheet_name='Fonc_Aff',index_col =None,header=None)


import psycopg2

connection = psycopg2.connect(database="postgres", user='postgres', password='postgres', host="localhost", port=5432)

cursor = connection.cursor()

sql_context ="""
select 
    sm.first_name
from 
     public.persons sm
where 
    sm.first_name not like '%test%'
group by 
    sm.first_name
"""


cursor.execute(sql_context)

# Fetch all rows from database
record = cursor.fetchall()

print("Data from Database:- ", record)