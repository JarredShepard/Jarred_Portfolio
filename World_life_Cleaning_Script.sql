SELECT MAX(Year), MIN(Year)
FROM world_life_expectancy;
-- Years range from 2007 to 2022, meaning every country should have 16 records

SELECT *
FROM world_life_expectancy;

SELECT country, COUNT(country) 
FROM world_life_expectancy
GROUP BY country
HAVING COUNT(country) > 16;
-- Three countries have duplicates: Ireland (two records for 2022), Senegal (two records of 2009), Zimbabwe (two records of 2019)

SELECT country, COUNT(country)
FROM world_life_expectancy
GROUP BY country
HAVING COUNT(country) < 16;
-- 10 Countries have less than 16 records (and they all only have one record each) theese countries are: Cook Islands, Dominica, Marshall Islands, Monaco, Nauru, Niue, Palau, Saint Kitts and Nevis, San Marino, Tuvalu

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;
-- This is a more efficent way of check for Countries with duplicate entries. Three countries have duplicates: Ireland (two records for 2022), Senegal (two records of 2009), Zimbabwe (two records of 2019) 


-- In order to remove the duplicates, we need their Row_ID, I will obtain that through the query below
SELECT * 
FROM (
	SELECT Row_ID,
    CONCAT(Country, Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
    FROM world_life_expectancy
    ) as Row_table
    WHERE Row_Num > 1
    ; -- We now know that the duplicate Row_IDs are: 1251 Ireland 2022, 2264 Senegal 2009, and 2929 Zimbabwe 2019

-- Now to delete the duplicated rows
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (SELECT Row_ID,
    CONCAT(Country, Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
    FROM world_life_expectancy
    ) as Row_table
    WHERE Row_Num > 1
    ); -- With this query, we have successfully deleted the duplicates. 
    
SELECT *
FROM world_life_expectancy
WHERE Status = '';
-- Next thing I noticed are the blank values in the Status column

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';
-- This is me checking which Countries have 'Developing' in their status. I can use this to populate empty values in Columns where the country should have the Developing status. 

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';
-- This query fills in the blank vales under the Status column for countries who should have "Developing" filled in

SELECT *
FROM world_life_expectancy
WHERE Status = '';
-- After running this query again to confirm if the UPDATE query was successful, I noticed there is still a row of data that has a blank under Status, this being the United States of America, which should have 'Developed' written in. This means I need to run a similar UPDATE query similar to the first one, except for Developed countires.

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'; 

SELECT *
FROM world_life_expectancy
WHERE Status = ''; -- Checking one more time to see if I successfully filled in all blank values in the "Status" column, and it was indeed successful. 

SELECT *
FROM world_life_expectancy
WHERE Lifeexpectancy = ''
; -- After looking over the table again, I noticed another blank in the Life Expectancy column, and after running a the query above, I noticed 'Afghanistan' and 'Albania' have blank values under life expectancy. 

-- After analysing the life expectacy column for 'Afghanistan', I noticed that life expectancy steadily rises at least 1 to a couple of tenths every year, and since there is only one missing value each for both Afghanistan and Albania, I'm going to take the average of the year before and the year after the missing value, and fill in the blank values with that average.

UPDATE world_life_expectancy
SET Lifeexpectancy = ROUND((59.5 + 58.8) / 2, 1)
WHERE Country = 'Afghanistan' AND Year = 2018;

UPDATE world_life_expectancy
SET Lifeexpectancy = ROUND((76.9 + 76.2) / 2, 1)
WHERE Country = 'Albania' AND Year = 2018;
-- The two queries above are me populating the blank values that Albania and Afghanistan have under the Life expectancy column

SELECT *
FROM world_life_expectancy
WHERE Country = 'Albania' OR Country = 'Afghanistan'; -- Quick check to confirm

SELECT *
FROM world_life_expectancy -- After looking over the data one more time, it appears to be clean and ready for exploratory data analysis



