--- LESSON 4 - SQL SUBQUERIES AND TEMPORARY TABLES ---

/* 

4.1 - What this lesson is about...

Up to this point you have learned a lot about working with data using SQL. 
This lesson will focus on three topics:

  1  Subqueries
  2  Table Expressions
  3  Persistent Derived Tables

Both SUBQUERIES and TABLE EXPRESSIONS are methods for being able to write a 
query that creates a table, and then write a query that interacts with this 
newly created table. Sometimes the question you are trying to answer doesn't 
have an answer when working directly with existing tables in database.

However, if we were able to create new tables from the existing tables, we know
we could query these new tables to answer our question. This is where the 
queries of this lesson come to the rescue.

If you can't yet think of a question that might require such a query, don't 
worry because you are about to see a whole bunch of them!


-- 4.2 SUBQUERIES

Whenever we need to use existing tables to create a new table that we then 
want to query again, this is an indication that we will need to use some sort 
of SUBQUERY. In the next couple of concepts, we will walk through an example 
together. Then you will get some practice tackling some additional problems 
on your own.


-- 4.3 Your First Subquery

The first time you write a subquery it might seem really complex. Let's try 
breaking it down into its different parts.

If you get stuck look again at the video above. We want to find the average 
number of events for each day for each channel. The first table will provide 
us the number of events for each day and channel, and then we will need to 
average these values together using a second query.

You try solving this yourself.*/

-- VIDEO EXAMPLE

-- First, we query the entire table to see if it contains the info we need
SELECT *
FROM WEB_EVENTS

-- Next, we count all events in each channel in each day
SELECT 
	DATE_TRUNC('DAY', OCCURRED_AT) AS DAY,
	CHANNEL,
	COUNT(ID) AS EVENT_COUNT
FROM WEB_EVENTS
GROUP BY 1, 2
ORDER BY 1

-- Then we want to average across the events column we just created 
-- by wrapping the query in brackets and using it as the from clause 
-- of another query - REMEMBER THAT subqueries in FROM must have an alias 
SELECT *
FROM
(SELECT 
	DATE_TRUNC('DAY', OCCURRED_AT) AS DAY,
	CHANNEL,
	COUNT(ID) AS EVENT_COUNT
FROM WEB_EVENTS
GROUP BY 1, 2
ORDER BY 1) AS SUB

-- Lastly, we calculate the average number of events for each channel

SELECT 
	CHANNEL,
	AVG(EVENT_COUNT) AS AVG_EVENT_COUNT
FROM
(SELECT 
	DATE_TRUNC('DAY', OCCURRED_AT) AS DAY,
	CHANNEL,
	COUNT(ID) AS EVENT_COUNT
FROM WEB_EVENTS
GROUP BY 1, 2
-- ORDER BY 1 -- NOTE THAT we no longer need order by in sub query
) AS SUB

GROUP BY 1
ORDER BY 2 DESC


-- NOTE THAT the inner query (or subquery) NEEDS to run independently
-- from the outer query - whenever you make a change to the inner query
-- make sure to verify it runs independently before running the outer query


-- 4.3 - QUIZ - answers are provided and submitted in the page itself 


-- 4.5 - Text: Subquery Formatting

/* SUBQUERY FORMATTING

When writing Subqueries, it is easy for your query to look incredibly 
complex. In order to assist your reader, which is often just yourself at a 
future date, formatting SQL will help with understanding your code.

The important thing to remember when using subqueries is to provide some 
way for the reader to easily determine which parts of the query will be 
executed together. Most people do this by indenting the subquery in some 
way - you saw this with the solution blocks in the previous concept.

The examples in this class are indented quite far—all the way to the 
parentheses. This isn’t practical if you nest many subqueries, but in 
general, be thinking about how to write your queries in a readable way. 
Examples of the same query written multiple different ways is provided 
below. You will see that some are much easier to read than others.
*/

/*BADLY FORMATTED QUERIES

Though these poorly formatted examples will execute the same way as the 
well formatted examples, they just aren't very friendly for understanding 
what is happening!

Here is the first, where it is impossible to decipher what is going on:
*/

SELECT * FROM (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) as events FROM web_events GROUP BY 1,2 ORDER BY 3 DESC) sub;

/*This second version, which includes some helpful line breaks, is easier 
to read than that previous version, but it is still not as easy to read as 
the queries in the Well Formatted Query section. 
*/

