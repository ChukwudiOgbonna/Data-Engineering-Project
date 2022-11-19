#!/usr/bin/env python
# coding: utf-8

from unicodedata import name
import os
import argparse
import gzip
import pandas as pd
from sqlalchemy import create_engine
# we use argpase to parse arguments provided in CLI like host, username password to our python script when we run it in docker
#Equivalent to scanner.scan in java
#user,
# password,
# host, 
# port,
# database name,
# table name,
# url of CSV

def ingest():
    #parse all arguments
    user=os.getenv('username')
    password=os.getenv('password')
    host=os.getenv('host')
    port=os.getenv('port')
    db=os.getenv('database')
    table_name=os.getenv('tablename')
    url=os.getenv('url')
    csv_gz_name="output.csv.gz"
    csv_name="output.csv"

    # download the csv file and store in csv_name , use os.system to run CLI commands
    os.system(f"wget {url} -O {csv_name}") 
    
   


    # create engine/ connection to our database
    engine= create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")


    # split our data frame into chunks for batch processing into database
    df_iter = pd.read_csv(csv_name,iterator=True,chunksize=100000)

    df=next(df_iter)

    # format columns to timestamps
   

    # list out column names
    df.head(0)



    # create postgres column names from datafrae column names
    df.head(0).to_sql(name=table_name,con=engine,if_exists='replace')


    # append first data chunks to table
    df.to_sql(name=table_name,con=engine,if_exists='append')



    # append the remaning data chunks to the table 
    while True:
        df=next(df_iter)
        # format columns to time stamp
        
        # load data into our database
        df.to_sql(name=table_name,con=engine,if_exists='append')
        print('inserted another chunk')





if __name__ == '__main__':
    ingest()

    

    




# url
"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

