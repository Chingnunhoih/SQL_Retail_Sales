-- SQL Retail Sales Analysis 
CREATE DATABASE sql_project_p2;

--Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transaction_id INT PRIMARY KEY,
		sales_date DATE,
		sales_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sales FLOAT
	);

SELECT * FROM retail_sales
LIMIT 10

SELECT 
	COUNT(*)
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL

SELECT * FROM retail_sales
WHERE sales_date IS NULL

SELECT * FROM retail_sales
WHERE sales_time IS NULL

SELECT * FROM retail_sales
WHERE
	transaction_id IS NULL
	OR
	sales_date is NULL
	OR
	sales_time is NULL
	OR
	gender is NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	cogs is NULL
	OR
	total_sales is NULL;

-- 
DELETE FROM retail_sales
WHERE
	transaction_id IS NULL
	OR
	sales_date is NULL
	OR
	sales_time is NULL
	OR
	gender is NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	cogs is NULL
	OR
	total_sales is NULL;

--Data exploration

--How many sales we have
SELECT COUNT(*) total_sales FROM retail_sales

--How many unique customers?
SELECT COUNT(DISTINCT customer_id) as toal_sales FROM retail_sales

--
SELECT COUNT(DISTINCT category) as toal_sales FROM retail_sales --no of categories
SELECT DISTINCT category FROM retail_sales	--display the categories

--Data Analysis & Business Key Problems and Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

 SELECT *
 FROM retail_sales
 WHERE sales_date = '2022-11-05';

 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
 
 SELECT * FROM retail_sales
 WHERE
 	category = 'Clothing'
	 AND
	 TO_CHAR(sales_date, 'YYYY-MM') = '2022-11'
	 AND 
	 quantity >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sales) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sales > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sales_date) as year,
    EXTRACT(MONTH FROM sales_date) as month,
    AVG(total_sales) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sales) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sales) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of project