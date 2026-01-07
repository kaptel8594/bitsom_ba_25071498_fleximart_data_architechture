## Entity–Relationship Description

# FlexiMart Database Schema Documentation

### ENTITY: customers
Purpose: Stores customer information

Attributes:
- customer_id: Unique identifier (Primary Key)
- first_name: Customer first name
- last_name: Customer last name
- email: Customer email address
- phone: Contact number
- city: City of residence

Relationships:
- One customer can place MANY orders (1:M with orders)



### ENTITY: products

Purpose:Stores product catalog information.

Attributes:

product_id: Unique identifier for each product (Primary Key)
product_name: Name of the product
category: Standardized product category
price: Unit price of the product
stock_qty: Available inventory quantity
created_at: Record creation timestamp

**Relationships:**

* One product can appear in **MANY** order items (1:M with `order_items` table)

---

### ENTITY: orders

**Purpose:** Stores order-level transaction details.

**Attributes:**

* **order_id**: Unique identifier for each order (Primary Key)
* **customer_id**: Identifier of the customer who placed the order (Foreign Key)
* **order_date**: Date when the order was placed
* **order_status**: Status of the order (Completed, Cancelled, Returned)
* **total_amount**: Total value of the order

**Relationships:**

* One order contains **MANY** order items (1:M with `order_items`)

---

### ENTITY: order_items

**Purpose:** Stores individual line items for each order.

**Attributes:**

* **order_item_id**: Unique identifier for each order item (Primary Key)
* **order_id**: Associated order identifier (Foreign Key → orders.order_id)
* **product_id**: Associated product identifier (Foreign Key → products.product_id)
* **quantity**: Number of units ordered
* **unit_price**: Product price at the time of order

**Relationships:**

* Many order items belong to **ONE** order (M:1 with orders)
* Many order items reference **ONE** product (M:1 with products)

---

### ENTITY: products

**Purpose:** Stores product catalog information.

**Attributes:**

* **product_id**: Unique identifier for each product (Primary Key)
* **product_name**: Name of the product
* **category**: Product category (standardized)
* **price**: Unit price of the product
* **stock_qty**: Available stock quantity
* **created_at**: Record creation timestamp

**Relationships:**

* One product can appear in **MANY** order items (1:M relationship with `order_items` table)

---

### ENTITY: orders

**Purpose:** Stores order-level transaction details.

**Attributes:**

* **order_id**: Unique identifier for each order (Primary Key)
* **customer_id**: Identifier of the customer who placed the order (Foreign Key → customers.customer_id)
* **order_date**: Date of order placement
* **order_status**: Status of the order (e.g., Completed, Cancelled, Returned)
* **total_amount**: Total monetary value of the order

**Relationships:**

* One order belongs to **ONE** customer (M:1 with customers)
* One order contains **MANY** order items (1:M with order_items)

---

### ENTITY: order_items

**Purpose:** Stores line-item details for each order.

**Attributes:**

* **order_item_id**: Unique identifier for each order line item (Primary Key)
* **order_id**: Associated order identifier (Foreign Key → orders.order_id)
* **product_id**: Associated product identifier (Foreign Key → products.product_id)
* **quantity**: Quantity of the product ordered
* **unit_price**: Product price at the time of order

**Relationships:**

* Many order items belong to **ONE** order (M:1 with orders)
* Many order items reference **ONE** product (M:1 with products)

---

## 2. Normalization Explanation (Third Normal Form – 3NF)

The FlexiMart database schema is designed in **Third Normal Form (3NF)** to ensure data integrity, reduce redundancy, and support scalable analytics. A table is in 3NF if it is in 2NF and all non-key attributes are fully functionally dependent only on the primary key, with no transitive dependencies.

### Functional Dependencies

* **customers**: customer_id → first_name, last_name, email, phone, city
* **products**: product_id → product_name, category, price, stock_qty
* **orders**: order_id → customer_id, order_date, order_status, total_amount
* **order_items**: order_item_id → order_id, product_id, quantity, unit_price

There are no partial dependencies because all tables use single-column primary keys. Transitive dependencies are avoided by separating customer, product, and order details into distinct entities.

### Anomaly Prevention

* **Update Anomalies:** Customer or product details are stored only once, so updates (e.g., price or email change) require modification in a single location.
* **Insert Anomalies:** New customers or products can be added independently without requiring an order to exist.
* **Delete Anomalies:** Deleting an order does not remove customer or product master data, preserving historical and reference information.

This normalization ensures consistency, minimizes duplication, and supports reliable transactional and analytical workloads.

---

## 3. Sample Data Representation

### customers

| customer_id | first_name | last_name | email                                   | phone          | city   |
| ----------: | ---------- | --------- | --------------------------------------- | -------------- | ------ |
|           1 | Amit       | Sharma    | [amit@gmail.com](mailto:amit@gmail.com) | +91-9876543210 | Mumbai |
|           2 | Neha       | Verma     | [neha@gmail.com](mailto:neha@gmail.com) | +91-9123456780 | Delhi  |

### products

| product_id | product_name   | category      | price | stock_qty |
| ---------: | -------------- | ------------- | ----- | --------- |
|        101 | Wireless Mouse | Electronics   | 799   | 150       |
|        102 | Water Bottle   | Home & Living | 299   | 300       |

### orders

| order_id | customer_id | order_date | order_status | total_amount |
| -------: | ----------: | ---------- | ------------ | ------------ |
|     5001 |           1 | 2025-12-01 | Completed    | 1098         |
|     5002 |           2 | 2025-12-03 | Completed    | 799          |

### order_items

| order_item_id | order_id | product_id | quantity | unit_price |
| ------------: | -------: | ---------: | -------: | ---------: |
|          9001 |     5001 |        101 |        1 |        799 |
|          9002 |     5001 |        102 |        1 |        299 |
