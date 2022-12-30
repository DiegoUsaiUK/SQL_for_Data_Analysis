--- LESSON 3 - SQL AGGREGATIONS ---

/*
In the following concepts you will be learning in detail about each of 
the aggregate functions mentioned as well as some additional aggregate 
functions that are used in SQL all the time.

COUNT - counts how many rows there are in a particular column
SUM - adds together values in a particular column
MIN & MAX - return lowest and highest values in a particular column
AVERAGE - calculates the average of all values in a particular column

These functions work down columns, NOT across rows!

Row level results are more useful when you first explore the data to get
a feel of that the database structure is, aggregations over colums become more
useful when you start looking for answers to your questions.
*/



/*
NULLs are a datatype that specifies where no data exists in SQL. 
They are often ignored in our aggregation functions, which you will get 
a first look at in the next concept using COUNT.

NULL is different from a zero in that the latter could signify that a sale 
was attempted but not completed whereas a NULL means that a sale was not
even attempted!

Notice that NULLs are different than a zero - they are cells where data does 
not exist. If you try to select cells that ate null in a WHERE clause using 
an = sign, it will not return any data because being NULL is not a value, 
is a property of the data
*/S

-- 3.3 - example in video to show role of NULLs
SELECT *
FROM accounts
WHERE id > 1500 AND id < 1600

-- account 1501 should have primary_poc empty but it does not!

SELECT *
FROM accounts
WHERE primary_poc IS NULL

-- no NULLs in primary_poc - ODD!

/*
When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. 
We don't use =, because NULL isn't considered a value in SQL. Rather, it is a 
property of the data.

NULLs - Expert Tip

There are two common ways in which you are likely to encounter NULLs:

- NULLs frequently occur when performing a LEFT or RIGHT JOIN. 
You saw in the last lesson - when some rows in the left table of 
a left join are not matched with rows in the right table, those rows 
will contain some NULL values in the result set.

- NULLs can also occur from simply missing data in our database.
*/

-- 3.4 - First Aggregation - COUNT

-- Example in video, which returns all rows meeting filter in where clause

SELECT *
FROM orders
WHERE occurred_at >= '2016-12-01'
AND occurred_at <'2017-01-01'

-- changing to COUNT(*) aggregates to one row result, to count rows that have NON NULL data

SELECT COUNT(*) AS ORDER_COUNT
FROM ORDERS
WHERE OCCURRED_AT >= '2016-12-01'
	AND OCCURRED_AT < '2017-01-01'
	
	
/*COUNT the Number of Rows in a Table
Try your hand at finding the number of rows in each table. Here is an example 
of finding all the rows in the accounts table.
*/

SELECT COUNT(*)
FROM accounts;

--But we could have just as easily chosen a column to drop into the aggregation function:

SELECT COUNT(accounts.id)
FROM accounts;

-- These two statements are equivalent, but this isn't always the case, which we will see in the next video.

-- 3.5 COUNT & NULLs

/*
Notice that COUNT does not consider rows that have NULL values. Therefore, 
this can be useful for quickly identifying which rows have missing data. 
You will learn GROUP BY in an upcoming concept, and then each of these 
aggregators will become much more useful. */

SELECT 
	COUNT(*)  AS ACCOUNT_COUNT,
	COUNT(ID) AS ACCOUNT_ID_COUNT,
	COUNT(primary_poc) AS ACCOUNT_primary_poc_COUNT
FROM ACCOUNTS

/* 
PRO TOP - you can use the difference between count of everything and count of IDs
to verify if there are any NULLS in the ID columns
If the count of an individual columns matches the number of rows in a table
there are no nulls in the column
As these retun the same number (351) you can conclude that there are no NULLs
Primary_poc should return a count of of less then 351 but the data is not 
the same as in the video
*/


-- 3.6 SUM

/*Unlike COUNT, you can only use SUM on numeric columns. However, SUM will ignore 
NULL values, as do the other aggregation functions you will see in the upcoming lessons.

Aggregation Reminder
An important thing to remember: aggregators only aggregate vertically - the values 
of a column. If you want to perform a calculation across rows, you would do this 
with simple arithmetic.

We saw this in the first lesson if you need a refresher, but the quiz in the next 
concept should assure you still remember how to aggregate across rows.
*/

-- example from video - note that SUM treats nulls as zeroes

SELECT SUM(STANDARD_QTY) AS STANDARD,
	SUM(GLOSS_QTY) AS GLOSS,
	SUM(POSTER_QTY) AS POSTER
FROM ORDERS


-- 3.7 QUIZ (3.8 is the solution)

/*Aggregation Questions

Use the SQL environment below to find the solution for each of the following questions. 
If you get stuck or want to check your answers, you can find the answers at the top 
of the next concept.
*/

-- 1 Find the total amount of poster_qty paper ordered in the orders table. 
-- CORRECT
SELECT 	SUM(POSTER_QTY) AS POSTER
FROM ORDERS

-- 2 Find the total amount of standard_qty paper ordered in the orders table.
-- CORRECT
SELECT 	SUM(STANDARD_QTY) AS STANDARD
FROM ORDERS

-- 3 Find the total dollar amount of sales using the total_amt_usd in the orders table.
-- CORRECT
SELECT 	
	SUM(STANDARD_AMT_USD) AS STANDARD_AMT_USD
FROM ORDERS

--4  Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for 
-- each order in the orders table. This should give a dollar amount for 
-- each order in the table.
-- kind of correct
SELECT 
	ID,
	SUM(STANDARD_AMT_USD) AS STANDARD_AMT_USD,
	SUM(GLOSS_AMT_USD) AS GLOSS_AMT_USD
FROM ORDERS
GROUP BY ID
ORDER BY ID

-- solution from lesson, does not require aggregation
-- and returns a row for each ID with the sum of standard and gloss
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders

--5  Find the standard_amt_usd per unit of standard_qty paper. Your solution 
-- should use both an aggregation and a mathematical operator.
-- INCORRECT
SELECT SUM(STANDARD_AMT_USD) / COUNT(STANDARD_QTY) AS STAND_PRICE_PER_UNIT
FROM ORDERS

-- solution from lesson - is different!
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders


-- 3.9 - MIN & MAX

