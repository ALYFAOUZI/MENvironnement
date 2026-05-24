import pandas as pd
import json
import streamlit as st
import time
from sqlalchemy import create_engine
import psycopg2
import openpyxl
from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError
import pyodbc
import numpy as np
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


STR_EA_UNIQ_TABLE = """
;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  tobj.name AS ENTITY_NAME,
        objprop.value AS TABLE_NAME -- , atg.VALUE as COLUMN_NAME  
		,PKG_NAME,
		FULL_PATH
		,count(1) over (partition by  objprop.value) as NBR_Tab_Duppliquee
        FROM PackHierarchy , t_object tobj
		--,COUNT (objprop.value) OVER (PARTITION BYobjprop.value)
		--, t_attribute att
		, t_objectproperties objprop
		--, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        --and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
       -- and att.id = atg.ElementID
      --  and atg.Property = 'Code'
        --AND atg.VALUE = 'COLONNE_%'
		--and objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME --,COLUMN_NAME
		        ;
       
"""


STR_EA_Catalog = """

;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  tobj.name AS ENTITY_NAME,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME  ,PKG_NAME,
		FULL_PATH
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'

"""

STR_EA_TABLES = """

 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value AS TABLE_NAME
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = objprop.Object_ID
        order by TABLE_NAME
"""


SQL_EA_NN_SA = """
;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Modele conceptuel de données - MCDs' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT PKG_NAME, --PKG_ID, 
		d.name AS DIAGRAM_NAME, TT.VALUE as TABLE_PHYSIQUE, t.NAME AS CONNECTOR_NAME,
		(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_END
        FROM PackHierarchy , t_diagram d, T_CONNECTOR T , t_connectortag TT, t_diagramlinks dl
		where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
		and d.Package_ID = PKG_ID
		and UPPER(D.NAME) NOT LIKE '%SOURCE%'
		AND T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
AND TT.Property = 'Code'
--and d.name = 'GBP_Gestion des Barrages'-- 'SEBP_Securite et entretien des barrages_cible'
and TT.VALUE is not null
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
"""


SQL_EA_ASSOC_CLASS = """
SELECT * FROM (
SELECT D.name as DIGARMA_NAME , t.name AS Connector_name,
(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_end
FROM T_CONNECTOR T , t_diagramlinks dl, t_diagram d -- , t_connectortag TT
WHERE 
 dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
--and d.name =  'GBP_Gestion des Barrages'--'SEBP_Securite et entretien des barrages_cible'
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
AND T.Connector_Type ='Association' and T.SubType = 'Class'
--and T.Connector_ID = TT.ElementID
--and TT.Property = 'Code'
AND t.name is not null
) V WHERE ENTITY_START NOT LIKE '%XXXXX%'
AND ENTITY_END NOT LIKE '%XXXXX%'
AND ENTITY_START NOT LIKE '%YYYYY%'
AND ENTITY_END NOT LIKE '%YYYYY%'
AND UPPER(DIGARMA_NAME) NOT LIKE '%SOURCE%'
ORDER BY DIGARMA_NAME

"""


# Create a connection to existing DB
connection = psycopg2.connect(
	database = 'postgres',
	user = 'postgres',
	password = 'postgres',
	host = 'localhost',
	port = '5432'
)

st.set_page_config(layout="centered", page_title="Data Editor", page_icon="🧮")
st.title("Resulats en fonction des criteres")
#st.title("Table Editor ❄️")
st.caption("Details:")

# Inject custom CSS to change the font size and style of the tab labels
st.markdown(
    """
    <style>
    .stTabs [data-baseweb="tab"] button {
        font-size: 16px !important;
        font-family: "Helvetica", sans-serif !important;
        background-color: green;
    }
    </style>
    """,
    unsafe_allow_html=True,
)



