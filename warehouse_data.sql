
Use fleximart_dw;
INSERT INTO dim_date VALUES
(20240101,'2024-01-01','Monday',1,1,'January','Q1',2024,false),
(20240102,'2024-01-02','Tuesday',2,1,'January','Q1',2024,false),
(20240103,'2024-01-03','Wednesday',3,1,'January','Q1',2024,false),
(20240104,'2024-01-04','Thursday',4,1,'January','Q1',2024,false),
(20240105,'2024-01-05','Friday',5,1,'January','Q1',2024,false),
(20240106,'2024-01-06','Saturday',6,1,'January','Q1',2024,true),
(20240107,'2024-01-07','Sunday',7,1,'January','Q1',2024,true),
(20240110,'2024-01-10','Wednesday',10,1,'January','Q1',2024,false),
(20240113,'2024-01-13','Saturday',13,1,'January','Q1',2024,true),
(20240115,'2024-01-15','Monday',15,1,'January','Q1',2024,false),
(20240120,'2024-01-20','Saturday',20,1,'January','Q1',2024,true),
(20240125,'2024-01-25','Thursday',25,1,'January','Q1',2024,false),
(20240201,'2024-02-01','Thursday',1,2,'February','Q1',2024,false),
(20240202,'2024-02-02','Friday',2,2,'February','Q1',2024,false),
(20240203,'2024-02-03','Saturday',3,2,'February','Q1',2024,true),
(20240204,'2024-02-04','Sunday',4,2,'February','Q1',2024,true),
(20240205,'2024-02-05','Monday',5,2,'February','Q1',2024,false),
(20240207,'2024-02-07','Wednesday',7,2,'February','Q1',2024,false),
(20240210,'2024-02-10','Saturday',10,2,'February','Q1',2024,true),
(20240214,'2024-02-14','Wednesday',14,2,'February','Q1',2024,false),
(20240215,'2024-02-15','Thursday',15,2,'February','Q1',2024,false),
(20240218,'2024-02-18','Sunday',18,2,'February','Q1',2024,true),
(20240220,'2024-02-20','Tuesday',20,2,'February','Q1',2024,false),
(20240222,'2024-02-22','Thursday',22,2,'February','Q1',2024,false),
(20240224,'2024-02-24','Saturday',24,2,'February','Q1',2024,true),
(20240225,'2024-02-25','Sunday',25,2,'February','Q1',2024,true),
(20240226,'2024-02-26','Monday',26,2,'February','Q1',2024,false),
(20240227,'2024-02-27','Tuesday',27,2,'February','Q1',2024,false),
(20240228,'2024-02-28','Wednesday',28,2,'February','Q1',2024,false),
(20240229,'2024-02-29','Thursday',29,2,'February','Q1',2024,false);

USE fleximart_dw;
INSERT INTO dim_product (product_id, product_name, category, subcategory, unit_price) VALUES
('P001','Laptop','Electronics','Computers',75000),
('P002','Smartphone','Electronics','Mobile',50000),
('P003','Headphones','Electronics','Accessories',2500),
('P004','TV','Electronics','Appliances',60000),
('P005','Mouse','Electronics','Accessories',800),

('P006','T-Shirt','Clothing','Men',999),
('P007','Jeans','Clothing','Men',2499),
('P008','Dress','Clothing','Women',3999),
('P009','Jacket','Clothing','Winter',5999),
('P010','Shoes','Clothing','Footwear',3499),

('P011','Mixer Grinder','Home','Kitchen',4500),
('P012','Sofa','Home','Furniture',85000),
('P013','Dining Table','Home','Furniture',100000),
('P014','Bedsheet','Home','Furnishing',1200),
('P015','Lamp','Home','Decor',1800);

USE fleximart_dw;
INSERT INTO dim_customer (customer_id, customer_name, city, state, customer_segment) VALUES
('C001','John Doe','Mumbai','Maharashtra','Retail'),
('C002','Anita Sharma','Delhi','Delhi','Retail'),
('C003','Rahul Verma','Bengaluru','Karnataka','Retail'),
('C004','Priya Singh','Pune','Maharashtra','Retail'),
('C005','Amit Patel','Mumbai','Maharashtra','Corporate'),
('C006','Neha Jain','Delhi','Delhi','Retail'),
('C007','Rohit Mehta','Bengaluru','Karnataka','Corporate'),
('C008','Kiran Rao','Pune','Maharashtra','Retail'),
('C009','Sneha Kulkarni','Mumbai','Maharashtra','Retail'),
('C010','Vikas Gupta','Delhi','Delhi','Corporate'),
('C011','Arjun Nair','Bengaluru','Karnataka','Retail'),
('C012','Pooja Desai','Pune','Maharashtra','Retail');


USE fleximart_dw;
INSERT INTO fact_sales (date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount) VALUES
(20240106,1,1,1,75000,5000,70000),
(20240107,2,2,2,50000,0,100000),
(20240113,3,3,3,2500,0,7500),
(20240115,4,4,1,60000,2000,58000),
(20240120,5,5,5,800,0,4000),
(20240125,6,6,4,999,0,3996),
(20240203,7,7,2,2499,500,4498),
(20240204,8,8,1,3999,0,3999),
(20240210,9,9,1,5999,500,5499),
(20240214,10,10,2,3499,0,6998),

(20240218,11,11,1,4500,0,4500),
(20240220,12,12,1,85000,10000,75000),
(20240224,13,1,1,100000,15000,85000),
(20240225,14,2,3,1200,0,3600),
(20240226,15,3,2,1800,0,3600),

(20240101,1,4,1,75000,0,75000),
(20240102,2,5,1,50000,2000,48000),
(20240103,3,6,2,2500,0,5000),
(20240104,4,7,1,60000,3000,57000),
(20240105,5,8,10,800,0,8000),

(20240110,6,9,3,999,0,2997),
(20240115,7,10,1,2499,0,2499),
(20240120,8,11,2,3999,500,7498),
(20240125,9,12,1,5999,0,5999),
(20240201,10,1,2,3499,0,6998),

(20240202,11,2,1,4500,0,4500),
(20240203,12,3,1,85000,5000,80000),
(20240204,13,4,1,100000,0,100000),
(20240205,14,5,4,1200,0,4800),
(20240207,15,6,2,1800,0,3600),

(20240210,1,7,1,75000,7000,68000),
(20240214,2,8,1,50000,0,50000),
(20240218,3,9,4,2500,0,10000),
(20240220,4,10,1,60000,4000,56000),
(20240222,5,11,6,800,0,4800),
(20240224,6,12,2,999,0,1998);