/*
Notice that here we were simultaneously obtaining the MIN and MAX number of orders
of each paper type. However, you could run each individually.
Notice that MIN and MAX are aggregators that again ignore NULL values. 
Check the expert tip below for a cool trick with MAX & MIN.

Expert Tip

Functionally, MIN and MAX are similar to COUNT in that they can be used on 
non-numerical columns. Depending on the column type, MIN will return the lowest 
number, earliest date, or non-numerical value as early in the alphabet as possible. 
As you might suspect, MAX does the opposite — it returns the highest number, the 
latest date, or the non-numerical value closest alphabetically to “Z.”
*/

-- from video - largest single order is for poster although least popular overall
SELECT MIN(STANDARD_QTY) AS STANDARD_MIN,
	MIN(POSTER_QTY) AS POSTER_MIN,
	MIN(GLOSS_QTY) AS GLOSS_MIN,
	MAX(STANDARD_QTY) AS STANDARD_MAX,
	MAX(POSTER_QTY) AS POSTER_MAX,
	MAX(GLOSS_QTY) AS GLOSS_MAX
FROM ORDERS


-- 3.10 AVG - what can we expect at any given time

/* 
Similar to other software AVG returns the mean of the data - that is the sum 
of all of the values in the column divided by the number of values in a column.
This aggregate function again ignores the NULL values in both the numerator and 
the denominator.

If you want to count NULLs as zero, you will need to use SUM and COUNT. However,
this is probably not a good idea if the NULL values truly just represent unknown
values for a cell.

MEDIAN - Expert Tip

One quick note that a median might be a more appropriate measure of center for 
this data, but finding the median happens to be a pretty difficult thing to get 
using SQL alone — so difficult that finding a median is occasionally asked as 
an interview question.
*/


-- looks like that major poster order may have been an outlier 
-- because the avg poster order quantity is around 1/3 of standard
SELECT 
	round(AVG(STANDARD_QTY),3) AS STANDARD_AVG,
	round(AVG(POSTER_QTY),3) AS POSTER_AVG,
	round(AVG(GLOSS_QTY),3) AS GLOSS_AVG
FROM ORDERS


-- 3.11 - Quiz: MIN, MAX, & AVG (3.12 is the solution)

/*
Questions: MIN, MAX, & AVERAGE

Use the SQL environment below to assist with answering the following questions. 
Whether you get stuck or you just want to double check your solutions, my answers 
can be found at the top of the next concept.
*/

-- When was the earliest order ever placed? You only need to return the date.
-- CORRECT
SELECT MIN(occurred_at)
FROM ORDERS

--Try performing the same query as in question 1 without using an 
-- aggregation function.
-- CORRECT - NAILED IT!
SELECT occurred_at
FROM ORDERS
ORDER BY occurred_at ASC
LIMIT 1

-- When did the most recent (latest) web_event occur?
-- CORRECT
SELECT MAX(occurred_at)
FROM web_events

-- Try to perform the result of the previous query without using an 
-- aggregation function.
-- CORRECT - NAILED IT!
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1

-- Find the mean (AVERAGE) amount spent per order on each paper type, 
-- as well as the mean amount of each paper type purchased per order. 
-- Your final answer should have 6 values - one for each paper type for 
-- the average number of sales, as well as the average amount.
-- CORRECT
SELECT 
	round(AVG(STANDARD_amt_usd),3) AS STANDARD_AVG_amt_usd,
	round(AVG(POSTER_amt_usd),3) AS POSTER_AVG_amt_usd,
	round(AVG(GLOSS_amt_usd),3) AS GLOSS_AVG_amt_usd,
	round(AVG(STANDARD_QTY),3) AS STANDARD_AVG,
	round(AVG(POSTER_QTY),3) AS POSTER_AVG,
	round(AVG(GLOSS_QTY),3) AS GLOSS_AVG
FROM ORDERS


-- Via the video, you might be interested in how to calculate the MEDIAN. 
-- Though this is more advanced than what we have covered so far try finding
-- what is the MEDIAN total_usd spent on all orders?

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/*
Since there are 6912 orders - we want the average of the 3457 and 3456 order 
amounts when ordered. This is the average of 2483.16 and 2482.55. This gives 
the median of 2482.855. This obviously isn't an ideal way to compute. If we 
obtain new orders, we would have to change the limit. SQL didn't even 
calculate the median for us. The above used a SUBQUERY, but you could use any 
method to find the two necessary values, and then you just need the average 
of them.
*/

-- 3.13 GROUP BY

/*
The key takeaways here:

GROUP BY can be used to aggregate data within subsets of the data. For example,
grouping for different accounts, different regions, or different sales representatives.

KEY POINT - Any column in the SELECT statement that is not within an aggregator must 
be in the GROUP BY clause.

The GROUP BY always goes between WHERE and ORDER BY.

ORDER BY works like SORT in spreadsheet software.

GROUP BY - Expert Tip

Before we dive deeper into aggregations using GROUP BY statements, it is worth 
noting that SQL evaluates the aggregations before the LIMIT clause. If you 
don’t group by any columns, you’ll get a 1-row result—no problem there. If you 
group by a column with enough unique values that it exceeds the LIMIT number, 
the aggregates will be calculated, and then some rows will simply be omitted 
from the results.

This is actually a nice way to do things because you know you’re going to get 
the correct aggregates. If SQL cuts the table down to 100 rows, then performed 
the aggregations, your results would be substantially different. The above 
query’s results exceed 100 rows, so it’s a perfect example. In the next 
concept, use the SQL environment to try removing the LIMIT and running it 
again to see what changes.

*/

-- from video

SELECT 
	account_id,
	SUM(STANDARD_QTY) AS STANDARD_sum,
	SUM(GLOSS_QTY) AS GLOSS_sum,
	SUM(POSTER_QTY) AS POSTER_sum
FROM ORDERS

GROUP BY account_id
ORDER BY account_id


-- 3.14 - Quiz: GROUP BY

/*
Questions: GROUP BY

Use the SQL environment below to assist with answering the following questions. 
Whether you get stuck or you just want to double check your solutions, my answers 
can be found at the top of the next concept.

One part that can be difficult to recognize is when it might be easiest to use 
an aggregate or one of the other SQL functionalities. Try some of the below to see 
if you can differentiate to find the easiest solution.
*/


-- 1 - Which account (by name) placed the earliest order? Your solution should have the 
-- account name and the date of the order.
-- CORRECT - HAD TO USE GROUP BY ON ACC NAME AS i'M USING THE MIN
SELECT 
	A.NAME AS ACCOUNT_NAME,
	MIN(O.OCCURRED_AT) AS EARLIEST_ORDER_DATE
