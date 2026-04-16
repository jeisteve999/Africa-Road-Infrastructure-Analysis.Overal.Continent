/* =========================================================
   AFRICA ROAD INFRASTRUCTURE PROJECT
   Database: Africa
   Description: Road infrastructure analysis across Africa
   ========================================================= */

USE Africa;
GO

/* =========================================================
   1. DATA EXPLORATION
   ========================================================= */

-- Check Table Structure
SELECT 
COLUMN_NAME,
DATA_TYPE,
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Algeria';


-- Check Rd_length Column Across Tables
SELECT 
TABLE_CATALOG AS Database_Name,
TABLE_SCHEMA,
TABLE_NAME,
COLUMN_NAME,
DATA_TYPE
FROM Africa.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'Rd_length'
ORDER BY DATA_TYPE, TABLE_NAME;



/* =========================================================
   2. DATA CLEANING
   ========================================================= */

SELECT ID, Start_pt, End_pt, Surface, Country,
TRY_CAST(Rd_length AS DECIMAL(18,6)) Rd_length
INTO Egypt_part_2_clean
FROM Egypt_part_2;


SELECT ID, Start_pt, End_pt, Surface, Country,
TRY_CAST(Rd_length AS DECIMAL(18,6)) Rd_length
INTO Morocco_clean
FROM Morocco;


SELECT ID, Start_pt, End_pt, Surface, Country,
TRY_CAST(Rd_length AS DECIMAL(18,6)) Rd_length
INTO Nigeria_part_1_clean
FROM Nigeria_part_1;


SELECT ID, Start_pt, End_pt, Surface, Country,
TRY_CAST(Rd_length AS DECIMAL(18,6)) Rd_length
INTO Nigeria_part_2_clean
FROM Nigeria_part_2;


SELECT ID, Start_pt, End_pt, Surface, Country,
TRY_CAST(Rd_length AS DECIMAL(18,6)) Rd_length
INTO SouthAfrica_part_1_clean
FROM SouthAfrica_part_1;


SELECT ID, Start_pt, End_pt, Surface, Country,
TRY_CAST(Rd_length AS DECIMAL(18,6)) Rd_length
INTO SouthAfrica_part_2_clean
FROM SouthAfrica_part_2;



/* =========================================================
   3. MASTER TABLE CREATION
   ========================================================= */

DROP TABLE IF EXISTS Africa_Roads_Master;


SELECT 
ID,
Start_pt,
End_pt,
Surface,
Country,
CAST(Rd_length AS DECIMAL(18,6)) AS Rd_length
INTO Africa_Roads_Master
FROM (

SELECT * FROM Algeria
UNION ALL SELECT * FROM Angola
UNION ALL SELECT * FROM Benin
UNION ALL SELECT * FROM Botswana
UNION ALL SELECT * FROM BurkinaFaso
UNION ALL SELECT * FROM Burundi
UNION ALL SELECT * FROM Cameroon
UNION ALL SELECT * FROM CentralAfrian
UNION ALL SELECT * FROM Chad
UNION ALL SELECT * FROM Congo
UNION ALL SELECT * FROM CongoDR
UNION ALL SELECT * FROM Djibouti

UNION ALL SELECT * FROM Egypt_part_1
UNION ALL SELECT * FROM Egypt_part_2_clean

UNION ALL SELECT * FROM Equatorial
UNION ALL SELECT * FROM Eritrea
UNION ALL SELECT * FROM Ethiopia
UNION ALL SELECT * FROM Gabon
UNION ALL SELECT * FROM Gambia
UNION ALL SELECT * FROM Ghana
UNION ALL SELECT * FROM Guinea
UNION ALL SELECT * FROM GuineaBissau
UNION ALL SELECT * FROM IvoryCoast
UNION ALL SELECT * FROM Kenya
UNION ALL SELECT * FROM Lesotho
UNION ALL SELECT * FROM Liberia
UNION ALL SELECT * FROM Libya
UNION ALL SELECT * FROM Madagascar
UNION ALL SELECT * FROM Malawi
UNION ALL SELECT * FROM Mali
UNION ALL SELECT * FROM Mauritania

UNION ALL SELECT * FROM Morocco_clean

UNION ALL SELECT * FROM Mozambique
UNION ALL SELECT * FROM Namibia
UNION ALL SELECT * FROM Niger

UNION ALL SELECT * FROM Nigeria_part_1_clean
UNION ALL SELECT * FROM Nigeria_part_2_clean

UNION ALL SELECT * FROM Rwanda
UNION ALL SELECT * FROM Senegal
UNION ALL SELECT * FROM SierraLeone
UNION ALL SELECT * FROM Somalia

UNION ALL SELECT * FROM SouthAfrica_part_1_clean
UNION ALL SELECT * FROM SouthAfrica_part_2_clean

UNION ALL SELECT * FROM SouthSudan
UNION ALL SELECT * FROM Sudan
UNION ALL SELECT * FROM Swaziland
UNION ALL SELECT * FROM Tanzania
UNION ALL SELECT * FROM Togo
UNION ALL SELECT * FROM Tunisia
UNION ALL SELECT * FROM Uganda
UNION ALL SELECT * FROM WestSahara
UNION ALL SELECT * FROM Zambia
UNION ALL SELECT * FROM Zimbabwe

) Africa;



/* =========================================================
   4. DATA STANDARDIZATION
   ========================================================= */

UPDATE Africa_Roads_Master
SET Country = 'Egypt'
WHERE Country LIKE 'Egypt%';


UPDATE Africa_Roads_Master
SET Country = 'Nigeria'
WHERE Country LIKE 'Nigeria%';


UPDATE Africa_Roads_Master
SET Country = 'South_Africa'
WHERE Country LIKE 'SouthAfrica%';



/* =========================================================
   5. DATA VALIDATION
   ========================================================= */

SELECT DISTINCT Country
FROM Africa_Roads_Master
ORDER BY Country;


SELECT COUNT(DISTINCT Country) AS Total_Countries
FROM Africa_Roads_Master;


SELECT COUNT(*) AS Total_Roads
FROM Africa_Roads_Master;


SELECT *
FROM Africa_Roads_Master
WHERE Country IS NULL
OR Surface IS NULL
OR Rd_length IS NULL;



/* =========================================================
   6. PERFORMANCE OPTIMIZATION
   ========================================================= */

CREATE INDEX idx_country
ON Africa_Roads_Master (Country);

CREATE INDEX idx_surface
ON Africa_Roads_Master (Surface);



/* =========================================================
   7. INFRASTRUCTURE ANALYSIS
   ========================================================= */

-- Total Roads Africa
SELECT COUNT(*) AS Total_Roads_Africa
FROM Africa_Roads_Master;


-- Total Road Length by Country
SELECT 
Country,
SUM(Rd_length) AS Total_Length_Country
FROM Africa_Roads_Master
GROUP BY Country
ORDER BY Total_Length_Country DESC;


-- Paved vs Unpaved
SELECT 
Country,
SUM(CASE WHEN Surface = 'Paved' THEN Rd_length ELSE 0 END) AS Total_Paved,
SUM(CASE WHEN Surface = 'Unpaved' THEN Rd_length ELSE 0 END) AS Total_Unpaved
FROM Africa_Roads_Master
GROUP BY Country;



/* =========================================================
   8. ROAD STATISTICS
   ========================================================= */

SELECT 
MIN(Rd_length) AS Min_Length,
MAX(Rd_length) AS Max_Length,
AVG(Rd_length) AS Avg_Length
FROM Africa_Roads_Master;



/* =========================================================
   9. TOTAL ROADS BY COUNTRY
   ========================================================= */

SELECT 
Country,
COUNT(ID) AS Total_Roads_Country
INTO Total_Roads_By_Country
FROM Africa_Roads_Master
GROUP BY Country;



SELECT *
FROM Total_Roads_By_Country
ORDER BY Total_Roads_Country DESC;



/* =========================================================
   10. SUMMARY STATISTICS
   ========================================================= */

SELECT 
AVG(Total_Roads_Country) AS Avg_Roads,
MIN(Total_Roads_Country) AS Min_Roads,
MAX(Total_Roads_Country) AS Max_Roads
FROM Total_Roads_By_Country;



/* =========================================================
   11. PAVED ROAD PERCENTAGE
   ========================================================= */

-- Best Infrastructure
SELECT TOP 10
Country,
SUM(CASE WHEN Surface = 'Paved' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) 
AS Paved_Percentage
FROM Africa_Roads_Master
GROUP BY Country
ORDER BY Paved_Percentage DESC;


-- Worst Infrastructure
SELECT TOP 10
Country,
SUM(CASE WHEN Surface = 'Paved' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) 
AS Paved_Percentage
FROM Africa_Roads_Master
GROUP BY Country
ORDER BY Paved_Percentage ASC;