SELECT *
FROM (
SELECT DATE_TRUNC('day',occurred_at) AS day,
channel, COUNT(*) as events
FROM web_events 
GROUP BY 1,2
ORDER BY 3 DESC) sub;


/*WELL FORMATTED QUERY

Now for a well formatted example, you can see the table we are pulling from 
much easier than in the previous queries.
*/

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub;

/*Additionally, if we have a GROUP BY, ORDER BY, WHERE, HAVING, or any other
statement following our subquery, we would then indent it at the same level
as our outer query.

The query below is similar to the above, but it is applying additional 
statements to the outer query, so you can see there are GROUP BY and 
ORDER BY statements used on the output are not tabbed. The inner query 
GROUP BY and ORDER BY statements are indented to match the inner table.
*/

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY day, channel, events
ORDER BY 2 DESC;

/*These final two queries are so much easier to read!*/


-- 4.7 - More on subqueries

/*Subqueries Part II

In the first subquery you wrote, you created a table that you could then 
query again in the FROM statement. However, if you are only returning a 
single value, you might use that value in a logical statement like WHERE, 
HAVING, or even SELECT - the value could be nested within a CASE statement.

On the next concept, we will work through this example, and then you will 
get some practice on answering some questions on your own.

EXPERT TIP

NOTE THAT YOU SHOULD NOT INCLUDE AN ALIAS WHEN YOU WRITE A SUBQUERY IN A 
CONDITIONAL STATEMENT. THIS IS BECAUSE THE SUBQUERY IS TREATED AS AN 
INDIVIDUAL VALUE (OR SET OF VALUES IN THE IN CASE) RATHER THAN AS A TABLE.

Also, notice the query here compared a single value. If we returned an 
entire column IN would need to be used to perform a logical argument. If we 
are returning an entire table, then we must use an ALIAS for the table, and
perform additional logic on the entire table.
*/

-- VIDEO EXAMPLE

-- outer query uses inner query to filter & sort orders table by first order month
SELECT *
	FROM ORDERS
	WHERE DATE_TRUNC('MONTH', OCCURRED_AT) =
(-- subquery to get month of first ever order
SELECT 
	DATE_TRUNC('MONTH', MIN(OCCURRED_AT)) AS MIN_MONTH
FROM ORDERS
)
ORDER BY OCCURRED_AT

-- NOTE THAT this returns all transactions in Dec 2013 (4th to 31st Dec)
-- this works because the sub query result is only one cell!!!
-- if the sub query contains multiple results, we should use IN


-- 4.8 - Quiz: More On Subqueries

-- What was the month/year combo for the first order placed? Dec 2013

/*The average amount of standard paper sold on the first month that any order 
was placed in the orders table (in terms of quantity).

The average amount of gloss paper sold on the first month that any order was 
placed in the orders table (in terms of quantity).

The average amount of poster paper sold on the first month that any order was 
placed in the orders table (in terms of quantity).

The total amount spent on all orders on the first month that any order was 
placed in the orders table (in terms of usd).
*/
SELECT 
	DATE_TRUNC('MONTH', OCCURRED_AT) AS DATE,
	AVG(STANDARD_QTY) AS AVG_STD_QTY,
	AVG(GLOSS_QTY) AS AVG_GLS_QTY,
	AVG(POSTER_QTY) AS AVG_PST_QTY,
	SUM(TOTAL_AMT_USD) AS TOT_SPEND_USD
FROM ORDERS
WHERE DATE_TRUNC('MONTH', OCCURRED_AT) =
	(-- subquery to get month of first ever order
	SELECT 
		DATE_TRUNC('MONTH', MIN(OCCURRED_AT)) AS MIN_MONTH
	FROM ORDERS
	)
 GROUP BY DATE_TRUNC('MONTH', OCCURRED_AT)
 ORDER BY DATE_TRUNC('MONTH', OCCURRED_AT)

-- INTERESTINGLY, I get the same results when to use the group by and order 
-- which also requires a date in select statement to aggregate on 

-- SOLUTION
SELECT 
	AVG(standard_qty) avg_std, 
	AVG(gloss_qty) avg_gls, 
	AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);


-- 4.9 - Quiz: Subquery Mania

/*More Subqueries Quizzes

You should write your solution as a subquery or subqueries, not by finding one 
solution and copying the output. The importance of this is that it allows your 
query to be dynamic in answering the question - even if the data changes, 
you still arrive at the right answer.*/