tab1, tab2, tab3, tab4, tab5, tab6, tab7 = st.tabs(["🕓 Inventaire BD Sources & EA", "🕓⚠️ Ecart BD et EA-Tables","🕓⚠️ Ecart BD & EA-Attributs", "✈️ EA-Catalgue Enitiés","✈️⚠️ EA-Valider Unicité Entité","✈️ EA-Assciations N:N Sans Attributs", "✈️ EA-Classe d'associations N:N avec Attributs"])

engine = create_engine("postgresql://postgres:postgres@localhost:5432/postgres")
def get_dataset():
    # load messages df

    #df = pd.read_sql_query('select * from public.Entit_data_Obj_Infos',con=connection)
    df = pd.read_sql_query('select * from public.daily_results',con=engine)
    #df = connection.table("Entit_data_Obj_Infos")
    df_ecart = pd.read_sql_query('select * from public."Diff_Table"',con=engine)

    return df
df_ecart = pd.read_sql_query('select * from public."Diff_Table"',con=engine)

df_system =  pd.read_sql_query('SELECT DISTINCT "CODE_SYSTEME" FROM public.daily_results',con=engine)
df_db_type =  pd.read_sql_query('SELECT DISTINCT "DB_TYPE" FROM public.daily_results',con=engine)
df_database  =  pd.read_sql_query('SELECT DISTINCT "DB_SOURCE" FROM public.daily_results',con=engine)
df_table = pd.read_sql_query('SELECT DISTINCT "TABLE_NAME" FROM public.daily_results',con=engine)
df_col = pd.read_sql_query('SELECT DISTINCT "COLUMN_NAME" FROM public.daily_results',con=engine)
df_exists = pd.read_sql_query('SELECT DISTINCT "Exist" FROM public."Diff_Table"',con=engine)
#DF_EA_TABLES = pd.read_sql_query('SELECT DISTINCT "TABLE_NAME" ,"SYSTEME" FROM public.daily_results',con=engine) 

STR_SQL_TABLES = 'SELECT DISTINCT "TABLE_NAME" ,"SYSTEME" FROM public.daily_results'



dataset = get_dataset() 

st.sidebar.title("Gestion des metadonnees")
st.sidebar.header("Criteres de Recherche")

