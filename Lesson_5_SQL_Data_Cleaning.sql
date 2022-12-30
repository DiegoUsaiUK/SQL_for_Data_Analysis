--- LESSON 5 - SQL DATA CLEANING ---

/* 5.1 - INTRODUCTION

In this lesson, you will be learning a number of techniques to

  -  Clean and re-structure messy data.
  -  Convert columns to different data types.
  -  Tricks for manipulating NULLs.

This will give you a robust toolkit to get from raw data to clean data that's 
useful for analysis. */


/* 5.2 - LEFT & RIGHT
Here we looked at three new functions:

  -  LEFT
  -  RIGHT
  -  LENGTH

LEFT pulls a specified number of characters for each row in a specified column 
starting at the beginning (or from the left). As you saw here, you can pull the 
first three digits of a phone number using LEFT(phone_number, 3).

RIGHT pulls a specified number of characters for each row in a specified column 
starting at the end (or from the right). As you saw here, you can pull the last 
eight digits of a phone number using RIGHT(phone_number, 8).

LENGTH provides the number of characters for each row of a specified column. 
Here, you saw that we could use this to get the length of each phone number as 
LENGTH(phone_number). */

-- VIDEO EXAMPLE REFERENCES A DATASET (PROSPECT CLIENTS) THAT IS NOT AVAILABLE 


-- 5.3 - Quiz: LEFT & RIGHT Quizzes

/* 5.3.1 - In the accounts table, there is a column holding the website for each
company. The last three digits specify what type of web address they are using. 
A list of extensions (and pricing) is provided here. 
(https://iwantmyname.com/domains)
Pull these extensions and provide how many of each website type exist in the 
accounts table.*/

SELECT 
	RIGHT(WEBSITE, 3) AS DOMAIN,
	COUNT(RIGHT(WEBSITE, 3)) AS DOMAIN_COUNT
FROM ACCOUNTS
GROUP BY 1

-- SOLUTION
SELECT 
	RIGHT(website, 3) AS domain, 
	COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/* 5.3.2 - There is much debate about how much the name (or even the first letter
of a company name) matters. (https://www.quora.com/How-important-is-a-startups-name)
Use the accounts table to pull the first letter of each company name to see the
distribution of company names that begin with each letter (or number).*/
SELECT 
	LEFT(NAME, 1) AS FIRST_LETTER,
	COUNT(LEFT(NAME, 1)) AS FIRST_LETTER_COUNT
FROM ACCOUNTS
GROUP BY 1
ORDER BY 2 DESC

-- SOLUTION
SELECT 
	LEFT(UPPER(name), 1) AS first_letter, 
	COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/* 5.3.3 - Use the accounts table and a CASE WHEN statement to create two groups: 
one group of company names that start with a number and a second group of those 
company names that start with a letter. What proportion of company names start 
with a letter?*/

WITH NUM_LETTER AS 
(SELECT 
	name, 
	CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
    CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts
)

SELECT 
	SUM(NUM) AS NUMBERS,
	SUM(LETTER) AS LETTERS
FROM NUM_LETTER

-- SOLUTION

SELECT 
	SUM(num) nums, 
	SUM(letter) letters
