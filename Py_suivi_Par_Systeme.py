import pandas as pd
import streamlit as st
#worksheet = pd.read_excel('Sys_Fonc_Travail.xlsx', sheet_name = 'Fonc_Aff')
#print(worksheet['B4'].iloc[0])
#print(worksheet)
import re # for regular expression
import openpyxl 
import xlrd
path = 'Suivi_Systemes_Arch_Donnees_v01.xlsx'
#excel_data_df = pd.read_excel(path, sheet_name='Planif Par Systeme',index_col =None,header=None)
excel_data_df = pd.read_excel('Suivi_Systemes_Arch_Donnees_v01.xlsx', sheet_name='Planif Par Systeme',index_col =None, header =0) # header=None, ,skiprows=1


#print(len(excel_data_df))
print(excel_data_df)
#print (excel_data_df.columns)
#st.write("Alhamdo le ALLAH")
df = excel_data_df["PD"]
print(df)
df1 = (df=='X')
print(df1.sum())
#df = excel_data_df["Analyse"]
#print(df)