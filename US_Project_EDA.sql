# US Household Income Project Exploratory Data Analysis

-- This is based on two tables (USHouseholdIncome and ushouseholdincome_statistics) from 2022 that record data on US Household Income

-- While scrolling through these data tables during the cleaning phase, the columns that interested me the most were ALand (Area of land) and AWater (Area of water). I'm really curious to see which states have the most area of land or water.

SELECT State_name, SUM(ALand) as total_land, SUM(AWater) as total_water
FROM USHouseholdIncome
GROUP BY State_name
ORDER BY 2 DESC
LIMIT 10; 
-- The top 10 states with the most amount of land are Alaska, Texas, Oregon, California, Montana, Colorado, Nevada, Arizona, Utah, and New Mexico

SELECT State_name, SUM(ALand) as total_land, SUM(AWater) as total_water
FROM USHouseholdIncome
GROUP BY State_name
ORDER BY 3 DESC
LIMIT 10; 
-- The top 10 states with the most amount of water are Alaska, Michigan, Texas, Florida, Hawaii, Wisconsin, Minnesota, California, Louisiana, and North Carolina

-- Since these tables are based on household income in the United States, I was naturally curious about each states average mean and median income

SELECT usi.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM USHouseholdIncome usi
INNER JOIN ushouseholdincome_statistics uss
	ON usi.id = uss.id
WHERE Mean <> 0 -- I noticed some zeros earlier, most likely incomplete data
GROUP BY usi.State_Name
ORDER BY 2
LIMIT 10; 
-- The 10 states with the lowest average household income are Puerto Rico with $27,841.7 (technically not a state, but is US territory), Mississippi with $49,385.6, Arkansas with $52,213.9, West Virginia $52,292.0, Alabama with $54,023.8, Oklahoma with 55,352.0, Kentucky with $55,473.4, South Carolina with $56,081.8, Louisiana with $56,202.2, and Tennessee with $56,925.2
-- A trend that stuck out immediatley to me was that every state mentioned (outside of Puerto Rico) in this list is Southern. I can't think of a reason why this would be the case, but I do believe this is too big of a list to just be a coincidence. What's even more alarming is that this data is based on household income, not just a single person's income. Meaning that a household of two people in Mississippi would only be making less than $25,000 a year each on average, whcih is alarmingly low.

-- Now, I'll simply flip the ORDER BY to descending to see the top 10 states with the highest average income
SELECT usi.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM USHouseholdIncome usi
INNER JOIN ushouseholdincome_statistics uss
	ON usi.id = uss.id
WHERE Mean <> 0 -- I noticed some zeros earlier, most likely incomplete data
GROUP BY usi.State_Name
ORDER BY 2 DESC
LIMIT 10; 
-- The top 10 states with the highest average household income are District of Columbia at $90,668.4 (which is not a state, but this data table includes it as one), Connecticut at $89,732.8, New Jersey at $89,565.4, Maryland at $88,444.2, Massachusetts at $85,645.7, Hawaii at $82,650.9, Virginia at $80,426.3, Alaska at $79,178.4, California at $78,654.3, and New York at $77,859.3

-- Something else that was interesting about the income data was when I ordered the states by average median household income, I found that the states with the highest average median income tends to be much higher than their the average mean household income, whereas the states with the lowest average median income tend to be much closer to what their average mean income is. For example, The average mean household income for Connecticut is $89,732.8 a year, but the average median is $121,240.4 a year ($31,507.6 difference) whereas Mississippi, with an average mean income of $49,385.6, has an average median income of $57,964.7 (only a $8,579.1 difference). The closest being Arkansas, which only has a $322.2 difference between average mean and average median household income. This discovery may have answered my question earlier when I was wondering why so many southern states rank amongst the lowest average household income. This may be due to a good amount of households with really high household incomes skewing the data.

-- Now I want to see if there is any correlation between the average mean and median income with the Type column (city, town, village, etc.)
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM USHouseholdIncome usi
INNER JOIN ushouseholdincome_statistics uss
	ON usi.id = uss.id
WHERE Mean <> 0 -- I noticed some zeros earlier, most likely incomplete data
GROUP BY Type
ORDER BY 3 DESC;
-- This output is a little more tricky to analyze, since the counts of each Type are so drastically different from eachother. For example, the top 3 Types of areas with the highest average household income are Municipality at $83,046.0, Borough at $68,594.4, and Track at $68,086.2. But the there is only one Municipality, 129 Boroughs, and 29,174 tracks. Some types don't even reach 10

-- Lastly, I'm going to look at the average household income based on City. I'm curious to see which cities in the United States have the highest and lowest average household incomes.
SELECT usi.State_Name, City, ROUND(AVG(Mean),1)
FROM USHouseholdIncome usi
INNER JOIN ushouseholdincome_statistics uss
	ON usi.id = uss.id
GROUP BY usi.State_Name, City
ORDER BY 3 DESC
LIMIT 10;
-- The top 10 cities in the United States with the highest average household income are: 1. Delta Junction, Alaska ($242,857.0) 2. Short Hills, New Jersey ($216,503.0) 3. Narberth, Pennsylvania ($194,426.0) 4. Chevy Chase, Maryland ($194,157.5) 5. Darien, Connecticut ($192,882.0) 6. Great Falls, Virginia ($192,103.5) 7. Pelham, New York ($190,909.0) 8. Chantilly, Virginia ($190,865.0) 9. Mclean, Virginia ($188,414.0) 10. Bronxville, New York ($188,005.0). I would include the average median household income as well, but it seems that it caps off at exactly $300,000. This may be because they weren't allowed/didn't want to record anything above that number for some reason. And a lot of cities have exactly $300,000 for their recored average median.