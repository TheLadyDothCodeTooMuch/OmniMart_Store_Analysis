import pandas as pd
from sqlalchemy import create_engine
import pymysql
from extract import generate_customers, generate_orders, generate_products, save_to_csv


TABLE_NAMES = ['dim_products', 'fact_orders', 'dim_customers']

def get_engine():
    user = 'admin'
    password = 'password'
    host = '127.0.0.1'
    port = 3306
    database = 'omnimart'

    connection_url = (
        "mysql+pymysql://{0}:{1}@{2}:{3}/{4}".format(
            user, password, host, port, database
        )
    )
    return create_engine(connection_url)


def load_database(df, table_name):
    engine = get_engine()
    try:
        # uses if_exists='replace' so previous history is deleted
        df.to_sql(table_name, engine, if_exists="replace", index=False)
        print(f"{table_name} loaded successfully.")
    except Exception as other_error:
        print(f"Error: Could not load {table_name} data to SQL server: {other_error}")


def main():
    print("Generating and extracting data...")

    df_customers = generate_customers()
    df_products = generate_products()
    df_orders = generate_orders(200000, df_products)

    save_to_csv(df_products, df_customers, df_orders)

    all_dataframes = {
        "bronze_dim_customers": df_customers,
        "bronze_dim_products": df_products,
        "bronze_fact_orders": df_orders
    }

    for tables, df in all_dataframes.items():
        load_database(df, tables)


if __name__ == "__main__":
    main()
