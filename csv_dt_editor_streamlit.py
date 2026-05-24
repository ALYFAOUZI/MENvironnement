import streamlit as st
import pandas as pd


csvfn = 'data.csv'

def update(edf):
    edf.to_csv(csvfn, index=False)
    load_df.clear()
    

@st.cache_data(ttl='1d')
def load_df():
    return pd.read_csv(csvfn)


df = load_df()
edf = st.data_editor(df)
st.button('Save', on_click=update, args=(edf, ))