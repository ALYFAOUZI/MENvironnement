import csv
import pandas as pd
import re
from IPython.display import display, HTML
import psycopg2
import gc
from sqlalchemy import create_engine, select, Table, MetaData
from datetime import datetime
# pip install psycopg2  to be used in postgres connection
#In_Filepath = 'C:\\Users\\foual05\\Prototype_STH\\R4403_150915095029.csv'
try:      
    gc.collect()
    #print('1: test-{date:%Y-%m-%d_%H:%M:%S}.txt'.format( date=datetime.datetime.now() )    )
    In_Filepath = 'Test_file.MON'
    T = {'dr': 3,'dch':0, 'dcv':2,'hr': 4, 'hch':0, 'hcv':2, 'fr': 5, 'fch':0, 'fcv':2  }

    with open(In_Filepath, 'r') as csvfile:
        csv_reader  = csv.reader(csvfile, delimiter=',', quotechar='|')
        csv_reader  = csv.reader(csvfile, delimiter=',', quotechar='|')
    
        #for row in csv_reader :
        csv_reader_pd = csv_reader
        i = 0
        #df =  list(csv_reader_pd)[55:57]
        #pd.set_option('display.max_columns',None)
        #print(df)
        for row in list(csv_reader)[1:55]:
            #print(row)
            if (len(row))!=0:
                v = row[0]
                #print(row[0])
                if i==T['dr']:
                    print(v.strip().split()[T['dch']])
                    print(v.strip().split()[T['dcv']])
                    p_date = v.strip().split()[T['dcv']]
                if i==T['hr']:
                    print(v.strip().split()[T['hch']])
                    print(v.strip().split()[T['hcv']])
                    p_time = v.strip().split()[T['hcv']]
                if i==T['fr']:
                    print(re.sub(' ','',v).split()[T['fch']][0:8])
                    print(re.sub(' ','',v).split()[T['fch']][9:255])
                    fname = re.sub(' ','',v).split()[T['fch']][9:255]
                    p_path = fname
                    print(fname.split("\\")[6])
                    p_barrage = fname.split("\\")[6]
                    print(fname.split("\\")[8])
                    p_fname = fname.split("\\")[8]
                    #fname.find('x00')
                    ind = fname.index('X00')
                    #print(ind)
                    X_lieu = fname[ind:ind+8]
                    #print('X_lieu')
                    print(X_lieu)
                    #print(re.sub(' ','',v).split()[T['fcv']])
                    #print(row[0].strip(' \t\n\r'))
                    #print(re.sub(' ','',row[0]))
                i=i+1
                #break
    #data = pd.read_csv(In_Filepath, nrows=11)
    csvfile.close()  
    columns =  ['DATE_MESURE','TIME_MESURE','Pression','Temperature']
    df1 = pd.read_csv(In_Filepath, skiprows=53, skipfooter=1 ,encoding='unicode_escape', names = columns, delimiter= r'\s+') # skipfooter=2, sep = ' ', header=None,
    #print(df1)
    print('----------------------------')
    df_nb_rows = df1.shape[0]
    print(df1.shape[0]) # Gives number of rows
    print(df1.shape[1]) # Gives number of columns

    v_id = '99'
    v_file_name=p_fname
    
    now = datetime.now()
    v_load_dt = now.strftime("%Y-%m-%d %H:%M:%S")
    df2 = df1[["DATE_MESURE", "TIME_MESURE","Pression"]]
    df2['CODE_MESURE'] = 'PRESSION'
    df2['FILE_ID'] = v_id
    df2['FILE_NAME'] = p_fname
    df2['LOAD_DT'] = now.strftime("%Y-%m-%d %H:%M:%S")

    df2.rename(columns={'Pression': 'MESURE'}, inplace=True)

    #print(df2)

    df3 = df1[["DATE_MESURE", "TIME_MESURE","Temperature"]]
    df3['CODE_MESURE'] = 'TEMPERATURE'
    df3['FILE_ID'] = v_id
    df3['FILE_NAME'] = p_fname
    df3['LOAD_DT'] = now.strftime("%Y-%m-%d %H:%M:%S")
    df3.rename(columns={'Temperature': 'MESURE'}, inplace=True)
    #print(df3)

    #print(df2)
    #print(df.iloc[:,:2])
    #print(df[df.columns[1]])
    csvfile.close()
    conn = psycopg2.connect(database = "postgres", 
                            user = "postgres", 
                            host= 'localhost',
                            password = "postgres",
                            port = 5432)
    conn.autocommit = True
    SQL_QRY =  """
    select * from public.File_Measures
    ;
    """
    #df = pd.read_sql_query(SQL_QRY,conn)
    #print(df)
    DATABASE_URL='postgresql://postgres:postgres@localhost:5432/postgres'
    engine = create_engine(DATABASE_URL)
    metadata = MetaData()
    metadata.reflect(bind=engine)
    df2.to_sql('File_Measures', engine, index=False, if_exists='append')  # use replace to create the table
    df3.to_sql('File_Measures', engine, index=False, if_exists='append')  # use replace to create the table
    #random_emails_table = Table('File_Measures', metadata, autoload_with=engine)

    cur =conn.cursor()
    
    v_file_path=p_path
    v_prod_date=p_date
    v_barrage =p_barrage
    v_instrument ='Not Defined'
    v_lieu=X_lieu
    v_prod_time= p_time
    v_nb_rows=df_nb_rows
    v_nb_rows_str = str(v_nb_rows)
    v_statut = 'SUCCESS'
    print('v_file_name  = ' + v_file_name)
    print('v_file_path  = ' + v_file_path)
    print('v_prod_date  = ' + v_prod_date)
    print('v_barrage  = ' + v_barrage)
    print('v_lieu  = ' + v_lieu)
    print('v_prod_time  = ' + v_prod_time)
    print('v_nb_rows  = ' + str(v_nb_rows))



    SQL_Journal = """
    insert into  public.file_logs values (
    '""" + v_id + """'  ,
    '""" + v_file_name +  """' ,
    '""" + v_file_path +  """' ,
    '""" + v_prod_date +  """' ,
    '""" + v_barrage +  """' ,
    '""" + v_instrument +  """' ,
    '""" + v_lieu +  """' ,
    '""" + v_prod_time +  """' ,
    '""" + v_nb_rows_str +  """' ,
    '""" + v_statut +  """',
    '""" + v_load_dt +  """'
    )
    ;
    """
    #print (SQL_Journal)
    cur.execute(SQL_Journal)
    conn.commit
    count = cur.rowcount
    print(count, "Record inserted successfully into log table")
    cur.close() 
except (Exception, psycopg2.Error) as error:
    print("Failed to insert record into log table", error)
    raise
    #except Exception, e :
    #print "Error message : {}".format(e)
finally:
    # closing database connection.
    if conn:   
        conn.close()