str_SQL = 'select * from public.daily_results' 
str_SQL_Ecart = 'select * from public."Diff_Table"'
st.set_page_config(layout="wide")
with st.sidebar.form(key ='Form1'):
    
    option_sys_code = st.multiselect('Code de Systeme', df_system) #st.selectbox('Choose a system code', df_system)
    option_db_type =  st.multiselect('Type de base de donnees', df_db_type)
    option_database = st.multiselect('Base de donnees', df_database) #, default = 'SPARXSYSTEM'
    option_table = st.multiselect('Table Physique', df_table)
    option_col = st.multiselect('Colonne Physique', df_col)
    option_exist = st.multiselect('Type Ecart', df_exists)

    
    
    submit_button11 = st.form_submit_button("Rechercher")
    #st.write(option_sys_code)
    #st.write(option_db_type)
    #st.write(option_database)
    #str_SQL_fommat = ", ".join(f"'{option}'" for option in option_database)

    str_sys_code_fommat = ", ".join(f"'{option}'" for option in option_sys_code)
    str_option_db_type_fommat = ", ".join(f"'{option}'" for option in option_db_type)
    str_db_fommat = ", ".join(f"'{option}'" for option in option_database)
    str_table_format = ", ".join(f"'{option}'" for option in option_table)
    str_col_format = ", ".join(f"'{option}'" for option in option_col)
    str_exist_format = ", ".join(f"'{option}'" for option in option_exist)
    
    SQl_Condition_sys_code = ''
    if len(option_sys_code)==0:
         #str = str + ' WHERE  "DB_SOURCE"  IN (' + chr(39) +  'SPARXSYSTEM' + chr(39) + ' )'
         SQl_Condition_sys_code = SQl_Condition_sys_code + '  ( "CODE_SYSTEME"  IS NOT NULL ) '
    else:
         SQl_Condition_sys_code = SQl_Condition_sys_code + ' ( "CODE_SYSTEME" IN (' + str_sys_code_fommat  +  ') )'
    
    SQl_Condition_db_type = ''
    if len(option_db_type)==0:
         #str = str + ' WHERE  "DB_SOURCE"  IN (' + chr(39) +  'SPARXSYSTEM' + chr(39) + ' )'
         SQl_Condition_db_type = SQl_Condition_db_type + '  ( "DB_TYPE"  IS NOT NULL ) '
    else:
         SQl_Condition_db_type = SQl_Condition_db_type + ' ( "DB_TYPE" IN (' + str_option_db_type_fommat  +  ') )'
    
    SQl_Condition_database = ''
    if len(option_database)==0:
         #str = str + ' WHERE  "DB_SOURCE"  IN (' + chr(39) +  'SPARXSYSTEM' + chr(39) + ' )'
         SQl_Condition_database = SQl_Condition_database + '  ( "DB_SOURCE"  IS NOT NULL ) '
    else:
         SQl_Condition_database = SQl_Condition_database + ' ( "DB_SOURCE" IN (' + str_db_fommat  +  ') )'
    
    SQl_Condition_table = ''
    SQL_Condition_Ea_Catalog_tab=''
    SQL_Condition_tables = ''
    SQL_Condition_tables_NN_SA = ''
    if len(option_table)==0:
         #str = str + ' WHERE  "DB_SOURCE"  IN (' + chr(39) +  'SPARXSYSTEM' + chr(39) + ' )'
         SQl_Condition_table = SQl_Condition_table + '  ( "TABLE_NAME"  IS NOT NULL ) '
         SQL_Condition_Ea_Catalog_tab = SQL_Condition_Ea_Catalog_tab + '  ( tobj.name  IS NOT NULL ) '
         SQL_Condition_tables = SQL_Condition_tables + '  ( "TABLE_NAME"   IS NOT NULL ) '
         SQL_Condition_tables_NN_SA = SQL_Condition_tables_NN_SA + '  ( TT.VALUE  IS NOT NULL ) '
    else:
         SQl_Condition_table = SQl_Condition_table + ' ( "TABLE_NAME" IN (' + str_table_format  +  ') )'
         SQL_Condition_Ea_Catalog_tab = SQL_Condition_Ea_Catalog_tab + '  ( objprop.value   IN (' + str_table_format  +  ') )'
         SQL_Condition_tables = SQL_Condition_tables + '  ( "TABLE_NAME"   IN (' + str_table_format  +  ') )'
         SQL_Condition_tables_NN_SA = SQL_Condition_tables_NN_SA + '  ( TT.VALUE   IN (' + str_table_format  +  ') )'

    SQl_Condition_col = ''
    SQL_Condition_Ea_Catalog_col=''
    if len(option_col)==0:
         #str = str + ' WHERE  "DB_SOURCE"  IN (' + chr(39) +  'SPARXSYSTEM' + chr(39) + ' )'
         SQl_Condition_col = SQl_Condition_col + '  ( "COLUMN_NAME"  IS NOT NULL ) '
         SQL_Condition_Ea_Catalog_col = SQL_Condition_Ea_Catalog_col + '  ( objprop.value  IS NOT NULL ) '
    else:
         SQl_Condition_col = SQl_Condition_col + ' ( "COLUMN_NAME" IN (' + str_col_format  +  ') )'
         SQL_Condition_Ea_Catalog_col = SQL_Condition_Ea_Catalog_col + ' (  atg.VALUE IN (' + str_col_format  +  ') )'
    
    SQl_Condition_exist = ''
    if len(option_exist)==0:
         #str = str + ' WHERE  "DB_SOURCE"  IN (' + chr(39) +  'SPARXSYSTEM' + chr(39) + ' )'
         SQl_Condition_exist = SQl_Condition_exist + '  ( "Exist"  IS NOT NULL ) '
    else:
         SQl_Condition_exist = SQl_Condition_exist + ' ( "Exist" IN (' + str_exist_format  +  ') )'


    #st.write(len(option_database))
    #if len(option_database)==0:
         #str = str + ' WHERE  "DB_SOURCE"  IN (' + chr(39) +  'SPARXSYSTEM' + chr(39) + ' )'
         #str_SQL = str_SQL + ' WHERE  "DB_SOURCE"  IS NOT NULL '
    #else:
         #str_SQL = str_SQL + ' WHERE  "DB_SOURCE" IN (' + str_SQL_fommat  +  ')'
    
    str_SQL = str_SQL + ' WHERE '  + SQl_Condition_sys_code + ' AND ' +  SQl_Condition_db_type  + ' AND ' +  SQl_Condition_database  + ' AND ' +  SQl_Condition_table + ' AND ' +  SQl_Condition_col

    str_SQL_Ecart = str_SQL_Ecart + ' WHERE '  + SQl_Condition_sys_code +  ' AND '  +  SQl_Condition_table + ' AND ' +  SQl_Condition_col + ' AND ' +  SQl_Condition_exist
   
    STR_EA_Catalog = STR_EA_Catalog + ' AND ' + SQL_Condition_Ea_Catalog_tab  +  ' AND ' + SQL_Condition_Ea_Catalog_col  + '  order by TABLE_NAME,COLUMN_NAME'
    STR_SQL_TABLES = STR_SQL_TABLES + ' WHERE ' + SQL_Condition_tables 
    
    STR_EA_NN_SA = SQL_EA_NN_SA  + ' AND ' + SQL_Condition_tables_NN_SA
   