-- 4.9.1 - Provide the name of the sales_rep in each region with the largest 
--			amount of total_amt_usd sales.

-- STEP ONE 
/*First, I wanted to find the total_amt_usd totals associated with each sales 
rep, and I also wanted the region in which they were located. The query below 
provided this information.*/
SELECT 
	R.NAME AS REGION,
	S.NAME AS SALES_REP,
	SUM(O.TOTAL_AMT_USD) AS TOTAL_SALES
FROM ORDERS O
JOIN ACCOUNTS A
	ON O.ACCOUNT_ID = A.ID
JOIN SALES_REPS S
	ON S.ID = A.SALES_REP_ID
JOIN REGION R
	ON R.ID = S.REGION_ID
GROUP BY 1, 2
ORDER BY 2

/*Next, I pulled the max for each region, and then we can use this to pull 
those rows in our final result.*/

SELECT
	REGION,
	MAX(TOTAL_SALES) AS TOTAL_SALES
FROM
	(SELECT 
		R.NAME AS REGION,
		S.NAME AS SALES_REP,
		SUM(O.TOTAL_AMT_USD) AS TOTAL_SALES
	FROM ORDERS O
	JOIN ACCOUNTS A
		ON O.ACCOUNT_ID = A.ID
	JOIN SALES_REPS S
		ON S.ID = A.SALES_REP_ID
	JOIN REGION R
		ON R.ID = S.REGION_ID
	GROUP BY 1, 2) AS T1
GROUP BY 1

/*Lastly, I JOIN this table with the original where the region and amount match
and retreive the sales-rep name.*/

-- SOLUTION
SELECT 
	T3.REP_NAME,
	T3.REGION_NAME,
	T3.TOTAL_AMT
FROM
	(SELECT REGION_NAME,
			MAX(TOTAL_AMT) TOTAL_AMT
		FROM
			(SELECT 
			 		S.NAME REP_NAME,
					R.NAME REGION_NAME,
					SUM(O.TOTAL_AMT_USD) TOTAL_AMT
				FROM SALES_REPS S
				JOIN ACCOUNTS A ON A.SALES_REP_ID = S.ID
				JOIN ORDERS O ON O.ACCOUNT_ID = A.ID
				JOIN REGION R ON R.ID = S.REGION_ID
				GROUP BY 1, 2) T1
		GROUP BY 1) T2
JOIN
	(SELECT 
	 		S.NAME REP_NAME,
			R.NAME REGION_NAME,
			SUM(O.TOTAL_AMT_USD) TOTAL_AMT
		FROM SALES_REPS S
		JOIN ACCOUNTS A ON A.SALES_REP_ID = S.ID
		JOIN ORDERS O ON O.ACCOUNT_ID = A.ID
		JOIN REGION R ON R.ID = S.REGION_ID
		GROUP BY 1,2
		ORDER BY 3 DESC) T3 
ON T3.REGION_NAME = T2.REGION_NAME 
 AND T3.TOTAL_AMT = T2.TOTAL_AMT;


-- 4.9.2 - For the region with the largest (sum) of sales total_amt_usd, 
--			how many total (count) orders were placed?

-- MY QUERY FINDS THE ANSWER WITH NO SUB QUERY, WHICH DEFIES THE POINT OF THE EXERCISE
SELECT 
	R.NAME AS REGION,
	-- S.NAME AS SALES_REP,
	SUM(O.TOTAL_AMT_USD) AS TOTAL_SALES,
	COUNT(O.ID) AS TOTAL_ORDERS
FROM ORDERS O
JOIN ACCOUNTS A
	ON O.ACCOUNT_ID = A.ID
JOIN SALES_REPS S
	ON S.ID = A.SALES_REP_ID
JOIN REGION R
	ON R.ID = S.REGION_ID
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1


-- SOLUTION
-- The first query I wrote was to pull the total_amt_usd for each region.

SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name;

/*Then we just want the region with the max amount from this table. There are 
two ways I considered getting this amount. One was to pull the max using a 
subquery. Another way is to order descending and just pull the top value.*/

SELECT MAX(total_amt)
FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY r.name) sub;

-- Finally, we want to pull the total orders for the region with this amount:

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);

-- This provides the Northeast with 2357 orders.