FROM ORDERS O
JOIN ACCOUNTS A 
	ON O.ACCOUNT_ID = A.ID
GROUP BY ACCOUNT_NAME
ORDER BY EARLIEST_ORDER_DATE
LIMIT 1

-- SOLUTION
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

-- 2 - Find the total sales in usd for each account. You should include two columns 
-- the total sales for each company's orders in usd and the company name.
-- CORRECT - SAME RESULT
SELECT 
	A.NAME AS ACCOUNT_NAME,
	SUM(TOTAL_AMT_USD) AS TOTAL_SALES_USD
FROM ORDERS O
JOIN ACCOUNTS A 
	ON O.ACCOUNT_ID = A.ID
GROUP BY ACCOUNT_NAME
ORDER BY TOTAL_SALES_USD DESC;

-- SOLUTION
SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

-- 3 - Via what channel did the most recent (latest) web_event occur, which account was 
-- associated with this web_event? Your query should return only three values 
-- the date, channel, and account name.
-- CORRECT
SELECT 
	W.OCCURRED_AT AS LATEST_DATE,
	A.NAME AS ACCOUNT_NAME,
	W.CHANNEL AS WEB_CHANNEL
FROM ACCOUNTS A
JOIN WEB_EVENTS W ON W.ACCOUNT_ID = A.ID
ORDER BY LATEST_DATE DESC
LIMIT 1;
	
-- SOLUTION
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;
	

-- 4 - Find the total number of times each type of channel from the web_events was used.
-- Your final table should have two columns - the channel and the number of times the 
-- channel was used.
-- CORRECT
SELECT 
	CHANNEL,
	COUNT(CHANNEL) AS FREQUENCY
FROM WEB_EVENTS
GROUP BY CHANNEL
ORDER BY FREQUENCY DESC

-- SOLUTION - ASSUMES THERE ARE NO NULLS
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel


-- 5 - Who was the primary contact associated with the earliest web_event?
-- CORRECT
SELECT 
	W.OCCURRED_AT,
	A.PRIMARY_POC
FROM ACCOUNTS A
JOIN WEB_EVENTS W
	ON A.ID = W.ACCOUNT_ID
ORDER BY OCCURRED_AT -- DESC
LIMIT 1

-- SOLUTION
SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

-- 6 - What was the smallest order placed by each account in terms of total usd. 
-- Provide only two columns - the account name and the total usd. Order from smallest 
-- dollar amounts to largest.
-- CORRECT - NAILED IT!!!
SELECT 
	A.NAME AS "ACCOUNT NAME",
	MIN(O.TOTAL_AMT_USD) AS "TOTAL AMOUNT"	
FROM ACCOUNTS A
JOIN ORDERS O
	ON O.ACCOUNT_ID = A.ID
GROUP BY "ACCOUNT NAME"
ORDER BY "TOTAL AMOUNT" DESC
	
-- SOLUTION
SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;


-- Find the number of sales reps in each region. Your final table should have two columns 
-- the region and the number of sales_reps. Order from fewest reps to most reps.
-- CORRECT - NAILED IT!!!
SELECT
	R.NAME AS REGION,
	COUNT(S.ID) AS "NUMBER OF REPS"
FROM REGION R
JOIN SALES_REPS S
	ON R.ID = S.REGION_ID
GROUP BY REGION

-- SOLUTION
SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;



-- 3.16 - GROUP BY Part II

/*
Key takeaways: You can GROUP BY multiple columns at once, as we showed here. This is often useful to 
aggregate across a number of different segments.

The order of columns listed in the ORDER BY clause does make a difference. You are 
ordering the columns from left to right.
*/

-- video example

SELECT 
	ACCOUNT_ID
	, CHANNEL
	, COUNT(ID) AS EVENTS
FROM WEB_EVENTS
GROUP BY 
	ACCOUNT_ID
	, CHANNEL
ORDER BY 
	ACCOUNT_ID 
	--, CHANNEL
	, events DESC

/*
GROUP BY - Expert Tips

The order of column names in your GROUP BY clause doesn’t matter — the results will be 
the same regardless. If we run the same query and reverse the order in the GROUP BY 
clause, you can see we get the same results.

As with ORDER BY, you can substitute numbers for column names in the GROUP BY clause. 
It’s generally recommended to do this only when you’re grouping many columns, or if 
something else is causing the text in the GROUP BY clause to be excessively long.

A reminder here that any column that is not within an aggregation must show up in your 
GROUP BY statement. If you forget, you will likely get an error. However, in the off 
chance that your query does work, you might not like the results!
*/

-- 3.16 - QUIZ - GROUP BY Part II

/* 1 - For each account, determine the average amount of each type of paper they 
purchased across their orders. Your result should have four columns - one for the 
account name and one for the average quantity purchased for each of the paper types 
for each account. */
-- correct NAILED IT!!!
SELECT 
	NAME
	, AVG(STANDARD_QTY) "Avg Standard Quantity"
	, AVG(GLOSS_QTY) "Avg Gloss Quantity"
	, AVG(POSTER_QTY) "Avg Poster Quantity"
FROM ORDERS O
JOIN ACCOUNTS A 
	ON O.ACCOUNT_ID = A.ID
GROUP BY NAME
ORDER BY 
	"Avg Standard Quantity" DESC
	, "Avg Gloss Quantity" DESC
	, "Avg Poster Quantity" DESC

--- solution

SELECT 
	a.name, 
	AVG(o.standard_qty) avg_stand, 
	AVG(o.gloss_qty)    avg_gloss, 
	AVG(o.poster_qty)   avg_post
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.name;


/* 2 - For each account, determine the average amount spent per order on each paper 
type. Your result should have four columns - one for the account name and one for the
average amount spent on each paper type.*/
-- CORRECT - NAILED IT!

SELECT 
	NAME
	, AVG(STANDARD_AMT_USD) "Avg Standard Spend"
	, AVG(GLOSS_AMT_USD) "Avg Gloss Spend"
	, AVG(POSTER_AMT_USD) "Avg Poster Spend"
FROM ORDERS O
JOIN ACCOUNTS A 
	ON O.ACCOUNT_ID = A.ID
