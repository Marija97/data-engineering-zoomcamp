#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


# Prepare data url
prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/'
url = f'{prefix}/yellow_tripdata_2021-01.csv.gz'
url


# In[3]:


# Specify the data types
dtype = {
    "VendorID": "Int64",
    "passenger_count": "Int64",
    "trip_distance": "float64",
    "RatecodeID": "Int64",
    "store_and_fwd_flag": "string",
    "PULocationID": "Int64",
    "DOLocationID": "Int64",
    "payment_type": "Int64",
    "fare_amount": "float64",
    "extra": "float64",
    "mta_tax": "float64",
    "tip_amount": "float64",
    "tolls_amount": "float64",
    "improvement_surcharge": "float64",
    "total_amount": "float64",
    "congestion_surcharge": "float64"
}

parse_dates = [
    "tpep_pickup_datetime",
    "tpep_dropoff_datetime"
]


# In[4]:


# Read all of the available data with parsed types
df = pd.read_csv(url, dtype=dtype, parse_dates=parse_dates)


# In[5]:


# Display first rows
df.head()


# In[6]:


# Check data types
df.dtypes


# In[7]:


# Check data shape
df.shape


# In[8]:


len(df)


# In[9]:


# Create Database Connection
from sqlalchemy import create_engine
engine = create_engine('postgresql+psycopg://root:root@localhost:5432/ny_taxi')


# In[10]:


engine


# In[11]:


# Get DDL Schema
print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))


# In[12]:


get_ipython().system('uv add psycopg2-binary')


# In[13]:


# Create the Table
# Note: head(n=0) makes sure we only create the table, we don't add any data yet.
# if the table exists, this line drops it and creates new table with no data
df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')


# In[14]:


# Collect data for ingestion into an iterator of chunks
df_iter = pd.read_csv(
    prefix + 'yellow_tripdata_2021-01.csv.gz',
    dtype=dtype,
    parse_dates=parse_dates,
    iterator=True,
    chunksize=100000
)


# In[15]:


get_ipython().system('uv add tqdm')


# In[16]:


# Ingest data in chunks, with a progress bar from tqdm
from tqdm.auto import tqdm

for df_chunk in tqdm(df_iter):
    df_chunk.to_sql(name="yellow_taxi_data", con=engine, if_exists="append")
    print("Inserted chunk:", len(df_chunk))


# In[ ]:




