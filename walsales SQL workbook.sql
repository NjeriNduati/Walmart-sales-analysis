-- Create database
CREATE DATABASE IF NOT EXISTS walmart;
SELECT * FROM walmart.walsales;

-- Create table
CREATE TABLE IF NOT EXISTS walsales(
	InvoiceID VARCHAR(30) NOT NULL PRIMARY KEY,
    Branch VARCHAR(5) NOT NULL,
    City VARCHAR(30) NOT NULL,
    CustomerType VARCHAR(30) NOT NULL,
    Gender VARCHAR(30) NOT NULL,
    ProductLine VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    Tax FLOAT(6,4) NOT NULL,
    Total DECIMAL(12, 4) NOT NULL,
    Date DATETIME NOT NULL,
    Time TIME NOT NULL,
    Payment VARCHAR(15) NOT NULL,
    COGS DECIMAL(10,2) NOT NULL,
    GrossMarginPercentage FLOAT(11,9),
    GrossIncome DECIMAL(12, 4),
    Rating FLOAT(2, 1)
);

-- Add the time_of_day column
SELECT
	Time,
	(CASE
		WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM walsales;


ALTER TABLE walsales ADD COLUMN time_of_day VARCHAR(20);
-- to update, ensure you have activated safe update mode
set sql_safe_update=0;
UPDATE walsales
SET time_of_day = (
	CASE
		WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	Date,
	DAYNAME(Date)
FROM walsales;

ALTER TABLE walsales ADD COLUMN Day_name VARCHAR(10);

UPDATE walsales
SET Day_name = DAYNAME(date);


-- Add month_name column
SELECT
	Date,
	MONTHNAME(Date)
FROM walsales;

ALTER TABLE walsales ADD COLUMN Month_name VARCHAR(10);

UPDATE walsales
SET Month_name = MONTHNAME(Date);
# --------------how many unique cities are there in the dataset------
select distinct City from walsales;

# ----------in which city is each branch located------------------
select distinct City, Branch
from walsales;

####  -----------How many unique product lines does the data have?-----------
select count(distinct ProductLine) from walsales;

## -----What is the most common payment method?-----
select  
	distinct Payment, 
    count(Payment) as Count
from walsales
group by Payment
order by Count desc;

#----what is the most selling product line?
select distinct ProductLine, count(ProductLine) as count
from walsales
group by ProductLine
order by count desc;

#--what is the total revenue by month?
select Month_name as Month, cast(sum(Total)as decimal(10,2)) as TotalRevenue
from walsales
Group by Month_name
Order by TotalRevenue desc;

#------which month had the largest Cogs----
select Month_name as Month, sum(COGS) as COGs
from walsales
Group by Month_name
Order by COGs desc;

#-----what product line had the largest revenue
select ProductLine, cast(sum(Total)as decimal(10,2)) as TotalRevenue
from walsales
Group by ProductLine
Order by TotalRevenue desc;

#----what product line had the largest VAT
select ProductLine, avg(Tax) as Avg_tax
from walsales
group by ProductLine
order by Avg_tax desc;

#---Which branch sold more products than average product sold?
select Branch, sum(Quantity) as Qty
from walsales
group by Branch
having sum(Quantity) >(select avg(Quantity) as AvgProductSold from walsales);

#--what is the most common product line by gender---------
select Gender, ProductLine, count(gender) as Total_cnt
from walsales
group by Gender, ProductLine
order by Total_cnt desc;