FROM (SELECT 
		  name, 
		  CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
          CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;

-- There are 350 company names that start with a letter and 1 that starts with a 
-- number. This gives a ratio of 350/351 that are company names that start with a 
-- letter or 99.7%.

/* 5.3.4 - Consider vowels as a, e, i, o, and u. What proportion of company names
start with a vowel, and what percent start with anything else?*/

WITH VOWEL_CONS AS 
(SELECT 
	name, 
	CASE WHEN LEFT(UPPER(name), 1) IN ('a','e','i','o','u') 
                       THEN 1 ELSE 0 END AS vowel, 
    CASE WHEN LEFT(UPPER(name), 1) IN ('a','e','i','o','u')
                       THEN 0 ELSE 1 END AS consonant
      FROM accounts
)

SELECT 
	SUM(vowel) AS vowels,
	SUM(consonant) AS consonants
FROM VOWEL_CONS


-- SOLUTION

SELECT 
	SUM(vowels) vowels, 
	SUM(other) other
FROM (SELECT 
		  name, 
		  CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                        THEN 1 ELSE 0 END AS vowels, 
          CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                       THEN 0 ELSE 1 END AS other
         FROM accounts) t1;


-- 5.5 - POSITION, STRPOS, & SUBSTR

/*In this lesson, you learned about:

  -  POSITION - provides position of string counting from left
  -  STRPOS - provides position of string counting from left
  -  LOWER - forces all character in string to lowercase
  -  UPPER - forces all character in string to uppercase

POSITION takes a character and a column, and provides the index where that 
character is for each row. The index of the first position is 1 in SQL. 
If you come from another programming language, many begin indexing at 0. 
Here, you saw that you can pull the index of a comma as 
POSITION(',' IN city_state).

STRPOS provides the same result as POSITION, but the syntax for achieving 
those results is a bit different as shown here: STRPOS(city_state, ',').

Note, both POSITION and STRPOS are case sensitive, so looking for A is 
different than looking for a.

Therefore, if you want to pull an index regardless of the case of a letter, 
you might want to use LOWER or UPPER to make all of the characters lower or 
uppercase.
*/

-- VIDEO EXAMPLE REFERENCES A DATASET (PROSPECT CLIENTS) THAT IS NOT AVAILABLE 


-- 5.6 - QUIZ - POSITION, STRPOS, & SUBSTR - AME DATA AS QUIZ 1

/*You will need to use what you have learned about LEFT & RIGHT, as well as 
what you know about POSITION or STRPOS to do the following quizzes.
*/

-- 5.6.1 - Use the accounts table to create first and last name columns that 
--			hold the first and last names for the primary_poc.
SELECT
	PRIMARY_POC,
	LEFT(PRIMARY_POC, POSITION(' ' IN PRIMARY_POC) -1) AS FIRST_NAME,
	RIGHT(PRIMARY_POC, LENGTH(PRIMARY_POC) - STRPOS(PRIMARY_POC, ' ')) LAST_NAME,
	--RIGHT(PRIMARY_POC, 
		  LENGTH(PRIMARY_POC),     		-- length of full string
		  STRPOS(PRIMARY_POC, ' '), 	-- length first part up to space
		  POSITION(' ' IN PRIMARY_POC) 	-- equivalent to previous 
		 -- ) LAST_NAME
FROM ACCOUNTS


-- 5.6.2 - Now see if you can do the same thing for every rep name in the 
--			sales_reps table. Again provide first and last name columns.
SELECT
	NAME,
	LEFT(NAME, POSITION(' ' IN NAME) -1) AS FIRST_NAME,
	RIGHT(NAME, LENGTH(NAME) - STRPOS(NAME, ' ')) LAST_NAME
FROM ACCOUNTS



-- 5.8 - CONCAT

/*In this lesson you learned about:

    CONCAT
    Piping ||

Each of these will allow you to combine columns together across rows. In this 
video, you saw how first and last names stored in separate columns could be 
combined together to create a full name: CONCAT(first_name, ' ', last_name) 
or with piping as first_name || ' ' || last_name.
*/

-- VIDEO EXAMPLE REFERENCES A DATASET (PROSPECT CLIENTS) THAT IS NOT AVAILABLE 


-- 5.9 - QUIZ: CONCAT

-- 5.9.1 - Each company in the accounts table wants to create an email address 
--		for each primary_poc. The email address should be the first name of 
--		the primary_poc . last name primary_poc @ company name .com.

WITH EMAIL AS 

(SELECT
	NAME,
 	PRIMARY_POC,
	LEFT(PRIMARY_POC, POSITION(' ' IN PRIMARY_POC) -1) AS FIRST_NAME,
	RIGHT(PRIMARY_POC, LENGTH(PRIMARY_POC) - STRPOS(PRIMARY_POC, ' ')) AS LAST_NAME
FROM ACCOUNTS
)

SELECT
	PRIMARY_POC,
	CONCAT(FIRST_NAME, '.', LAST_NAME, '@', NAME, '.com')
FROM EMAIL


-- SOLUTION

WITH t1 AS (
 SELECT LEFT(primary_poc,  STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
 
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;


-- 5.9.2 - You may have noticed that in the previous solution some of the 
--		company names include spaces, which will certainly not work in an 
--		email address. See if you can create an email address that will work 
--		by removing all of the spaces in the account name, but otherwise your 
--		solution should be just as in question 1. Some helpful documentation 
--		is here.
--		(https://www.postgresql.org/docs/8.1/static/functions-string.html)

WITH EMAIL AS 

(SELECT
	NAME,
 	REPLACE(NAME, ' ', '') AS TRIM_NAME,
 	PRIMARY_POC,
	LEFT(PRIMARY_POC, POSITION(' ' IN PRIMARY_POC) -1) AS FIRST_NAME,
	RIGHT(PRIMARY_POC, LENGTH(PRIMARY_POC) - STRPOS(PRIMARY_POC, ' ')) AS LAST_NAME
FROM ACCOUNTS
)

SELECT
	PRIMARY_POC,
	CONCAT(FIRST_NAME, '.', LAST_NAME, '@', TRIM_NAME, '.com')
FROM EMAIL

-- SOLUTION
WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;

-- 5.9.3 - We would also like to create an initial password, which they will 
--		change after their first log in. The first password will be the first 
--		letter of the primary_poc's first name (lowercase), then the last 
--		letter of their first name (lowercase), the first letter of their 
--		last name (lowercase), the last letter of their last name (lowercase),
--		the number of letters in their first name, the number of letters in 
--		their last name, and then the name of the company they are working 
--		with, all capitalized with no spaces.

-- SOLUTION
WITH t1 AS (
 SELECT 
	LEFT(primary_poc,  STRPOS(primary_poc, ' ') -1 ) first_name,  
	RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
 
SELECT 
	first_name, 
	last_name, 
	CONCAT(first_name, '.', last_name, '@', name, '.com'), 
	LEFT(LOWER(first_name), 1) || 
		RIGHT(LOWER(first_name), 1) || 
		LEFT(LOWER(last_name), 1) || 
		RIGHT(LOWER(last_name), 1) || 
		LENGTH(first_name) || 
		LENGTH(last_name) || 
		REPLACE(UPPER(name), ' ', '')
FROM t1;


-- 5.11 - CAST

/*In this video, you saw additional functionality for working with dates 
including:

    TO_DATE
    CAST			-- allows for the converting of 
    Casting with :: -- one data type to another

DATE_PART('month', TO_DATE(month, 'month')) here changed a month name into 
the number associated with that particular month.

Then you can change a string to a date using CAST. CAST is actually useful 
to change lots of column types. Commonly you might be doing as you saw here,
where you change a string to a date using CAST(date_column AS DATE). 

However, you might want to make other changes to your columns in terms of 
their data types. You can see other examples here. 
(https://www.postgresqltutorial.com/postgresql-cast/)

In this example, you also saw that instead of CAST(date_column AS DATE), you 
can use date_column::DATE.

EXPERT TIP

Most of the functions presented in this lesson are specific to strings. They 
won’t work with dates, integers or floating-point numbers. However, using 
any of these functions will automatically change the data to the appropriate
type.

LEFT, RIGHT, and TRIM are all used to select only certain elements of strings,
but using them to select elements of a number or date will treat them as 
strings for the purpose of the function. Though we didn't cover TRIM in this
lesson explicitly, it can be used to remove characters from the beginning 
and end of a string. This can remove unwanted spaces at the beginning or end
of a row that often happen with data being moved from Excel or other storage
systems.

There are a number of variations of these functions, as well as several other
string functions not covered here. Different databases use subtle variations
on these functions, so be sure to look up the appropriate database’s syntax
if you’re connected to a private database. The Postgres literature 
(http://www.postgresql.org/docs/9.1/static/functions-string.html) contains 
a lot of the related functions.
*/


-- VIDEO EXAMPLE REFERENCES A DATASET (ad_clicks) THAT IS NOT AVAILABLE
-- EXAMPLE IS GOOD SO I'M REPRODUCING HERE FIRST FEW ROWS OF DATASET

--  month	- day -	year - 	clicks	- clean_month -	conc_date - form_date
-- january	- 1	  -	2014 -	1135	-	1		  -	2014-1-1  - 2014-01-01
-- january	- 2	  -	2014 -	602		-	1		  -	2014-1-2  - 2014-01-02
-- january	- 3	  -	2014 -	3704	-	1		  -	2014-1-3  - 2014-01-03


SELECT 
	-- first part turns month names string 'month' into a number
	DATE_PART('month', TO_DATE(MONTH, 'month')) AS clean_month,
	
	-- second part concatenates elements into something that looks like a date
	-- can also be done with CONCATENATE
	year || '-' || 
		DATE_PART('month', TO_DATE(MONTH, 'month')) || '-' || 
		day AS concatenated_date,
		
	-- last part turns concatenated_date into actual date format
	-- adding the missing zeroes
	CAST( year || '-' || 
		DATE_PART('month', TO_DATE(MONTH, 'month')) || '-' || 
		day AS date) AS formatted_date
	
	-- there is also a short hand version of CAST
	( year || '-' || 
		DATE_PART('month', TO_DATE(MONTH, 'month')) || '-' || 
		day)::date AS formatted_date_alt
		
FROM ad_clicks


-- 5.12 - QUIZ: CAST

/*For this set of quiz questions, you are going to be working with a single 
table in the environment below. This is a different dataset than Parch & Posey,
as all of the data in that particular dataset were already clean. */

-- 5.12.1/2/3 are simple questions
    SELECT *
    FROM sf_crime_data
    LIMIT 10;

    yyyy-mm-dd

/* 3 - The format of the date column is mm/dd/yyyy with times that are not correct 
also at the end of the date.*/


-- 5.12.4 
SELECT 
	date orig_date, 
	(SUBSTR(date, 7, 4) || '-' || 
	 	LEFT(date, 2) || '-' || 
	 	SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;


-- 5.12.5

/*Notice, this new date can be operated on using DATE_TRUNC and DATE_PART in 
the same way as earlier lessons.*/
SELECT 
	date orig_date, 
	(SUBSTR(date, 7, 4) || '-' || 
	 	LEFT(date, 2) || '-' || 
	 	SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;


-- 5.14 - COALESCE

/*In this video, you learned about how to use COALESCE to work with NULL 
values. Unfortunately, our dataset does not have the NULL values that were 
fabricated in this dataset, so you will work through a different example in 
the next concept to get used to the COALESCE function.

In general, COALESCE returns the first non-NULL value passed for each row. 
Hence why the video used no_poc if the value in the row was NULL.
*/


-- 5.15 - Quiz: COALESCE

/*  5.15.1 - run the query entered below to notice the row with missing
data */
SELECT *
FROM accounts a
LEFT JOIN orders o
	ON a.id = o.account_id
WHERE o.total IS NULL; 


/*  5.15.2 use COALESCE to fill in the accounts.id column with the 
account.id for the NULL value as per first question*/
SELECT 
	COALESCE(o.id, a.id) filled_id, 
	a.name, 
	a.website, 
	a.lat, 
	a.long, 
	a.primary_poc, 
	a.sales_rep_id, 
	o.*
FROM accounts a
LEFT JOIN orders o
	ON a.id = o.account_id
WHERE o.total IS NULL;


/*  5.15.3 use COALESCE to fill in the orders.account_id column with 
the account.id for the NULL value as per first question*/
SELECT 
	COALESCE(o.id, a.id) filled_id, 
	a.name, 
	a.website, 
	a.lat, 
	a.long, 
	a.primary_poc, 
	a.sales_rep_id, 
	COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, 
	o.standard_qty, 
	o.gloss_qty, 
	o.poster_qty, 
	o.total, 
	o.standard_amt_usd, 
	o.gloss_amt_usd, 
	o.poster_amt_usd, 
	o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
	ON a.id = o.account_id
WHERE o.total IS NULL;


/*  5.15.4 use COALESCE to fill in each of the qty and usd columns
with zeroes for the table as per first query*/
SELECT 
	COALESCE(o.id, a.id) filled_id, 
	a.name, 
	a.website, 
	a.lat, 
	a.long, 
	a.primary_poc, 
	a.sales_rep_id, 
	COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, 
	COALESCE(o.standard_qty, 0) standard_qty, 
	COALESCE(o.gloss_qty,0) gloss_qty, 
	COALESCE(o.poster_qty,0) poster_qty, 
	COALESCE(o.total,0) total, 
	COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
	COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
	COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


/*  5.15.5 run the first query with the WHERE removed and COUNT the 
number of IDs*/
SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;


/*  5.15.6 run the previous query but with the COALESCE function used
in questions 2 throught to 4*/
SELECT 
	COALESCE(o.id, a.id) filled_id, 
	a.name, 
	a.website, 
	a.lat, 
	a.long, 
	a.primary_poc, 
	a.sales_rep_id, 
	COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, 
	COALESCE(o.standard_qty, 0) standard_qty, 
	COALESCE(o.gloss_qty,0) gloss_qty, 
	COALESCE(o.poster_qty,0) poster_qty, 
	COALESCE(o.total,0) total, 
	COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
	COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
	COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;


-- 5.17 RECAP


/*You now have a number of tools to assist in cleaning messy data in SQL.
Manually cleaning data is tedious, but you now can clean data at scale 
using your new skills.

For a reminder on any of the data cleaning functionality, the concepts in 
this lesson are labeled according to the functions you learned. If you felt 
uncomfortable with any of these functions at first, that is normal - these 
take some getting used to. Don't be afraid to take a second pass through 
the material to sharpen your skills!

Memorizing all of this functionality isn't necessary, but you do need to be 
able to follow documentation, and learn from what you have done in solving 
previous problems to solve new problems.

There are a few other functions that work similarly. You can read more about
those here. You can also get a walk through of many of the functions you 
have seen throughout this lesson here.

Nice job on this section!
*/












































































































































































































