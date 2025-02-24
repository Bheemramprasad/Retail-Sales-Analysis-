/*sql reatil sales analysis*/
/* first create a database* and import excel data into it*/

SELECT * FROM sql_project.`retail_sales_analysis`; #retrieve data
use sql_project
 /*to know the counts*/
select count(*) from retail_sales_analysis;     

/*check null values*/
select *from retail_sales_analysis where 
transactions_id is Null 
or sale_date is Null or
Sale_time is NUll or
gender is Null or 
category is Null or
quantity is NUll or
cogs is Null or
total_sale is Null;

/*data exploration
---how many customer we have*/
 select count(distinct customer_id) as total_sale from retail_sales_analysis;
select distinct category from retail_sales_analysis;    

/*Data analysis &Business problems*/
/*1.write a sql query to retrieve all columns for sales made on '2022-11-05'*/

select * from retail_sales_analysis where sale_date='05-11-2022' ;

/*Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022*/

 SELECT *FROM retail_sales_analysis
WHERE 
category = 'Clothing'
AND 
sale_date between'01-11-2022'
AND '30-11-2022'AND
quantity >=4;

/*3.Write a SQL query to calculate the total sales (total_sale) for each category*/

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales_analysis
GROUP BY 1;

/*4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category*/

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales_analysis
WHERE category = 'Beauty';

/*5.Write a SQL query to find all transactions where the total_sale is greater than 1000.*/

SELECT * FROM retail_sales_analysis
WHERE total_sale > 1000;

/*6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category*/

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales_analysis
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

/*7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year*/
SELECT 
      year,
	  month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as Ranks
FROM retail_sales_analysis
GROUP BY 1, 2
) as t1
WHERE ranks= 1;


/*8.Write a SQL query to find the top 5 customers based on the highest total sales*/

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/*9.Write a SQL query to find the number of unique customers who purchased items from each category*/

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales_analysis
GROUP BY category;

/*10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)*/

with hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales_analysis
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP by shift;

-- Findings

/***Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

--Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.*/