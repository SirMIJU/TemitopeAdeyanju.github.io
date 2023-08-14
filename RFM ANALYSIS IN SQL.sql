USE AdventureWorks2017;

select * from sales.customer;

select * from sales.SalesOrderDetail;

select * from sales.SalesOrderHeader;

select * from Production.Product;


--Total Customers

select count(customerid) as total_customers from sales.CUSTOMER;



--TOTAL REVENUE,ORDERS AND CUSTOMER by Year

SELECT YEAR(orderdate) AS YEAR, cast(sum(LINETOTAL) as decimal (10,2)) as Revenue, COUNT(B.SalesOrderID) AS TOTAL_ORDER, count (DISTINCT B.CustomerID) AS total_customers
from sales.salesorderdetail A
inner join sales.salesorderheader B ON A.salesorderid = B.salesorderid
Group by year(orderdate);



--Total Revenue

select customerID, CAST(SUM(LINETOTAL) as DECIMAL(10,2)) AS Revenue from sales.salesorderdetail A
INNER JOIN SALES.SalesOrderHeader B ON A.SALESORDERID = B.SALESORDERID
GROUP BY CUSTOMERID
ORDER BY REVENUE DESC;



--CUSTOMER RECENCY

select sales.Customer.CustomerID, max(orderdate) as Most_Recent_order_date,
datediff(month,max(orderdate),'2014-06-30') as Recency_Score, CASE WHEN datediff(month,max(orderdate),'2014-06-30') <= 3 THEN '0-3MONTHS'
WHEN datediff(month,max(orderdate),'2014-06-30') BETWEEN 4 AND 6 THEN '4-6MONTHS'
WHEN datediff(month,max(orderdate),'2014-06-30') BETWEEN 7 AND 9 THEN '7-9MONTHS'
WHEN datediff(month,max(orderdate),'2014-06-30') BETWEEN 10 AND 12 THEN '10-12MONTHS'
ELSE '+12MONTHS'END AS Recency_period
FROM  sales.Customer
inner join sales.SalesOrderHeader
on sales.Customer.customerID = sales.SalesOrderHeader.customerID
group by sales.customer.CustomerID
order by Most_Recent_order_date desc;


--CUSTOMER FREQUENCY

select sales.Customer.CustomerID, count(SalesOrderID) as frequency_of_order, case when count(SalesOrderID) <=7 then 'very low'
when count(SalesOrderID) BETWEEN 8 and 14 then 'low'
when count(SalesOrderID) between 15 and 21 then 'medium'
else 'high' end as Frequency_rate
FROM  sales.Customer 
inner join sales.SalesOrderHeader
on sales.Customer.CustomerID = sales.SalesOrderHeader.CustomerID
group by sales.customer.CustomerID
order by frequency_of_order desc;



--MONETARY VALUE

SELECT customerID, CAST (SUM(LINETOTAL) AS decimal(10,2)) AS TOTAL_REVENUE, 
CAST (AVG(LINETOTAL) AS decimal(10,2)) AS AVERAGE_REVENUE,
CASE WHEN CAST (SUM(LINETOTAL) AS decimal(10,2)) > 500000 THEN 'HIGH_VALUE_CUSTOMER' 
WHEN CAST (SUM(LINETOTAL) AS decimal(10,2)) BETWEEN  100001 AND 500000 THEN 'MEDIUM_VALUE_CUSTOMER'
ELSE 'LOW_VALUE_CUSTOMER' END AS CUSTOMER_MONETARY_VALUE
FROM SALES.SalesOrderDetail
INNER JOIN SALES.SalesOrderHeader 
ON SALES.SalesOrderDetail.SalesOrderID = SALES.SalesOrderHeader.SalesOrderID
GROUP BY CustomerID
ORDER BY TOTAL_REVENUE DESC;



--CUSTOMERS THAT HAVE NOT ORDERED IN THE LAST 12 MONTHS

select customerid, datediff(month,max(orderdate),'2014-06-30') as Last_order_in_months from sales.SalesOrderHeader
group by CustomerID
having datediff(month,max(orderdate),'2014-06-30') > 12
order by datediff(month,max(orderdate),'2014-06-30') DESC;

--Products frequently purchased together 

select
A.productID as Product1,
B.productID as product2,
count(*) AS FREQUENCY
FROM SALES.SalesOrderDetail A
JOIN SALES.SalesOrderDetail B
ON A.SalesOrderID = B.SalesOrderID
where A.productID < B.productID
GROUP BY A.productID, B.productID
ORDER BY FREQUENCY DESC;


select
P1.name as Product1,
P2.name as product2,
count(*) AS FREQUENCY
FROM SALES.SalesOrderDetail SOD1
JOIN SALES.SalesOrderDetail SOD2
ON SOD1.SalesOrderID = SOD2.SalesOrderID
and SOD1.productID < SOD2.productID
join production.product P1 ON SOD1.PRODUCTID=P1.PRODUCTID
JOIN production.product P2 ON SOD2.PRODUCTID=P2.PRODUCTID 
GROUP BY P1.NAME, P2.NAME
ORDER BY FREQUENCY DESC;

--PRODUCTS WITH HIGH SALES

SELECT NAME,sum(orderqty) as total_quantity_ordered, count(SalesOrderID) as NUMBER_OF_TIMES_ordered, 
CAST(SUM(LINETOTAL) AS DECIMAL(10,2)) AS TOTAL_REVENUE
from production.product A inner join sales.salesorderdetail B ON A.PRODUCTID=B.PRODUCTID
GROUP BY NAME
ORDER BY total_quantity_ordered DESC;











