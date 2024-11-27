# US Household Income Data Cleaning
-- Working with two data tables for this project; USHouseholdIncome, and ushouseholdincome_statistics

-- First thing I'm going to do is look for duplicates in each data table
SELECT id, COUNT(id)
FROM USHouseholdIncome
GROUP BY id
HAVING COUNT(id) > 1; -- 7 IDs with duplicates 

SELECT * 
FROM (
SELECT row_id, id, 
ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) row_num
FROM USHouseholdIncome
) duplicates
WHERE row_num > 1; -- Confirming the results of our query before using it in a DELETE statement

DELETE FROM USHouseholdIncome
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id, 
		ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) row_num
		FROM USHouseholdIncome
		) duplicates
	WHERE row_num > 1);

SELECT id, COUNT(id) -- Confirming that there are no more duplicates in this table
FROM USHouseholdIncome
GROUP BY id
HAVING COUNT(id) > 1;

-- Now to check for duplicates in the ushouseholdincome_statistics table
SELECT id, COUNT(id)
FROM ushouseholdincome_statistics
GROUP BY id
HAVING COUNT(id) > 1; -- No duplicates to delete :D 

-- Something I noticed while skimming the USHouseholdIncome table was the entry for Alabama in row 7 had an uncapitalized first letter (alabama instead of Alabama). I'm going to look for more instances of this.

SELECT State_Name, COUNT(State_Name)
FROM USHouseholdIncome
GROUP BY State_Name; -- The lower case Alabama isn't showing up, which means SQL is technically fixing the problem for us (although there is a mispelled Georgia that is spelled "georia"), whcih is not necessarily a good thing, because I want to know if there are mulitple instances of these spelling mistakes. Even when running a SELECT DISTINCT State_Name, no lower case states pop up. However, this shouldn't be a big problem as long as SQL includes them in GROUP BY. 

-- Time time to get rid of the misspelled Georgia row
UPDATE USHouseholdIncome 
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

-- And might as well fix the one lower case alabama, though it seems unessesary to dig any deeper since no unique rows are popping up where they shouldn't be 
UPDATE USHouseholdIncome 
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Checking if the state abreviation column looks standardized
SELECT DISTINCT State_ab 
FROM USHouseholdIncome
ORDER BY 1;

-- Another thing I noticed while skimming the data was a NULL value in the 'Place' column in row_id 32, so now I'm going to check if there are anymore.

Select *
FROM USHouseholdIncome
WHERE Place IS NULL; -- Only row 32 pops up. And considering how every other row that has 'Autauga County' under the County column, and has 'Track' in both the Type and Primary columns also has 'Autaugaville' under the Place column, I think it's safe to assume that the NULL value is supposed to be 'Autaugaville', so that's what I will populate the NULL value with. 

-- Populating the NULL value
UPDATE USHouseholdIncome
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
AND Type = 'Track';

SELECT *
FROM USHouseholdIncome
WHERE County = 'Autauga County'; -- Confirming successful UPDATE 

-- The next column I'm going to look at is the Type column

SELECT Type, COUNT(Type)
FROM USHouseholdIncome
GROUP BY Type; -- There is a misspelled 'Borough' spelled 'Boroughs'. There may be another misspelling ('CDP' spelled 'CPD'), but as I don't possess a lot of domain knowledge on this type of data, it's better to be safe and assume CPD is an actual type, and not just a misspelling of CDP.

-- Fixing the 'Boroughs' row
UPDATE USHouseholdIncome
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- Lastly, I noticed that there were a couple of rows that had a value of 0 under the AWater column. So now I'm going see how many instances of this there are.

SELECT ALand, AWater
FROM USHouseholdIncome
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL; -- There are tons, potentially hundereds if not thousands of rows with a value of 0 in the AWater column. And after running a quick SELECT DISTINCT AWater query, there are no blank or NULL values, just 0.

SELECT ALand, AWater
FROM USHouseholdIncome
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL; -- There are 70 instances of a value of 0 appearing under the ALand column.

-- Based on the amount of values with 0 in both columns, it's safe to assume that they are intentional and not just missing data.

-- And finally after skimming through the ushouseholdincome_statistics table, both tables seem to be as clean as can be.
