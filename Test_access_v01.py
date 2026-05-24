import pyodbc as pyo
import pandas as pd
print("..opnening")

import pyodbc
our_drivers = "{Microsoft Access Driver (*.mdb, *.accdb)}"
our_filepath = "C:/Users/MyPc/Documents/AUS_be.accdb"
pyodbc.connect(driver=our_drivers, dbq=our_filepath)

db_driver = '{Driver={Microsoft Access Driver (*.mdb, *.accdb)}'
#db_path ='C:\\Users\\foual05\\Downloads\\AUS_be.accdb'
db_path ='AUS_be.accdb'
cnn_string = (rf'DRIVER={db_driver};'
            rf'DBQ={db_path};')
cnn=pyo.connect(cnn_string)

df = pd.read_sql(sql="select * from test_table", con=cnn)
print(df)

cnn.close()






