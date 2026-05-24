import pandas as pd
import json
import streamlit as st
import time
from sqlalchemy import create_engine
import psycopg2
import openpyxl
from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError

# Create a connection to existing DB
connection = psycopg2.connect(
	database = 'postgres',
	user = 'postgres',
	password = 'postgres',
	host = 'localhost',
	port = '5432'
)

st.set_page_config(layout="centered", page_title="Data Editor", page_icon="🧮")
st.title("Postgres Table Editor ")
#st.title("Table Editor ❄️")
st.caption("This is a demo of the `st.experimental_data_editor`.")
engine = create_engine("postgresql://postgres:postgres@localhost:5432/postgres")
def get_dataset():
    # load messages df

    #df = pd.read_sql_query('select * from public.Entit_data_Obj_Infos',con=connection)
    df = pd.read_sql_query('select * from public.Entit_data_Obj_Infos',con=engine)
    #df = connection.table("Entit_data_Obj_Infos")

    return df

dataset = get_dataset() 

def process_change():
    editor_state = st.session_state.get("dynamic_editor",{})
    edited = editor_state.get("edited_rows",{})
    added =  editor_state.get("added_rows",[])
    deleted =editor_state.get("deleted_rows",[])
#edited = st.data_editor(dataset, width="stretch", num_rows="dynamic", hide_index=True, on_change=process_change, key="dynamic_editor")
with st.form("data_editor_form"):
    st.caption("Edit the dataframe below")
    edited = st.data_editor(dataset, use_container_width=True, num_rows="dynamic")
    
    submit_button = st.form_submit_button("Submit")
#con = engine.connect()
if submit_button:
    try:
        #Note the quote_identifiers argument for case insensitivity
        #connection.write_pandas(edited, "Entit_data_Obj_Infos", overwrite=True, quote_identifiers=False)
        #edited = st.data_editor(dataset, use_container_width=True, num_rows="dynamic")
        edited.to_sql('public.Entit_data_Obj_Infos', engine, if_exists='append') #replace
        #con.commit
        st.success("Table updated")
        time.sleep(5)
    except SQLAlchemyError as e:
        print(f"Database error: {e}")
        #st.warning("Error updating table")
    #display success message for 5 seconds and update the table to reflect what is in Snowflake
    #st.experimental_rerun()
        