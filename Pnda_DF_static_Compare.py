
import pandas as pd
import sys
if sys.version_info[0] < 3:
    from StringIO import StringIO
else:
    from io import StringIO
import pandas as pd

DF1 = StringIO("""Date       Fruit  Num  Color 
2013-11-24 Banana 22.1 Yellow
2013-11-24 Orange  8.6 Orange
2013-11-24 Apple   7.6 Green
2013-11-24 Celery 10.2 Green
""")
DF2 = StringIO("""Date       Fruit  Num  Color 
2013-11-24 Banana 22.11 Yellow
2013-11-24 Orange  8.6 Orange
2013-11-24 Apple   7.6 Green
2013-11-24 Celery 10.2 Green
2013-11-25 Apple  22.1 Red
2013-11-25 Orange  8.6 Orange""")


df1 = pd.read_table(DF1, sep='\s+')
df2 = pd.read_table(DF2, sep='\s+')
#%%
dfs_dictionary = {'DF1':df1,'DF2':df2}
df=pd.concat(dfs_dictionary)
df.drop_duplicates(keep=False)
pd1=pd.concat([df1,df2]).drop_duplicates(keep=False)
#print(pd1)
pd2 = df1.merge(df2, how = 'inner' ,indicator=False)
#print(pd2)

iff_df = pd.merge(df1, df2, how='outer', indicator='Exist')

print(iff_df)