-- 4.9.3 - How many accounts had more total purchases than the account name 
--			which has bought the most standard_qty paper throughout their 
--			lifetime as a customer?

/*First, we want to find the account that had the most standard_qty paper. 
The query here pulls that account, as well as the total amount:*/

SELECT 
	a.name account_name, 
	SUM(o.standard_qty) total_std, 
	SUM(o.total) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Now, I want to use this to pull all the accounts with more total sales:

SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT 
							 a.name act_name, 
							 SUM(o.standard_qty) tot_std, 
							 SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) sub);

/*This is now a list of all the accounts with more total orders. 
We can get the count with just another simple subquery.*/

SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT 
							 a.name act_name, 
							 SUM(o.standard_qty) tot_std, 
							 SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;


-- 4.9.4 - For the customer that spent the most (in total over their lifetime 
--			as a customer) total_amt_usd, how many web_events did they have for
--			each channel?

-- Here, we first want to pull the customer with the most spent in lifetime value.

SELECT 
	a.id, 
	a.name, 
	SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1;

/*Now, we want to look at the number of events on each channel this company had, 
which we can match with just the id.*/

SELECT 
	a.name, 
	w.channel, 
	COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
                     FROM (SELECT 
							   a.id, 
							   a.name, 
							   SUM(o.total_amt_usd) tot_spent
                           FROM orders o
                           JOIN accounts a
                           ON a.id = o.account_id
                           GROUP BY a.id, a.name
                           ORDER BY 3 DESC
                           LIMIT 1) inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;

/*I added an ORDER BY for no real reason, and the account name to assure I was 
only pulling from one account.*/

-- 4.9.5 - What is the lifetime average amount spent in terms of total_amt_usd 
--			for the top 10 total spending accounts?

/*First, we just want to find the top 10 accounts in terms of highest total_amt_usd.*/

SELECT 
	a.id, 
	a.name, 
	SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 10;

/*Now, we just want the average of these 10 amounts.*/

SELECT AVG(tot_spent)
FROM (SELECT 
		  a.id, 
		  a.name, 
		  SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) temp;


-- 4.9.6 - What is the lifetime average amount spent in terms of total_amt_usd, 
--			including only the companies that spent more per order, on average, 
--			than the average of all orders.


/*First, we want to pull the average of all accounts in terms of total_amt_usd:*/

SELECT AVG(o.total_amt_usd) avg_all
FROM orders o

/*Then, we want to only pull the accounts with more than this average amount.*/

SELECT 
	o.account_id, 
	AVG(o.total_amt_usd)
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                               FROM orders o);

/*Finally, we just want the average of these values.*/

SELECT AVG(avg_amt)
FROM (SELECT 
	  o.account_id, 
	  AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                                   FROM orders o)) temp_table;


-- 4.11 - WITH OR COMMON TABLE EXPRESSION (CTE)

/*The WITH statement is often called a Common Table Expression or CTE. Though 
these expressions serve the exact same purpose as subqueries, they are more 
common in practice, as they tend to be cleaner for a future reader to follow 
the logic.

In the next concept, we will walk through this example a bit more slowly to 
make sure you have all the similarities between subqueries and these expressions
down for you to use in practice! If you are already feeling comfortable skip
ahead to practice the quiz section. 

NOTE THAT CTE needs to be defined at the beginning of your */


-- VIDEO EXAMPLE - ALSO, FIRST PART OF 4.12 - Text - WITH vs. Subquery

-- earlier we found the average number of events per marketing channel
SELECT 
	CHANNEL,
	AVG(EVENT_COUNT) AS AVG_EVENT_COUNT
FROM
	(SELECT 
		DATE_TRUNC('DAY', OCCURRED_AT) AS DAY,
		CHANNEL,
		COUNT(ACCOUNT_ID) AS EVENT_COUNT
	 FROM WEB_EVENTS
	 GROUP BY 1,2
	) AS SUBQUERY
GROUP BY 1

-- to make the query more readable we can write the subquery as a CTE

WITH EVENTS AS (SELECT 
		DATE_TRUNC('DAY', OCCURRED_AT) AS DAY,
		CHANNEL,
		COUNT(ACCOUNT_ID) AS EVENT_COUNT
	 FROM WEB_EVENTS
	 GROUP BY 1,2)

SELECT 
	CHANNEL,
	AVG(EVENT_COUNT) AS AVG_EVENT_COUNT
FROM EVENTS
GROUP BY 1