GROUP BY NAME
ORDER BY 
	"Avg Standard Spend" DESC
	, "Avg Gloss Spend" DESC
	, "Avg Poster Spend" DESC

-- SOLUTION
SELECT 
	a.name, 
	AVG(o.standard_amt_usd) avg_stand, 
	AVG(o.gloss_amt_usd) avg_gloss, 
	AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;


/* 3 - Determine the number of times a particular channel was used in the web_events
table for each sales rep. Your final table should have three columns - the name of 
the sales rep, the channel, and the number of occurrences. Order your table with 
the highest number of occurrences first.*/
-- CORRECT - NAILED IT!
SELECT 
	S.NAME,
	W.CHANNEL,
	COUNT(W.CHANNEL) "Channel Use"
FROM ACCOUNTS A
JOIN SALES_REPS S 
	ON A.SALES_REP_ID = S.ID
JOIN WEB_EVENTS W 
	ON A.ID = W.ACCOUNT_ID
GROUP BY 
	S.NAME,
	W.CHANNEL
ORDER BY 
	"Channel Use" DESC

--- SOLUTION
SELECT 
	s.name, 
	w.channel, 
	COUNT(*) num_events
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
JOIN sales_reps s
	ON s.id = a.sales_rep_id
GROUP BY 
	s.name, 
	w.channel
ORDER BY 
	num_events DESC;


/* 4 - Determine the number of times a particular channel was used in the web_events 
table for each region. Your final table should have three columns - the region name, 
the channel, and the number of occurrences. Order your table with the highest number 
of occurrences first.*/
-- CORRECT - NAILED IT!

SELECT 
	R.NAME,
	W.CHANNEL,
	COUNT(W.CHANNEL) "Channel Use"
FROM ACCOUNTS A
JOIN SALES_REPS S 
	ON A.SALES_REP_ID = S.ID
JOIN WEB_EVENTS W 
	ON A.ID = W.ACCOUNT_ID
JOIN REGION R 
	ON S.REGION_ID = R.ID
GROUP BY 
	R.NAME,
	W.CHANNEL
ORDER BY 
	"Channel Use" DESC

--- SOLUTION
SELECT 
	r.name, 
	w.channel, 
	COUNT(*) num_events
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
JOIN sales_reps s
	ON s.id = a.sales_rep_id
JOIN region r
	ON r.id = s.region_id
GROUP BY 
	r.name, 
	w.channel
ORDER BY 
	num_events DESC;




-- 3.19 - Video: DISTINCT

/*
DISTINCT is always used in SELECT statements, and it provides the unique rows for 
all columns written in the SELECT statement. Therefore, you only use DISTINCT once 
in any particular SELECT statement. 

You could write:

SELECT 
	DISTINCT column1, column2, column3
FROM table1;

which would return the unique (or DISTINCT) rows across all three columns.

You would not write:

SELECT 
	DISTINCT column1, 
	DISTINCT column2, 
	DISTINCT column3
FROM table1;

You can think of DISTINCT the same way you might think of the statement "unique".

DISTINCT - Expert Tip
It’s worth noting that using DISTINCT, particularly in aggregations, can slow your 
queries down quite a bit.
*/


-- example in video - this returns 1509 rows.

SELECT 
	ACCOUNT_ID,
	CHANNEL,
	COUNT(ID) AS EVENTS
FROM WEB_EVENTS
GROUP BY 
	ACCOUNT_ID,
	CHANNEL
ORDER BY 
	ACCOUNT_ID,
	CHANNEL DESC

-- If I remove the count(id) I get the same row count,1509
-- obviously here I also lose the count of events

SELECT 
	ACCOUNT_ID,
	CHANNEL
FROM WEB_EVENTS
GROUP BY 
	ACCOUNT_ID,
	CHANNEL
ORDER BY 
	ACCOUNT_ID

-- and if I run the query with DISTINCT, I get the same row count again, 1509
-- and once again, here I also lose the count of events 
-- I also no longer need the GROUP BY statement as I have no aggregationS
SELECT 
	DISTINCT ACCOUNT_ID,
	CHANNEL
FROM WEB_EVENTS
ORDER BY 
	ACCOUNT_ID

-- 3.20 - Quiz: DISTINCT

-- 3.20.1 - Use DISTINCT to test if there are any accounts associated with more 
-- than one region.

SELECT 
	 A.NAME AS ACCOUNT,
	 R.NAME AS REGION
FROM ACCOUNTS A
JOIN SALES_REPS S
	ON A.SALES_REP_ID = S.ID
JOIN REGION R
	ON S.REGION_ID = R.ID 
ORDER BY ACCOUNT ASC

-- SOLUTION - required a returned row count comparison 
/*
he below two queries have the same number of resulting rows (351), 
so we know that every account is associated with only one region. 
If each account was associated with more than one region, the first
query should have returned more rows than the second query.
*/

SELECT 
	a.id as "account id", 
	r.id as "region id", 
	a.name as "account name", 
	r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;


SELECT DISTINCT id, name
FROM accounts;


-- 3.20.2 - Have any sales reps worked on more than one account?
SELECT 
	 S.NAME AS "REP NAME",
	 A.NAME AS "ACC NAME"
FROM ACCOUNTS A
JOIN SALES_REPS S
	ON A.SALES_REP_ID = S.ID
ORDER BY "REP NAME" ASC


--- SOLUTION - ANOTHER COMPARISON, WHICH i DID NOT FULLY GET 

/*Actually all of the sales reps have worked on more than one 
account. The fewest number of accounts any sales rep works on is 3. 
There are 50 sales reps, and they all have more than one account. 
Using DISTINCT in the second query assures that all of the sales 
reps are accounted for in the first query. */
SELECT 
	--s.id, 
	s.name, 
	COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
	ON s.id = a.sales_rep_id
GROUP BY 
	--s.id, 
	s.name
ORDER BY num_accounts;


-- 3.22 - Video: HAVING

/*
HAVING - Expert Tip

HAVING is the “clean” way to filter a query that has been aggregated, 
but this is also commonly done using a subquery. Essentially, any time 
you want to perform a WHERE on an element of your query that was created 
by an aggregate, you need to use HAVING instead.
*/

-- FROM VIDEO
SELECT 
	ACCOUNT_ID,
	SUM(TOTAL_AMT_USD) AS SUM_TOTAL_AMT_USD
FROM ORDERS
WHERE SUM(TOTAL_AMT_USD) >= 250000
GROUP BY 1
ORDER BY 2 DESC

