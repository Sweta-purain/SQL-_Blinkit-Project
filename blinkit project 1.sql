SELECT * FROM blinkit_data;

'''Blinkit project questions
1. Total Sales by Fat Content:
Objective: Analyze the impact of fat content on total sales.
Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.
2. Total Sales by Item Type:
Objective: Identify the performance of different item types in terms of total sales.
Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.
3. Fat Content by Outlet for Total Sales:
Objective: Compare total sales across different outlets segmented by fat content.
Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.
4. Total Sales by Outlet Establishment:
Objective: Evaluate how the age or type of outlet establishment influences total sales.
Percentage of Sales by Outlet Size:
Objective: Analyze the correlation between outlet size and total sales.
6. Sales by Outlet Location:
Objective: Assess the geographic distribution of sales across different locations.
7. All Metrics by Outlet Type:
Objective: Provide a comprehensive view of all key metrics (Total Sales, Average Sales, Number of Items, Average Rating) broken down by different outlet types.'''

SELECT * FROM blinkit_data;
-- data cleaning process

SELECT COUNT(*) FROM blinkit_data;

  UPDATE blinkit_data
SET itemfatcontent = 
  CASE
    WHEN itemfatcontent IN ('LF', 'low fat') THEN 'Low Fat'
    WHEN itemfatcontent = 'reg' THEN 'Regular'
    ELSE itemfatcontent
  END;


  SELECT DISTINCT (itemfatcontent) From blinkit_data;
SELECT*FROM blinkit_data;

--Total Sales
SELECT SUM (Totalsales) Total_sales
from blinkit_data;

SELECT SUM (Totalsales)/1000000 Total_sales
from blinkit_data;

SELECT CAST(SUM (Totalsales)/1000000 AS DECIMAL(10, 2)) AS Total_sales
from blinkit_data
WHERE outletestablishmentyear= 2022;

SELECT CAST(SUM (Totalsales)/1000000 AS DECIMAL(10, 2)) AS Total_sales
from blinkit_data
WHERE itemfatcontent= 'Low Fat';

SELECT * FROM blinkit_data;

--Avg sales 
SELECT AVG(Totalsales) AS Avg_sales FROM blinkit_data;

SELECT CAST(AVG (Totalsales) AS DECIMAL(10, 0)) AS Avg_sales From blinkit_data
WHERE outletestablishmentyear= 2022;

SELECT COUNT(*) AS No_of_Items FROM blinkit_data
WHERE outletestablishmentyear= 2022;

-- Avgare rating
SELECT CAST (AVG(Rating) AS DECIMAL (10,2) ) AS Avg_Rating FROM blinkit_data;

--Total sales by fat content
SELECT * FROM blinkit_data;

 ''' SELECT itemfatcontent
     CAST(SUM (Totalsales)/1000 AS DECIMAL(10, 2)) AS Total_sales_Thousands
      CAST(AVG (Totalsales) AS DECIMAL(10, 1)) AS Avg_sales
	  COUNT(*) AS No_of_Items
	  CAST (AVG(Rating) AS DECIMAL (10,2) ) AS Avg_Rating
FROM blinkit_data 
GROUP BY Iteamfatcontent
ORDER BY Total_sales_Thousands DESC;  WRONG QUERY HW USE CONCATE  AND SALES BY K '''

SELECT 
  itemfatcontent,
  CAST(SUM(Totalsales) / 1000 AS DECIMAL(10, 2)) AS Total_sales_Thousands,
  CAST(AVG(Totalsales) AS DECIMAL(10, 1)) AS Avg_sales,
  COUNT(*) AS No_of_Items,
  CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY itemfatcontent
ORDER BY Total_sales_Thousands DESC;


--FOR ITEAM TYPE
SELECT TOP 5 itemtype
  CAST(SUM(Totalsales) AS DECIMAL(10, 2)) AS Total_sales,
  CAST(AVG(Totalsales) AS DECIMAL(10, 1)) AS Avg_sales,
  COUNT(*) AS No_of_Items,
  CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY itemtype
ORDER BY Total_sales DESC;-- NOT WORKING

SELECT 
  itemtype,
  CAST(SUM(Totalsales) AS DECIMAL(10, 2)) AS Total_sales,
  CAST(AVG(Totalsales) AS DECIMAL(10, 1)) AS Avg_sales,
  COUNT(*) AS No_of_Items,
  CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY itemtype
ORDER BY Total_sales DESC
LIMIT 5;

--FAT CONTENT BY OUTLET FOR TOTAL SALES 

SELECT 
  outletlocationtype, iteamfatcontant,
  CAST(SUM(Totalsales) AS DECIMAL(10, 2)) AS Total_sales,
  CAST(AVG(Totalsales) AS DECIMAL(10, 1)) AS Avg_sales,
  COUNT(*) AS No_of_Items,
  CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY outletlocationtype, iteamfatcontant,
ORDER BY Total_sales DESC
LIMIT 5;--syntex issue

SELECT 
  outletlocationtype, itemfatcontent,
  CAST(SUM(Totalsales) AS DECIMAL(10, 2)) AS Total_sales,
  CAST(AVG(Totalsales) AS DECIMAL(10, 1)) AS Avg_sales,
  COUNT(*) AS No_of_Items,
  CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY outletlocationtype, itemfatcontent
ORDER BY Total_sales DESC
LIMIT 5;

--D. Fat Content by Outlet for Total Sales
SELECT  outletlocationtype, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT  outletlocationtype, itemfatcontent, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY  outletlocationtype, itemfatcontent
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FORitemfatcontent IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY  outletlocationtype;-- not working(pivot does not work in postgresql)

SELECT  
  outletlocationtype, 
  COALESCE(SUM(TotalSales) FILTER (WHERE itemfatcontent = 'Low Fat'), 0) AS Low_Fat,
  COALESCE(SUM(TotalSales) FILTER (WHERE itemfatcontent = 'Regular'), 0) AS Regular
FROM blinkit_data
GROUP BY outletlocationtype
ORDER BY outletlocationtype;

-- TOTAL SALES BY OUTLET ESTABLISHMENT

SELECT outletestablishmentyear
CAST(SUM(Totalsales) AS DECIMAL (10, 2)) AS Total_sales
FROM blinkit_data
GROUP BY outletestablishmentyear
ORDER BY Total_sales ASC; -- WRONG

SELECT 
  outletestablishmentyear,
   CAST(SUM(Totalsales) AS DECIMAL(10, 2)) AS Total_sales,
  CAST(AVG(Totalsales) AS DECIMAL(10, 1)) AS Avg_sales,
  COUNT(*) AS No_of_Items,
  CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
  CAST(SUM(Totalsales) AS DECIMAL(10, 2)) AS Total_sales
FROM blinkit_data
GROUP BY outletestablishmentyear
ORDER BY Total_sales ASC;--wrong


SELECT 
  outletestablishmentyear,
  CAST(SUM(Totalsales) AS DECIMAL(10, 2)) AS Total_sales,
  CAST(AVG(Totalsales) AS DECIMAL(10, 1)) AS Avg_sales,
  COUNT(*) AS No_of_Items,
  CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM blinkit_data
GROUP BY outletestablishmentyear
ORDER BY Total_sales ASC;














