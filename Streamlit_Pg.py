import pandas as pd
import json
import streamlit as st
import time

import psycopg2
import openpyxl

# Create a connection to existing DB
connection = psycopg2.connect(
	database = 'postgres',
	user = 'postgres',
	password = 'postgres',
	host = 'localhost',
	port = '5432'
)

st.set_page_config(layout="centered", page_title="Data Editor", page_icon="🧮")
#st.title("Postgres Table Editor ")
st.title("Snowflake Table Editor ❄️")
st.caption("This is a demo of the `st.experimental_data_editor`.")

def get_dataset():
    # load messages df
    df = pd.read_sql_query('select * from public.Entit_data_Obj_Infos',con=connection)
    #df = connection.table("Entit_data_Obj_Infos")

    return df

dataset = get_dataset()

with st.form("data_editor_form"):
    st.caption("Edit the dataframe below")
    #edited = st.data_editor(dataset, use_container_width=True, num_rows="dynamic")
    edited = st.data_editor(dataset, width="stretch", num_rows="dynamic")
    submit_button = st.form_submit_button("Submit")

if submit_button:
    try:
        #Note the quote_identifiers argument for case insensitivity
        connection.write_pandas(edited, "Entit_data_Obj_Infos", overwrite=True, quote_identifiers=False)
        st.success("Table updated")
        time.sleep(5)
    except:
        st.warning("Error updating table")
    #display success message for 5 seconds and update the table to reflect what is in Snowflake
    #st.experimental_rerun()
        