/*
If I try to filter for sales greater than or equal to 250k the WHERE clause 
returns an error as does not allow to filter on aggregate functions

ERROR:  aggregate functions are not allowed in WHERE
LINE 5: WHERE SUM(TOTAL_AMT_USD) >= 250000

That's where the HAVING clause comes in handy
*/

SELECT 
	ACCOUNT_ID,
	SUM(TOTAL_AMT_USD) AS SUM_TOTAL_AMT_USD
FROM ORDERS
GROUP BY 1
HAVING SUM(TOTAL_AMT_USD) >= 250000

/* NOTE THAT this is only useful when you're aggregating by one or more 
dimensions. If aggregating across the whole dataset, you'll have a one-row
result anyway so not very useful
*/

-- 3.23 - Quiz: HAVING

/*Quiz Question

Often there is confusion about the difference between WHERE and HAVING. 
Select all the statements that are true regarding HAVING and WHERE 
statements.

- WHERE subsets the data based on a logical condition
- WHERE appears after the FROM, JOIN, and ON clauses but before GROUP BY
- HAVING appears after the GROIUP BY clause, but before ORDER BY
- HAVING is like WHERE but it works on logical statements involving aggregations

Nice job! That's right all of these statements are true. These statements 
assure you know where in your query each of these statements sits, as well 
as why you would use one over the other.
*/

-- Questions: HAVING

-- 3.23.1  How many sales reps have more than 5 accounts that they manage?
-- SAME RESULT, DIFFERENT ORDER
SELECT
	S.NAME,
	COUNT(A.ID) "Number of Accounts"
FROM ACCOUNTS A
JOIN SALES_REPS S
	ON A.SALES_REP_ID = S.ID
GROUP BY S.NAME
HAVING COUNT(A.ID) >= 5
ORDER BY "Number of Accounts" DESC

-- SOLUTION
SELECT 
	s.id, 
	s.name, 
	COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
	ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts DESC;

-- SOLUTION using previous query as a subquery
SELECT 
	COUNT(*) num_reps_above5