DF_EA_TABLES = pd.read_sql_query(STR_SQL_TABLES,con=engine)    
DF_EA_TABLES_TOCOMP =  DF_EA_TABLES[DF_EA_TABLES['SYSTEME'] == 'Entreprise Architect']
DF_BD_TABLE_TOCOMP =   DF_EA_TABLES[DF_EA_TABLES['SYSTEME'] != 'Entreprise Architect']

DF_EA_TABLES_TOCOMP = DF_EA_TABLES_TOCOMP['TABLE_NAME']
DF_BD_TABLE_TOCOMP =  DF_BD_TABLE_TOCOMP['TABLE_NAME']

DF_ECART_BD_EA_TABL_Ecart = pd.merge(DF_EA_TABLES_TOCOMP, DF_BD_TABLE_TOCOMP, how='outer', indicator='Exist')

DF_ECART_BD_EA_TABL_Ecart["Exist"] = np.where(DF_ECART_BD_EA_TABL_Ecart['Exist'] =='both' , 'Commun EA et BD',
                         np.where(DF_ECART_BD_EA_TABL_Ecart['Exist'] =='right_only' , 'BD Seulement', 'EA Seulement'))
    #st.write(str_SQL)
    #st.write(str_SQL_fommat)
    #df = pd.read_sql_query('select * from public.Entit_data_Obj_Infos',con=connection)
    #df = pd.read_sql_query('select * from public.daily_results',con=engine)
df = pd.read_sql_query(str_SQL,con=engine)
dfe = pd.read_sql_query(str_SQL_Ecart,con=engine)
    #df = connection.table("Entit_data_Obj_Infos")
DF_EA_Catalog =  pd.read_sql_query(STR_EA_Catalog,conn_SQL)
DF_EA_UNIQ_TABLE =  pd.read_sql_query(STR_EA_UNIQ_TABLE,conn_SQL)
DF_SQL_EA_NN_SA =  pd.read_sql_query(STR_EA_NN_SA,conn_SQL)
# import spark for window function-------------------------------------------
#from pyspark.sql import Window
#from pyspark.sql.functions import avg
STR_EA_UNIQ_TABLE_filter =DF_EA_UNIQ_TABLE[DF_EA_UNIQ_TABLE["NBR_Tab_Duppliquee"]!=1]
#aggregated = DF_EA_UNIQ_TABLE.groupby('TABLE_NAME').agg ({'TABLE_NAME': 'count'})

#DF_Merge = pd.merge( DF_EA_UNIQ_TABLE, aggregated, how="inner", on= ["TABLE_NAME"])
#-------------------------------------------

