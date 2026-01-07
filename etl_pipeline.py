import email
import pandas as pd
import csv 
import mysql.connector
from mysql.connector import Error
from datetime import datetime
import re
import logging
from sqlalchemy import create_engine, text

DB_CONFIG = {
    "host": "Localhost",
    "user": "root",
    "password": "Karishma%4088",
    "database": "fleximart"
}
engine = create_engine("mysql+mysqlconnector://root:Karishma%4088@localhost:3306/fleximart")

with engine.begin() as conn:
    conn.execute(text("SET FOREIGN_KEY_CHECKS = 0"))
    conn.execute(text("TRUNCATE TABLE customers"))
    conn.execute(text("SET FOREIGN_KEY_CHECKS = 1"))

with engine.connect() as conn:
    print(" DB Connected successfully!")

#-- Reading CSV files
with open('customers_raw.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)
        

with open('products_raw.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)        
       

with open('sales_raw.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)   

#-- Extract function
def extract():
    customers = pd.read_csv('customers_raw.csv')
    products = pd.read_csv('products_raw.csv')
    sales = pd.read_csv('sales_raw.csv')

    print("Data extraction completed")
    return customers, products, sales

if __name__ == "__main__":
    customers, products, sales = extract()

    print(customers.to_string())
    print(products.to_string())
    print(sales.to_string())

def clean_phone(phone):
    if pd.isna(phone):
        return None
    phone = re.sub(r"[^0-9]", "", str(phone))
    return phone[-10:]

def clean_email(email):
    if pd.isna(email) or email == "<EMAIL>":
        return None
    return email.strip().lower()

#-- Transform function
def transform(customers, products, sales):

    # Standardize column names
    customers.columns = [col.strip().lower().replace(' ', '_') for col in customers.columns]
    products.columns = [col.strip().lower().replace(' ', '_') for col in products.columns]
    sales.columns = [col.strip().lower().replace(' ', '_') for col in sales.columns]    
    print("Column names standardized")

    # Remove duplicates
    customers.drop_duplicates(keep='first', inplace=True)
    products.drop_duplicates(keep='first', inplace=True)
    sales.drop_duplicates(keep='first', inplace=True)
    print("Duplicates removed")


    # standardize phone numbers
    customers['phone'] = customers['phone'].apply(clean_phone)

    # Handle missing values
    customers.fillna({'email': '<EMAIL>'}, inplace=True)    
    products.fillna({'price': products['price'].mean()}, inplace=True)
    sales.fillna({'quantity': 1}, inplace=True)     
    print("Data transformation completed")

    #standardize category names to lowercase    
    products['category'] = products['category'].str.lower()
    print("Category names standardized")

    # Convert registration_date to YYYY-MM-DD format
    customers["registration_date"] = pd.to_datetime(
    customers["registration_date"],
    errors="coerce",
    dayfirst=False)

    customers["registration_date"] = customers["registration_date"].dt.strftime("%Y-%m-%d")
    print("Registration dates standardized")

   # Remove duplicate transactions
    sales.drop_duplicates(subset=['transaction_id'], keep='first', inplace=True)
    print("Duplicate transactions removed")

    # Parse mixed date formats safely
    sales["transaction_date"] = pd.to_datetime(
    sales["transaction_date"],
    errors="coerce",
    dayfirst=True
    )
    # Standardize status
    sales["status"] = sales["status"].str.title()
    print("Transaction dates and status standardized")

    # Replace empty strings with None
    sales = sales.replace({"": None})


    # Clean emails
    customers["email"] = customers["email"].apply(
        lambda x: None if pd.isna(x) or x == "<EMAIL>" else x.strip().lower()
    )

    # Remove duplicate emails
    customers = customers.drop_duplicates(subset=["email"])

    customers["email"] = customers["email"].fillna("unknown@example.com")


    #Add surrogate key (auto increment id)
    customers.reset_index(inplace=True)
    customers.rename(columns={'index': 'customer_id'}, inplace=True)
    products.reset_index(inplace=True)
    products.rename(columns={'index': 'product_id'}, inplace=True)
        
     



    return customers, products, sales

if __name__ == "__main__":
    customers, products, sales = transform(customers, products, sales)
    print(customers.to_string())
    print(products.to_string())
    print(sales.to_string())

from sqlalchemy.exc import SQLAlchemyError


#-- Load function

def load(customers, products):
    print("Loading data into the database...")

     # Clean emails
    customers["email"] = customers["email"].apply(
        lambda x: None if pd.isna(x) or x == "<EMAIL>" else x.strip().lower()
    )

    # Remove duplicate emails
    customers = customers.drop_duplicates(subset=["email"])

    customers["email"] = customers["email"].fillna("unknown@example.com")
 


    try:
        # 🔹 Ensure no duplicate columns
        customers = customers.loc[:, ~customers.columns.duplicated()]
        products = products.loc[:, ~products.columns.duplicated()]
       

        # 🔹 Drop surrogate key so DB auto-generates it
        if "customer_id" in customers.columns:
            customers = customers.drop(columns=["customer_id"])
        if "product_id" in products.columns:
            products = products.drop(columns=["product_id"])

        # 🔹 Insert data
        customers.to_sql(
            name="customers",
            con=engine,
            if_exists="append",
            index=False,
            method="multi"   # faster batch inserts
        )
        products.to_sql(
            name="products",
            con=engine,
            if_exists="append",
            index=False,
            method="multi"
        )     
        

        print("✅ Customers table loaded successfully")
        print("✅ Products table loaded successfully")
        

    except SQLAlchemyError as e:
        print("❌ Error while loading customers table")
        print("❌ Error while loading products table")

       
        logging.error(f"SQLAlchemy Error: {e}")

    
if __name__ == "__main__":
    load(customers, products)



