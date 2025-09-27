DROP TABLE IF EXISTS ZEPTO;

CREATE TABLE ZEPTO (
	SKU_ID SERIAL PRIMARY KEY,
	CATEGORY VARCHAR(120),
	NAME VARCHAR(150) NOT NULL,
	MRP NUMERIC(8, 2),
	DISCOUNTPERCENT NUMERIC(5, 2),
	AVAILABLEQUANTITY INTEGER,
	DISCOUNTEDSELLINGPRICE NUMERIC(8, 2),
	WEIGHTINGMS INTEGER,
	OUTOFSTOCK BOOLEAN,
	QUANTITY INTEGER
);

-- exploration
--count of rows 
SELECT
	COUNT(*)
FROM
	ZEPTO;

--sample data 
SELECT
	*
FROM
	ZEPTO
LIMIT
	10;

-- null values 
SELECT
	*
FROM
	ZEPTO
WHERE
	NAME IS NULL
	OR CATEGORY IS NULL
	OR MRP IS NULL
	OR DISCOUNTPERCENT IS NULL
	OR DISCOUNTEDSELLINGPRICE IS NULL
	OR WEIGHTINGMS IS NULL
	OR AVAILABLEQUANTITY IS NULL
	OR OUTOFSTOCK IS NULL
	OR QUANTITY IS NULL;

-- different product categories
SELECT DISTINCT
	CATEGORY
FROM
	ZEPTO
ORDER BY
	CATEGORY;

-- product instock vs outstock 
SELECT
	OUTOFSTOCK,
	COUNT(SKU_ID)
FROM
	ZEPTO
GROUP BY
	OUTOFSTOCK;

-- product name present multiple times
SELECT
	NAME,
	COUNT(SKU_ID) AS "Number of SKUs"
FROM
	ZEPTO
GROUP BY
	NAME
HAVING
	COUNT(SKU_ID) > 1
ORDER BY
	COUNT(SKU_ID) DESC;

-- data cleaning 
-- product price = 0 
SELECT
	*
FROM
	ZEPTO
WHERE
	MRP = 0
	OR DISCOUNTEDSELLINGPRICE = 0;

DELETE FROM ZEPTO
WHERE
	MRP = 0
	OR DISCOUNTEDSELLINGPRICE = 0;

--convert paisa in rupees
UPDATE ZEPTO
SET
	MRP = MRP / 100.0,
	DISCOUNTEDSELLINGPRICE = DISCOUNTEDSELLINGPRICE / 100.0;

SELECT
	MRP,
	DISCOUNTEDSELLINGPRICE
FROM
	ZEPTO;

--Found top 10 best-value products based on discount percentage
SELECT DISTINCT
	NAME,
	MRP,
	DISCOUNTPERCENT
FROM
	ZEPTO
ORDER BY
	DISCOUNTPERCENT DESC
LIMIT
	10;

--Identified high-MRP products that are currently out of stock
SELECT DISTINCT
	NAME,
	MRP
FROM
	ZEPTO
WHERE
	OUTOFSTOCK = TRUE
	AND MRP > 300
ORDER BY
	MRP DESC;

--Estimated potential revenue for each product category
SELECT
	CATEGORY,
	SUM(DISCOUNTEDSELLINGPRICE * AVAILABLEQUANTITY) AS TOTAL_REVENUE
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	TOTAL_REVENUE;

--Filtered expensive products (MRP > ₹500) with minimal discount
SELECT DISTINCT
	NAME,
	MRP,
	DISCOUNTPERCENT
FROM
	ZEPTO
WHERE
	MRP > 500
	AND DISCOUNTPERCENT < 10
ORDER BY
	MRP DESC,
	DISCOUNTPERCENT DESC;

--Ranked top 5 categories offering highest average discounts
SELECT
	CATEGORY,
	ROUND(AVG(DISCOUNTPERCENT), 2) AS AVG_DISCOUNT
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	AVG_DISCOUNT DESC
LIMIT
	5;

--Calculated price per gram to identify value-for-money products
select distinct name , weightingms, discountedsellingprice ,
round(discountedsellingprice/weightingms,2) as price_per_gm
from zepto 
where weightingms>=100
order by price_per_gm ;


--Grouped products based on weight into Low, Medium, and Bulk categories
SELECT DISTINCT
	NAME,
	WEIGHTINGMS,
	CASE
		WHEN WEIGHTINGMS < 1000 THEN 'low'
		WHEN WEIGHTINGMS < 5000 THEN 'medium'
		ELSE 'bulk'
	END AS WEIGHT_CATEGORY
FROM
	ZEPTO
;

--Measured total inventory weight per product category
select category,
sum(weightingms * discountedsellingprice) as total_weight
from zepto 
group by category 
order by total_weight;
