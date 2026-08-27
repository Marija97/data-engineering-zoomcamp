#!/usr/bin/env python
# coding: utf-8


import pandas as pd
from sqlalchemy import create_engine
from tqdm.auto import tqdm


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


def run():
    """Ingest NYC taxi data into PostgreSQL database."""

    # Prepare data url
    year, month = 2021, 1
    prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow'
    url = f'{prefix}/yellow_tripdata_{year}-{month:02d}.csv.gz'


    # Create Database connection
    pg_user, pg_pass, pg_host, pg_port, pg_db = 'root', 'root', 'localhost', 5432, 'ny_taxi'
    engine = create_engine(f'postgresql+psycopg://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}')


    # Read all of the available data with parsed types into an iterator of data chunks
    chunksize = 100000
    df_iter = pd.read_csv(
        url,
        dtype=dtype,
        parse_dates=parse_dates,
        iterator=True,
        chunksize=chunksize
    )
   
    # Ingest data into target table in chunks with a progress bar 
    target_table = 'yellow_taxi_data'
    first = True

    for df_chunk in tqdm(df_iter):
        if (first):
            # Create the table
            df_chunk.head(0).to_sql(name=target_table, con=engine, if_exists='replace')
            first = False

        # Insert the data chunk into the target table
        df_chunk.to_sql(name=target_table, con=engine, if_exists='append')




if __name__ == '__main__':
    run()

