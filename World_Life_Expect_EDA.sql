# World Life Expectancy Exploritory Data Analysis 

 -- The first thing I was curious about was which countries had the highest and lowest Life  Expectancy (I have to include the HAVING statement since I noticed some countries have a 0 in both the Max and Min life expectancy columns, seems like a data error I missed in my cleaning phase 
 
 SELECT Country, MAX(Lifeexpectancy), MIN(Lifeexpectancy), ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy), 2) as growth_over_15_years
 FROM world_life_expectancy
 GROUP BY Country
 HAVING MIN(Lifeexpectancy) <> 0
 AND MAX(Lifeexpectancy) <> 0
 ORDER BY growth_over_15_years DESC;
 -- Haiti is the country that had the highest growth in average life expectancy, with 28.7 years (minimum 36.3 years, maximum 65 years)
 
 -- Now that I'm looking at the highest growth list, the lion share of the top countries are from Africa, which leads me to the question, which continent had the most amount of countries with the highest growth in average life expectancy
 SELECT Country, MAX(Lifeexpectancy), MIN(Lifeexpectancy), ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy), 2) as growth_over_15_years
 FROM world_life_expectancy
 GROUP BY Country
 HAVING MIN(Lifeexpectancy) <> 0
 AND MAX(Lifeexpectancy) <> 0
 ORDER BY growth_over_15_years DESC
 LIMIT 20;
-- Africa is the clear winner, as all top 10 countries with the highest growth in AEL are all African, and 17 out of the top of 20 countries are all African as well
 
-- Next, I'm going to find out what the average life expectancy has been for each year
SELECT Year, ROUND(AVG(Lifeexpectancy), 2)
FROM world_life_expectancy
WHERE Lifeexpectancy <> 0
AND Lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year;
-- Year with the highest average LE is 2022 at 71.62 years, year with lowest average LE is 2007 at 66.75 years. 
-- Every year after 2007 has a higher average life expectancy than the year before, letting us know that average life expectancy is steadily growing.

-- Now I'm curious about the correlation is between life expectancy and the other columns in this data table. This query in particualr is the average life expectancy's correlation with GDP
SELECT Country, ROUND(AVG(Lifeexpectancy), 1) as avg_life_exp, ROUND(AVG(GDP), 2) as GDP
FROM world_life_expectancy
GROUP BY Country
HAVING avg_life_exp > 0
AND GDP > 0
ORDER BY GDP ASC;
-- Immediatley upon looking at this query, there is a pretty illuminating correlation between GDP and average life expectancy; the lower the country's GDP, the higher chance they will have a low life expectancy. And if we flip the ORDER BY clasue from GDP ASC to GDP DESC, the list of countries basically flips as well. This makes perfect sense, if a country is not making enough money, will cannot inveset as much into things like their healthcare structure, social structure, etc.

-- This query is looking for a correlation between life expectancy and a country's status (Developing vs. Developed)
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(Lifeexpectancy), 1)
FROM world_life_expectancy
GROUP BY Status; -- Average life expectancy of Developed countries is 79.2, and average life expectancy of Developing countries is 66.8. However, this data might not be all that reliable since the number of countries that are still Developing (161) greatly outnumber the amount of countries that are already Developed (32). 

-- Next, I'm going to examine the correlation between BMI and average life expectancy 
SELECT Country, ROUND(AVG(Lifeexpectancy), 1) as avg_life_exp, ROUND(AVG(BMI), 1) as BMI
FROM world_life_expectancy
GROUP BY Country
HAVING avg_life_exp > 0
AND BMI > 0
ORDER BY BMI DESC; -- Immediatley there is something strange about the BMI column, as the average BMI for the first 80 or so countries are all above 40, and according to the Cleveland Health Clinic, a BMI above 40 is considered Class III Obesity (morbidly obese). And if we flip the ORDER BY to ASC, we have unrealistic extremes on that end as well (lowest avg BMI according to this data table is 11.2, which is well below Underweight, that's basically melnurishment) so this doesn't seem right.
-- Despite the questionable accuracy of the BMI column, there is still a postive correlation between average life expectancy, and BMI. This may be case because countries with a higher BMI have access to more food, and therefore live longer.

-- Lastly, I'm going to be looking at the adult mortality column. And while I'll still be looking at the correlation between this column and life expectancy, more importantly I will also be doing a Rolling Total
SELECT *
FROM (SELECT Country, Year, Lifeexpectancy, AdultMortality, SUM(AdultMortality) 
OVER(PARTITION BY Country ORDER BY Year) as Rolling_total
FROM world_life_expectancy) as Rolling_total_table
WHERE Year = '2022'
ORDER BY Rolling_total DESC; -- The country with the highest rolling total is Lesotho with 8801.