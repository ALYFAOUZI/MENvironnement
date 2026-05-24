#import pyodbc

#conn = pyodbc.connect(r'Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=c:\Users\foual05\Downloads\AUS_be;')
#cursor = conn.cursor()
#cursor.execute('select * from tracking_sales')
   
#for row in cursor.fetchall():
    #print (row)
    
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

# Path to MS Access database file
path = r"c:\\Users\\foual05\\Downloads\\AUS_be" #.mdb or .accdb

# Name of Driver from Step 1
connection_str = r'Driver={Microsoft Access Driver (*.mdb, *.accdb)};'
connection_str += f'DBQ={path};'

# Create Connection
connection_url = URL.create("access+pyodbc", query={"odbc_connect": connection_str})
engine = create_engine(connection_url)