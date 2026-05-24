import csv
import pandas as pd
import re
from IPython.display import display, HTML
import psycopg2
import gc
from sqlalchemy import create_engine, select, Table, MetaData
from datetime import datetime

conn = psycopg2.connect(database = "postgres", 
                            user = "postgres", 
                            host= 'localhost',
                            password = "postgres",
                            port = 5432)
cur = conn.cursor()
with open('Load_csv_postgresql.csv', 'r', encoding="mbcs") as f:
    # Notice that we don't need the csv module.
    next(f) # Skip the header row.
    cur.copy_from(f, table='tgt_csv_file', sep=',',null='') #,null='None' , columns=None,null='ND' issue with the caracter enclosing the data fields!!!
    

conn.commit()