DF_EA_ASSOC_CLASS =  pd.read_sql_query(SQL_EA_ASSOC_CLASS,conn_SQL)




#df = pd.read_csv("data/titanic.csv")
def highlight(s):
        if  (s.Exist  == 'Commun EA et BD' ):
             return ['background-color: green']*len(s)
        elif (s.Exist == 'EA Seulement'):
              return ['background-color: red']*len(s)
        else: 
              return ['background-color: orange']*len(s)

        #return f'background-color: {color}'
     

def color_coding(row):
    #return ['background-color:red'] * len(row) if row.Exist == 'Commun EA et BD' else ['background-color:green'] * len(row)
    return ['background-color:green'] * len(row) if row.Exist == 'Commun EA et BD' else ['background-color:green'] * len(row)


import streamlit as st
#  #FFFFFF #F0F2F6  #90D5FF #000000
# 
st.markdown("""
<style>
     
	

	.stTabs [data-baseweb="tab"] {
		height: 50px;
          white-space: pre-wrap;
		
          color: #000000;
		border-radius: 4px 4px 0px 0px;
		gap: 1px;
		padding-top: 10px;
		padding-bottom: 10px;
    }

	.stTabs [aria-selected="true"] {
  		background-color: #00008b ;
          color: #FFFFFF;
          
	}

</style>""", unsafe_allow_html=True)



with tab1:
    


    edited = st.data_editor(df, use_container_width=True, num_rows="dynamic", width="stretch",hide_index=None)
    with st.form("data_editor_form"):
            #st.caption("Liste des enregistrements:")
            dataset = get_dataset() 
            #edited = st.data_editor(dataset, use_container_width=True, num_rows="dynamic")
            submit_button = st.form_submit_button("Recharger les donnees -  A faire")
    if submit_button:
            try:
                #Note the quote_identifiers argument for case insensitivity
                #connection.write_pandas(edited, "Entit_data_Obj_Infos", overwrite=True, quote_identifiers=False)
                #edited = st.data_editor(dataset, use_container_width=True, num_rows="dynamic")
                #edited.to_sql('public.Entit_data_Obj_Infos', engine, if_exists='append') #replace
                #con.commit
                #st.success("Table updated")
                #time.sleep(5)
                time.sleep(1)
            except SQLAlchemyError as e:
                print(f"Database error: {e}")

with tab2:    
     
     
     if len(option_exist)!=0:
        
         
         DF_ECART_BD_EA_TABL_Ecart =    DF_ECART_BD_EA_TABL_Ecart[ DF_ECART_BD_EA_TABL_Ecart["Exist"].isin(option_exist)]
     
     #edited = st.data_editor(DF_ECART_BD_EA_TABLE, use_container_width=True, num_rows="dynamic", width="stretch",hide_index=None)
     st.dataframe(DF_ECART_BD_EA_TABL_Ecart.style.apply(highlight, axis = 1), hide_index=None)

   

with tab3:
     
     st.dataframe(dfe.style.apply(highlight, axis = 1), hide_index=None)
     #st.dataframe(dfe.style.applymap(color_survived, subset=["CODE_SYSTEME"]))
    
    
     #edited = st.data_editor(dfe, use_container_width=True, num_rows="dynamic", width="stretch")  # with data editor
     #st.write(dfe)   

with tab4:
     edited = st.data_editor(DF_EA_Catalog, use_container_width=True, num_rows="dynamic", width="stretch",hide_index=None)

with tab5:
     edited = st.data_editor(STR_EA_UNIQ_TABLE_filter, use_container_width=True, num_rows="dynamic", width="stretch",hide_index=None)

with tab6:
      edited = st.data_editor(DF_SQL_EA_NN_SA, use_container_width=True, num_rows="dynamic", width="stretch",hide_index=None)
     
with tab7:
      edited = st.data_editor(DF_EA_ASSOC_CLASS, use_container_width=True, num_rows="dynamic", width="stretch",hide_index=None)
     