-- NOTE THAT if we needed to create a second table to pull from, We can create 
-- an additional table to pull from in the following way:

WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

/*You can add more and more tables using the WITH statement in the same way. 
The quiz at the bottom will assure you are catching all of the necessary 
components of these new queries.*/


-- 4.12 Quiz: WITH vs. Subquery

/*Quiz Questions

Select all of the below that are true regarding WITH statements.

FALSE - When creating multiple tables using WITH, you add a comma after every 
		table leading to your final query

TRUE - When creating multiple tables using WITH, you add a comma after every 
		table except the last table leading to your final query.

TRUE - The new table name is always aliased using table_name AS, which is 
		followed by your query nested between parentheses.

FALSE - You begin each new table using a WITh statement */


-- 4.13 - Quiz: WITH

/*Essentially a WITH statement performs the same task as a Subquery. Therefore, 
you can write any of the queries we worked with in the "Subquery Mania" using a 
WITH.*/


-- SOLUTIONS

/*Below, you will see each of the previous solutions restructured using the WITH 
clause. This is often an easier way to read a query.*/

/*4.13.1 - Provide the name of the sales_rep in each region with the largest 
amount of total_amt_usd sales.*/

    WITH t1 AS (
      SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
       FROM sales_reps s
       JOIN accounts a
       ON a.sales_rep_id = s.id
       JOIN orders o
       ON o.account_id = a.id
       JOIN region r
       ON r.id = s.region_id
       GROUP BY 1,2
       ORDER BY 3 DESC), 
    t2 AS (
       SELECT region_name, MAX(total_amt) total_amt
       FROM t1
       GROUP BY 1)
    SELECT t1.rep_name, t1.region_name, t1.total_amt
    FROM t1
    JOIN t2
    ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

/* 4.13.2 - For the region with the largest sales total_amt_usd, how many 
total orders were placed?*/

    WITH t1 AS (
       SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
       FROM sales_reps s
       JOIN accounts a
       ON a.sales_rep_id = s.id
       JOIN orders o
       ON o.account_id = a.id
       JOIN region r
       ON r.id = s.region_id
       GROUP BY r.name), 
    t2 AS (
       SELECT MAX(total_amt)
       FROM t1)
    SELECT r.name, COUNT(o.total) total_orders
    FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN orders o
    ON o.account_id = a.id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY r.name
    HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);

/* 4.13.3 - For the account that purchased the most (in total over their 
lifetime as a customer) standard_qty paper, how many accounts still had more 
in total purchases?*/

    WITH t1 AS (
      SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
      FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 1), 
    t2 AS (
      SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT total FROM t1))
    SELECT COUNT(*)
    FROM t2;

/* 4.13.4 - For the customer that spent the most (in total over their lifetime
as a customer) total_amt_usd, how many web_events did they have for each channel?*/

    WITH t1 AS (
       SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY a.id, a.name
       ORDER BY 3 DESC
       LIMIT 1)
    SELECT a.name, w.channel, COUNT(*)
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
    GROUP BY 1, 2
    ORDER BY 3 DESC;

/* 4.13.5 -  What is the lifetime average amount spent in terms of total_amt_usd
for the top 10 total spending accounts?*/

    WITH t1 AS (
       SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY a.id, a.name
       ORDER BY 3 DESC
       LIMIT 10)
    SELECT AVG(tot_spent)
    FROM t1;


/* 4.13.6 - What is the lifetime average amount spent in terms of total_amt_usd,
including only the companies that spent more per order, on average, than the 
average of all orders.*/

    WITH t1 AS (
       SELECT AVG(o.total_amt_usd) avg_all
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id),
    t2 AS (
       SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
       FROM orders o
       GROUP BY 1
       HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
    SELECT AVG(avg_amt)
    FROM t2;


/*RECAP

This lesson was the first of the more advanced sequence in writing SQL. Arguably,
the advanced features of Subqueries and CTEs are the most widely used in an 
analytics role within a company. Being able to break a problem down into the 
necessary tables and finding a solution using the resulting table is very useful
in practice.

If you didn't get the solutions to these queries on the first pass, don't be
afraid to come back another time and give them another try. Additionally, you 
might try coming up with some questions of your own to see if you can find the 
solution.

The remaining portions of this course may be key to certain analytics roles, but 
you have now covered all of the main SQL topics you are likely to use on a day 
to day basis. */





























































































































































