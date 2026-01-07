FACT TABLE: fact_sales
Grain: One row per product per order line item
Business Process: Sales transactions

Measures (Numeric Facts):
- quantity_sold: Number of units sold
- unit_price: Price per unit at time of sale
- discount_amount: Discount applied
- total_amount: Final amount (quantity × unit_price - discount)

Foreign Keys:
- date_key → dim_date
- product_key → dim_product
- customer_key → dim_customer

DIMENSION TABLE: dim_date
Purpose: Date dimension for time-based analysis
Type: Conformed dimension
Attributes:
- date_key (PK): Surrogate key (integer, format: YYYYMMDD)
- full_date: Actual date
- day_of_week: Monday, Tuesday, etc.
- month: 1-12
- month_name: January, February, etc.
- quarter: Q1, Q2, Q3, Q4
- year: 2023, 2024, etc.
- is_weekend: Boolean


DIMENSION TABLE: dim_product
Purpose
Stores descriptive attributes related to products, enabling product-level performance and category analysis.
Type
Slowly Changing Dimension (Type 1)
Attributes
•	product_key (PK): Surrogate key
•	product_id: Business product identifier
•	product_name: Name of the product
•	category: Product category (e.g., Electronics, Clothing)
•	brand: Manufacturer or brand name
•	specifications: Product specifications (stored as text/JSON if required)
•	is_active: Indicates if the product is currently sold

DIMENSION TABLE: dim_customer
Purpose
Captures customer demographic and geographic attributes for customer segmentation and behavior analysis.
Type
Slowly Changing Dimension (Type 2 – optional for history tracking)
Attributes
•	customer_key (PK): Surrogate key
•	customer_id: Business customer identifier
•	customer_name: Full name of the customer
•	email: Email address
•	phone: Contact number
•	city: City of residence
•	state: State or region
•	country: Country
•	customer_type: New / Returning / VIP
•	effective_start_date: Record validity start date
•	effective_end_date: Record validity end date
•	is_current: Boolean flag for current record

---Why you chose this granularity (transaction line-item level)
Granularity (Transaction Line-Item Level):
The transaction line-item level was chosen because it captures the most detailed view of sales—one record per product per order. This granularity enables accurate analysis of quantities, pricing, and discounts at the product level. It also preserves flexibility, allowing data to be aggregated later into order-level, daily, monthly, or yearly summaries without losing detail. Choosing a finer grain ensures the warehouse can support both current reporting needs and future analytical use cases.

---Why surrogate keys instead of natural keys
Surrogate Keys vs Natural Keys:
Surrogate keys are used instead of natural keys because they are stable, system-generated, and independent of source system changes. Natural keys may change, be reused, or differ across systems, which can cause inconsistencies. Surrogate keys also improve query performance and simplify the management of Slowly Changing Dimensions, especially for tracking historical changes.


---How this design supports drill-down and roll-up operations
Drill-Down and Roll-Up Support:
The star schema supports roll-up operations through aggregation across dimension hierarchies (e.g., day → month → year) and drill-down by navigating from summarized metrics to detailed transaction-level data using dimension attributes.


----transaction flows from source to data warehouse:
Source Transaction:
Order #101, Customer "John Doe", Product "Laptop", Qty: 2, Price: 50000

Becomes in Data Warehouse:
fact_sales: {
  date_key: 20240115,
  product_key: 5,
  customer_key: 12,
  quantity_sold: 2,
  unit_price: 50000,
  total_amount: 100000
}

dim_date: {date_key: 20240115, full_date: '2024-01-15', month: 1, quarter: 'Q1'...}
dim_product: {product_key: 5, product_name: 'Laptop', category: 'Electronics'...}
dim_customer: {customer_key: 12, customer_name: 'John Doe', city: 'Mumbai'...}

During the ETL process:
•	The order date 15-01-2024 is matched in dim_date and assigned date_key = 20240115
•	The product Laptop is matched in dim_product and assigned product_key = 5
•	The customer John Doe is matched in dim_customer and assigned customer_key = 12

data store 

dim_date :
        {
  date_key: 20240115,
  full_date: '2024-01-15',
  day_of_week: 'Monday',
  month: 1,
  month_name: 'January',
  quarter: 'Q1',
  year: 2024,
  is_weekend: false
}

dim_product
        {
  product_key: 5,
  product_id: 'PROD_LAP_01',
  product_name: 'Laptop',
  category: 'Electronics',
  brand: 'Dell'
}


dim_customer
{
  customer_key: 12,
  customer_id: 'CUST_012',
  customer_name: 'John Doe',
  city: 'Mumbai',
  state: 'Maharashtra',
  country: 'India',
  customer_type: 'New'
}

fact_sales
{
  date_key: 20240115,
  product_key: 5,
  customer_key: 12,
  quantity_sold: 2,
  unit_price: 50000,
  discount_amount: 0,
  total_amount: 100000
}

This single fact record can now be:
•	Rolled up to monthly or yearly sales
•	Analyzed by product category or customer location
•	Used for revenue, quantity, and trend analysis

