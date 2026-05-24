import pyodbc
import pandas as pd
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

data = {
    "GBP_SRC1":{"system":"GBP","Code":"GP","Database": "APPL00S1", "username": "envproc", "password": "envproc" }  ,  
    "GBP_SRC2":{"system":"GBP","Code":"GP","Database": "APPL00S2", "username": "envproc", "password": "envproc"   },
    "REP_SRC1":{"system":"REP","Code":"BP","Database": "APPL00S5", "username": "envproc", "password": "envproc"  }  } 
    


for outer_key, inner_dict in data.items():
    #print(f"Outer Key: {outer_key}")
    print(inner_dict["Code"])
    print(inner_dict["Database"])
    print(inner_dict["username"])
    print(inner_dict["password"])

    # Loop through the inner dictionary
    #for inner_key, inner_value in inner_dict.items():
        #print(f"  {inner_key}: {inner_value}")
       
    
     
  
   
        

'''
 conString= f'DRIVER={{Oracle dans Ora12c_home64}};DBQ={DATABASE};Uid={USERNAME};Pwd={PASSWORD}'
        conn = pyodbc.connect(conString)
        cursor = conn.cursor()    
#data_sources =  {'GBP':{'Code': 'GP', 'Database': 'APPLS001', 'Username':'envpro', 'Password':'envpro'}, 'REP':{'Code': 'BP', 'Database': 'APPLS001', 'Username':'envpro', 'Password':'envpro'}}

#print (data_sources)
#for outer_key, inner_dict in data_sources.items():
    #print (data_sources[outer_key]["Code"] )
    #print (data_sources[outer_key]["Database"] )
    #print (data_sources[outer_key]["Username"] )
    #print (data_sources[outer_key]["Password"] )
    #print(f"Outer Key: {outer_key}")
    #for inner_key, value in inner_dict.items():
        #print(f"  Inner Key: {inner_key}, Value: {value}")



data = {
    "GBP": {
        "SRC": {
           { "Database": "APPL00S1",
            "username": "envproc",
            "username": "envproc"
        } 
        ,
        {
            "Database": "APPL00S2",
            "username": "envproc",
            "username": "envproc"
        }
    }},
    "REP": {
        "SRC": {
            "Database": "APPL00S5",
            "username": "envproc",
            "username": "envproc"
        }
        }
        }


for system , dat in data.items():
    print (system)
    #print(dat)
    for x,y in dat.items():
        #print(x)
        #print(y)
        for v, z in y.items():
            #print(v)
            #print(z)
            #sys.exit()
            if v == 'Database':
                w = y["Database"]
                print(w)
    


for system in data:
    print(system)
    for source in data[system]:
        print(source)
        for detail in data[system][source]:
            print(detail)
            

    
for system, src in data.items():
    print(f"System: {system}")
    #print(src["SRC"])
    for  src1, det in src.items():
        #print(f"  src: {src1}")
        print(det)
        for k, v in det.items():
                print(v)
                 #print(f"System: {system}")
                 #print(f"  src: {src1}")
                 #print(f"Database: {k}, username: {v}")
                print('incha ALLAH')
                 



 data_sources =  {
    'system':{
        {
        'Code': 'GP', 
        'SRC': {
            {
                'Database':'APPLS001', 
                'Username':'envpro', 
                'Password':'envpro'
                }, 
                {
                'Database':'APPLS001', 
                'Username':'envpro', 
                'Password':'envpro'
                }
                }
        }, 
        {                        
        'Code': 'BP', 
        'SRC':{
            'Database': 'APPLS001', 
            'Username':'envpro', 
            'Password':'envpro'
            }
        }
                }
                }

#print(data_sources["GBP"]["SRC"]["Database"])
#for outer_key, inner_dict in data_sources.items():
    #print (data_sources[outer_key]["Code"] )
    #for inner_key, value in inner_dict.items():
        #print (data_sources[inner_key]["Database"] )
        #print (data_sources[inner_key]["Username"] )
        #print (data_sources[inner_key]["Password"] )

'''