FROM(
	SELECT 
		s.id, 
		s.name, 
		COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY 
		s.id, 
		s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;



-- 3.23.2  How many accounts have more than 20 orders?
-- SIMILAS STRUCTURE MINUS EQUAL TO, TOP RESULTS SAME COUNT
SELECT 
	--A.ID,
	A.NAME,
	COUNT(O.ID) NUM_ORDERS
FROM ACCOUNTS A
JOIN ORDERS O
	ON A.ID = O.ACCOUNT_ID 
GROUP BY A.NAME
HAVING COUNT(O.ID) >= 20
ORDER BY COUNT(O.ID) DESC


-- SOLUTION
SELECT 
	a.id, 
	a.name, 
	COUNT(*) num_orders
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;


-- 3.23.3  Which account has the most orders?
SELECT 
	--A.ID,
	A.NAME,
	COUNT(O.ID) NUM_ORDERS
FROM ACCOUNTS A
JOIN ORDERS O
	ON A.ID = O.ACCOUNT_ID 
GROUP BY A.NAME
ORDER BY COUNT(O.ID) DESC
LIMIT 1

-- SOLUTION
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;


-- 3.23.4  Which accounts spent more than 30,000 usd total across all orders?
SELECT 
	A.NAME,
	SUM(TOTAL_AMT_USD) TOTAL_AMT
FROM ACCOUNTS A
JOIN ORDERS O
	ON A.ID = O.ACCOUNT_ID 
GROUP BY A.NAME 
HAVING SUM(TOTAL_AMT_USD) > 30000
ORDER BY TOTAL_AMT DESC

-- SOLUTION
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent DESC;

-- 3.23.5  Which accounts spent less than 1,000 usd total across all orders?
SELECT 
	A.NAME,
	SUM(TOTAL_AMT_USD) TOTAL_AMT
FROM ACCOUNTS A
JOIN ORDERS O
	ON A.ID = O.ACCOUNT_ID 
GROUP BY A.NAME 
HAVING SUM(TOTAL_AMT_USD) < 1000
ORDER BY TOTAL_AMT DESC

-- SOLUTION
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

-- 3.23.6 Which account has spent the most with us?
SELECT 
	A.NAME,
	SUM(O.TOTAL_AMT_USD) TOTAL_AMT
FROM ACCOUNTS A
JOIN ORDERS O
	ON A.ID = O.ACCOUNT_ID 
GROUP BY A.NAME 
ORDER BY TOTAL_AMT DESC
LIMIT 1

-- SOLUTION
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

-- 3.23.7 Which account has spent the least with us?
SELECT 
	A.NAME,
	SUM(O.TOTAL_AMT_USD) TOTAL_AMT
FROM ACCOUNTS A
JOIN ORDERS O
	ON A.ID = O.ACCOUNT_ID 
GROUP BY A.NAME 
ORDER BY TOTAL_AMT --ASC
LIMIT 1

-- SOLUTION
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

-- 3.23.8 Which accounts used facebook as a channel to contact 
--			customers more than 6 times?
SELECT 
	A.NAME,
	W.CHANNEL,
	COUNT(W.CHANNEL) CHANNEL
FROM ACCOUNTS A
JOIN WEB_EVENTS W
	ON A.ID = W.ACCOUNT_ID 
GROUP BY A.NAME, 	W.CHANNEL
	-- BE CAREFUL: CHANNEL SELECTION (FACEBOOK) IS CASE SENSITIVE!!!
HAVING COUNT(W.CHANNEL) > 6 AND W.CHANNEL = 'facebook'
ORDER BY COUNT(W.CHANNEL) DESC

-- SOLUTION
SELECT 
	--a.id, 
	a.name, 
	w.channel, 
	COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
GROUP BY 
	-- a.id, 
	a.name, 
	w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

-- 3.23.9 Which account used facebook most as a channel?
SELECT 
	A.NAME,
	W.CHANNEL,
	COUNT(W.CHANNEL) CHANNEL
FROM ACCOUNTS A
JOIN WEB_EVENTS W
	ON A.ID = W.ACCOUNT_ID 
GROUP BY A.NAME, 	W.CHANNEL
	-- BE CAREFUL: CHANNEL SELECTION (FACEBOOK) IS CASE SENSITIVE!!!
HAVING COUNT(W.CHANNEL) > 6 AND W.CHANNEL = 'facebook'
ORDER BY COUNT(W.CHANNEL) DESC
LIMIT 1

-- SOLUTION
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

/*
Note: This query above only works if there are no ties for the account 
that used facebook the most. It is a best practice to use a larger limit 
number first such as 3 or 5 to see if there are ties before using LIMIT 1.*/

-- 3.23.10 Which channel was most frequently used by most accounts?
-- DID NOT INCLUDE THE A.NAME DIMENSION
SELECT 
	A.NAME,
	W.CHANNEL AS ACQ_CHANNEL,
	COUNT(A.ID) NUMBER_OF_ACCOUNTS
FROM ACCOUNTS A
JOIN WEB_EVENTS W
	ON A.ID = W.ACCOUNT_ID 
GROUP BY A.NAME, W.CHANNEL
ORDER BY NUMBER_OF_ACCOUNTS DESC
LIMIT 10


-- SOLUTION
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;


-- 3.25 - DATE Functions - Part 1

/*
GROUPing BY a date column is not usually very useful in SQL, as these columns 
tend to have transaction data down to a second. Keeping date information at 
such a granular data is both a blessing and a curse, as it gives really precise
information (a blessing), but it makes grouping information together directly 
difficult (a curse).

Lucky for us, there are a number of built in SQL functions that are aimed at 
helping us improve our experience in working with dates.

Here we saw that dates are stored in year, month, day, hour, minute, second, 
which helps us in truncating. In the next concept, you will see a number of 
functions we can use in SQL to take advantage of this functionality.

In this link (https://en.wikipedia.org/wiki/Date_format_by_country) you can find the formatting of dates around the world, as 
referenced in the video.*/

-- Video Example
SELECT 
	OCCURRED_AT,
	SUM(STANDARD_QTY) STANDARD_QTY_SUM
FROM ORDERS
GROUP BY OCCURRED_AT
ORDER BY OCCURRED_AT

-- not much more useful than looking at raw data as almost all data is unique!

-- 3.26 - DATE Functions - Part 2

/*
The first function you are introduced to in working with dates is DATE_TRUNC.

DATE_TRUNC allows you to truncate your date to a particular part of your 
date-time column. Common trunctions are day, month, and year. 

Here (https://blog.modeanalytics.com/date-trunc-sql-timestamp-function-count-on/) 
is a great blog post by Mode Analytics on the power of this function.

DATE_PART can be useful for pulling a specific portion of a date, but notice 
pulling month or day of the week (dow) means that you are no longer keeping 
the years in order. Rather you are grouping for certain components regardless 
of which year they belonged in.

For additional functions you can use with dates, check out the documentation 
here (https://www.postgresql.org/docs/9.1/static/functions-datetime.html), 
but the DATE_TRUNC and DATE_PART functions definitely give you a great start!

You can reference the columns in your select statement in GROUP BY and ORDER BY
clauses with numbers that follow the order they appear in the select statement.

For example:

SELECT 
	standard_qty, 
	COUNT(*)
FROM orders
GROUP BY 1 (this 1 refers to standard_qty since it is the first of the columns included in the select statement)
ORDER BY 1 (this 1 refers to standard_qty since it is the first of the columns included in the select statement)
*/

-- Video Example - DATE_TRUNC
SELECT 
	DATE_TRUNC ('DAY', OCCURRED_AT) AS DAY, -- IT NEEDS THE 'AS' OR IT WON'T WORK
	SUM(STANDARD_QTY) STANDARD_QTY_SUM
FROM ORDERS
GROUP BY DATE_TRUNC('DAY', OCCURRED_AT)
ORDER BY DATE_TRUNC('DAY', OCCURRED_AT)

-- Make sure you GROUP BY the same dimension you're using in the select statement
-- To avoid misspelling, use numbers following the order in the GROUP BY clause

-- Video Example - DATE_PART with DOW (day of week)
-- 0 is Sunday and 6 is Saturday
SELECT
	DATE_PART('DOW', OCCURRED_AT) AS DAY_OF_WEEK,
	ACCOUNT_ID,
	OCCURRED_AT,
	TOTAL
FROM ORDERS

-- Now we can Summarise by total and order by total to see which day sees 
-- the largest number of orders - looks like most orders are places on Sundays!
SELECT
	DATE_PART('DOW', OCCURRED_AT) AS DAY_OF_WEEK,
	SUM(total) TOTAL_QTY
FROM ORDERS
GROUP BY 1
ORDER BY 2 DESC


-- 3.27 - Quiz: DATE Functions - Working With DATEs

-- 3.27.1 - Find the sales in terms of total dollars for all orders in each 
--			year, ordered from greatest to least. Do you notice any trends 
---			in the yearly sales totals?
SELECT 
	DATE_TRUNC('YEAR', OCCURRED_AT) AS YEAR,
	SUM(TOTAL_AMT_USD) TOTAL_SALES_USD
FROM ORDERS
GROUP BY 1
ORDER BY 2 DESC

-- SOLUTION
SELECT 
	DATE_PART('year', occurred_at) ord_year,  
	SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;
 
/* When we look at the yearly totals, you might notice that 2013 and 2017 have 
much smaller totals than all other years. If we look further at the monthly 
data, we see that for 2013 and 2017 there is only one month of sales for each 
of these years (12 for 2013 and 1 for 2017). Therefore, neither of these are 
evenly represented. Sales have been increasing year over year, with 2016 being 
the largest sales to date. At this rate, we might expect 2017 to have the 
largest sales. */

-- 3.27.2 - Which month did Parch & Posey have the greatest sales in terms of 
--			total dollars? Are all months evenly represented by the dataset?
SELECT 
	DATE_PART('MONTH', occurred_at) ord_month,  
	SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

-- SOLUTION - In order for this to be 'fair', we should remove the sales 
--            from 2013 and 2017. For the same reasons as discussed above.

SELECT 
	DATE_PART('month', occurred_at) ord_month, 
	SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

-- my attempt at getting an ordered time series
SELECT 
	DATE_PART('year', occurred_at) ord_year,  
	DATE_PART('MONTH', occurred_at) ord_MONTH, 
	SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1, 2
 ORDER BY 1, 2 DESC;


-- 3.27.3 - Which year did Parch & Posey have the greatest sales in terms of 
-- 			total number of orders? Are all years evenly represented by the 
--          dataset?
SELECT 
	DATE_PART('YEAR', OCCURRED_AT) AS YEAR,
	COUNT(TOTAL) TOTAL_ORDERS
FROM ORDERS
--WHERE OCCURRED_AT BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

-- SOLUTION
SELECT 
	DATE_PART('year', occurred_at) ord_year,  
	COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


-- 3.27.4 - Which month did Parch & Posey have the greatest sales in terms of 
---			total number of orders? Are all months evenly represented by the 
--			dataset?
SELECT 
	DATE_PART('MONTH', OCCURRED_AT) AS MONTH,
	COUNT(TOTAL) TOTAL_ORDERS
FROM ORDERS
WHERE OCCURRED_AT BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

-- SOLUTION
SELECT 
	DATE_PART('month', occurred_at) ord_month, 
	COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

-- 3.27.5 - In which month of which year did Walmart spend the most on gloss 
--			paper in terms of dollars?

-- Note that you have to have a.name in select statement to use HAVING
SELECT 
	DATE_PART('MONTH', O.OCCURRED_AT) AS ORDER_MONTH,
	A.NAME ACCOUNT_NAME,
	SUM(GLOSS_AMT_USD) GLOSS_PAPER_REVENUE
FROM ORDERS O
JOIN ACCOUNTS A
	ON A.ID = O.ACCOUNT_ID
GROUP BY 1, 2
HAVING A.NAME = 'Walmart'
ORDER BY 3 DESC

-- SOLUTION
SELECT 
	DATE_TRUNC('month', o.occurred_at) ord_date, 
	SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
	ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- 3.30 - CASE Statements
/*CASE - Expert Tip

The CASE statement always goes in the SELECT clause.

CASE must include the following components: WHEN, THEN, and END. 
ELSE is an optional component to catch cases that didn’t meet any of the 
other previous CASE conditions.

You can make any conditional statement using any conditional operator 
(like WHERE) (https://mode.com/sql-tutorial/sql-where/) between WHEN and THEN.
This includes stringing together multiple conditional statements using AND 
and OR.

You can include multiple WHEN statements, as well as an ELSE statement again, 
to deal with any unaddressed conditions.
*/

/*Example

In a quiz question in the previous Basic SQL lesson, you saw this question:

Create a column that divides the standard_amt_usd by the standard_qty to find
the unit price for standard paper for each order. Limit the results to the 
first 10 orders, and include the id and account_id fields. NOTE - you will be
thrown an error with the correct solution to this question. This is for a 
division by zero. You will learn how to get a solution without an error to 
this query when you learn about CASE statements in a later section.

Let's see how we can use the CASE statement to get around this error. */

SELECT 
	id, 
	account_id, 
	standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

/*Now, let's use a CASE statement. This way any time the standard_qty is zero,
we will return 0, and otherwise we will return the unit_price.*/

SELECT 
	account_id, 
	CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
         ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

/* Now the first part of the statement will catch any of those division 
by zero values that were causing the error, and the other components will 
compute the division as necessary. You will notice, we essentially charge 
all of our accounts 4.99 for standard paper. It makes sense this doesn't 
fluctuate, and it is more accurate than adding 1 in the denominator like our 
quick fix might have been in the earlier lesson.*/

-- Video example
/* To understand how facebook is working for P&P, we want to create a DERIVED
column by taking data from existing columns and modifying them.

We can use the ELSE statement to fill in all other cells not specified in 
the WHEn an THEN statements. 

We can add other channels we want to track more explicitly with and OR statement

NOTE THAT the CASE WHEN needs to finish with an END statement, where you
declare the name of the derived variable  
*/

SELECT 
	ID,
	ACCOUNT_ID,
	OCCURRED_AT,
	CHANNEL,
	CASE WHEN CHANNEL = 'facebook' OR CHANNEL = 'direct' THEN 'yes' 
		ELSE 'no'
		END AS is_facebook_or_direct
FROM WEB_EVENTS
ORDER BY OCCURRED_AT


-- other video example
SELECT
	ACCOUNT_ID,
	OCCURRED_AT,
	TOTAL,
	CASE WHEN TOTAL > 500 THEN 'OVER 500'
		 WHEN TOTAL > 300 THEN '301 - 500'
		 WHEN TOTAL > 100 THEN '101 - 300'
		 ELSE '100 OR UNDER' 
		 END AS TOTAL_GROUP
FROM ORDERS

-- NOTE THAT the statements will be evaluated in the order they're written

-- good practice would suggest to write statements that don't overlap
SELECT
	ACCOUNT_ID,
	OCCURRED_AT,
	TOTAL,
	CASE WHEN TOTAL > 500 THEN 'OVER 500'
		 WHEN TOTAL > 300 AND TOTAL <= 500 THEN '301 - 500'
		 WHEN TOTAL > 100 AND TOTAL <= 300 THEN '101 - 300'
		 ELSE '100 OR UNDER' 
		 END AS TOTAL_GROUP
FROM ORDERS


-- 3.30 - CASE & Aggregations

/*This one is pretty tricky. Try running the query yourself to make sure 
you understand what is happening. In this video, we showed that 
getting the same information using a WHERE clause means only being able 
to get one set of data from the CASE at a time.

There are some advantages to separating data into separate columns like this 
depending on what you want to do, but often this level of separation might 
be easier to do in another programming language - rather than with SQL.
*/
SELECT
	CASE WHEN TOTAL > 500 THEN 'OVER 500'
		 ELSE '500 OR UNDER' 
		 END AS TOTAL_GROUP,
	COUNT(*) AS ORDER_COUNT
FROM ORDERS
GROUP BY 1

-- with a WHERE clause
SELECT 
	COUNT(1) AS ORDERS_OVER_500_UNITS
FROM ORDERS
WHERE TOTAL > 500


-- 3.31 - CASE QUIZ


-- 3.31.1 - Write a query to display for each order, the account ID, total 
--			amount of the order, and the level of the order - ‘Large’ or 
--			’Small’ - depending on if the order is $3000 or more, or smaller 
--			than $3000.

-- CONFUSING!!!
SELECT
	O.ACCOUNT_ID,
	SUM(O.TOTAL_AMT_USD) TOTAL_AMOUNT,
	CASE WHEN SUM(O.TOTAL_AMT_USD) > 3000 THEN 'Large'
		ELSE 'Small'
		END AS AMOUNT_GROUP
FROM ORDERS O
JOIN ACCOUNTS A
	ON A.ID = O.ACCOUNT_ID
GROUP BY 1
ORDER BY 2 DESC


-- SOLUTION
SELECT 
	account_id, 
	total_amt_usd,
CASE WHEN total_amt_usd > 3000 THEN 'Large'
ELSE 'Small' END AS order_level
FROM orders
--GROUP BY 1
ORDER BY 2 DESC


-- 3.31.2 - Write a query to display the number of orders in each of three 
--			categories, based on the total number of items in each order. 
--			The three categories are: 'At Least 2000', 'Between 1000 and 2000'
--			and 'Less than 1000'.

-- I'M NOT SURE A COUNT IS CORRECT IN THIS CASE
-- IT'S ASKING FOR THE NUMBER OF ITEMS IN EACH ORDER 
-- NOT FOR THE COUNT OF ORDERS WITHIN A SPECIFIED FREQUENCY
SELECT
	SUM(TOTAL) AS TOT_ITEMS_PER_ORDER,
	CASE WHEN TOTAL >= 2000                  THEN 'At Least 2000'
		 WHEN TOTAL >= 1001 AND TOTAL < 2000 THEN 'Between 1000 and 2000'
		                                     ELSE 'Less than 1000'
		 END AS TOTAL_GROUP
FROM ORDERS
GROUP BY 2

-- SOLUTION
SELECT 
	CASE WHEN total >= 2000             THEN 'At Least 2000'
    WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
                                        ELSE 'Less than 1000' 
	END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;


-- 3.31.3 - We would like to understand 3 different levels of customers based 
--			on the amount associated with their purchases. The top level 
--			includes anyone with a Lifetime Value (total sales of all orders) 
--			greater than 200,000 usd. The second level is between 200,000 
--			and 100,000 usd. The lowest level is anyone under 100,000 usd. 
--			Provide a table that includes the level associated with each 
--			account. You should provide the account name, the total sales of 
--			all orders for the customer, and the level. Order with the top 
--			spending customers listed first.

-- NAILED IT!!!!!
SELECT 
	A.NAME AS ACCOUNT_NAME,
	SUM(O.TOTAL_AMT_USD) AS TOTAL_SALES_USD,
	CASE WHEN SUM(O.TOTAL_AMT_USD) > 200000 THEN 'Over 200k'
		 WHEN SUM(O.TOTAL_AMT_USD) > 100000 
		  AND SUM(O.TOTAL_AMT_USD) <=200000 THEN 'Between 100k and 200k'
											ELSE 'Less then 100k'
		END AS SALES_GROUP
FROM ORDERS O
JOIN ACCOUNTS  A
	ON A.ID = O.ACCOUNT_ID
GROUP BY 1
ORDER BY 2 DESC


-- SOLUTION
SELECT 
	a.name, 
	SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

-- 3.31.4 - We would now like to perform a similar calculation to the first, 
--			but we want to obtain the total amount spent by customers only in 
--			2016 and 2017. Keep the same levels as in the previous question. 
--			Order with the top spending customers listed first.

-- SAME RESULTS
SELECT 
	A.NAME AS ACCOUNT_NAME,
	SUM(O.TOTAL_AMT_USD) AS TOTAL_SALES_USD,
	CASE WHEN SUM(O.TOTAL_AMT_USD) > 200000 THEN 'Over 200k'
		 WHEN SUM(O.TOTAL_AMT_USD) > 100000 
		  AND SUM(O.TOTAL_AMT_USD) <=200000 THEN 'Between 100k and 200k'
											ELSE 'Less then 100k'
		END AS SALES_GROUP
FROM ORDERS O
JOIN ACCOUNTS  A
	ON A.ID = O.ACCOUNT_ID
WHERE 
	DATE_PART('YEAR', o.occurred_at) >= '2016' AND 
	DATE_PART('YEAR', o.occurred_at) <= '2017'
GROUP BY 1
ORDER BY 2 DESC

-- SOLUTION
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     	  WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     	  ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;

-- 3.31.5 - We would like to identify top performing sales reps, which are sales
--			reps associated with more than 200 orders. Create a table with 
--			the sales rep name, the total number of orders, and a column with 
--			top or not depending on if they have more than 200 orders. 
--			Place the top sales people first in your final table.

-- SAME RESULTS - NAILED IT!!!
SELECT 
	S.NAME AS SALES_REP_NAME,
	COUNT(O.TOTAL) AS TOT_NUMBER_OF_ORDERS,
	CASE WHEN COUNT(O.TOTAL) > 200 THEN 'Top Rep'
		 ELSE  'Bottom Rep'
	END AS REP_LEVEL
FROM ORDERS O
JOIN ACCOUNTS A
	ON A.ID = O.ACCOUNT_ID
JOIN SALES_REPS S
	ON A.SALES_REP_ID = S.ID
GROUP BY 1
ORDER BY 2 DESC
	
-- SOLUTION
SELECT 
	s.name, 
	COUNT(*) num_ords,
     CASE WHEN COUNT(*) > 200 THEN 'top'
     ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;

-- 3.31.6 - The previous didn't account for the middle, nor the dollar amount 
--			associated with the sales. Management decides they want to see these
--			characteristics represented as well. We would like to identify top 
--			performing sales reps, which are sales reps associated with more 
--			than 200 orders or more than 750000 in total sales. The middle group
--			has any rep with more than 150 orders or 500000 in sales. 
--			Create a table with the sales rep name, the total number of orders, 
--			total sales across all orders, and a column with top, middle, or 
--			low depending on this criteria. Place the top sales people based on 
--			dollar amount of sales first in your final table. You might see a 
--			few upset sales people by this criteria!

SELECT 
	S.NAME AS SALES_REP_NAME,
	COUNT(O.TOTAL) AS TOT_NUMBER_OF_ORDERS,
	CASE WHEN COUNT(O.TOTAL) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'Top Rep'
		 WHEN COUNT(O.TOTAL) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'Middle Rep'
		 ELSE  'Bottom Rep'
	END AS REP_LEVEL
FROM ORDERS O
JOIN ACCOUNTS A
	ON A.ID = O.ACCOUNT_ID
JOIN SALES_REPS S
	ON A.SALES_REP_ID = S.ID
GROUP BY 1
ORDER BY 2 DESC


-- solution
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;

























































































s