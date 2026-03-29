#finding top 10 highest revenue generating products
select product_id,sum(sale_price) as sales
from orders
group by product_id
order by sales desc
limit 10;

SELECT product_id,
       SUM(quantity) AS total_quantity,
       SUM(sale_price) AS total_sales
FROM orders
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;
###################################

#top 5 highest selling products in each region
select region,product_id,sum(sale_price) as sales
from orders
group by region,product_id
order by sales desc

with cte as(
select region,product_id,sum(sale_price) as sales
from orders
group by region,product_id)
select * from (
select * ,row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5

WITH cte AS (
    SELECT region, product_id, SUM(sale_price) AS sales
    FROM orders
    GROUP BY region, product_id
)
SELECT region, product_id, sales
FROM (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales DESC) AS rn
    FROM cte
) t
WHERE rn <= 5;
###################################

#find month over month growth comparision for 2022 and 2023 sales
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from orders
group by year(order_date),month(order_date)
order by year(order_date),month(order_date)

with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from orders
group by year(order_date),month(order_date)
)
select order_month,
sum(case when order_year =2022 then sales else 0 end)as 2022_sales,
sum(case when order_year =2023 then sales else 0 end) as 2023_sales
from cte
group by order_month
order by order_month

################################
#for each category which month had highest sales
with cte as(
select category,date_format(order_date,'%y-%m') as order_year_month 
,sum(sale_price) as sales
from orders
group by category,date_format(order_date,'%y-%m')
)
select * from (
select * ,
row_number() over(partition by category order by sales desc)as rn
from cte
) a
where rn =1





################################
#which sub category had highest growth by profit in 2023 compare to 2022
WITH cte AS (
SELECT sub_category,
       YEAR(order_date) AS order_year,
       SUM(sale_price) AS sales
FROM orders
GROUP BY sub_category, YEAR(order_date)
),

cte2 AS (
SELECT sub_category,
       SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
       SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY sub_category
)

SELECT *,
       (sales_2023 - sales_2022) * 100 / sales_2022 AS growth_percent
FROM cte2
ORDER BY growth_percent DESC
limit 1;

##################
#Which products generate the most revenue?
SELECT product_id,
       SUM(sale_price) AS total_sales
FROM orders
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;

#Which region generates the most profit?
SELECT region,
       SUM(profit) AS total_profit
FROM orders
GROUP BY region
ORDER BY total_profit DESC;

#Which category sells the most?
SELECT category,
       SUM(sale_price) AS total_sales
FROM orders
GROUP BY category
ORDER BY total_sales DESC;

