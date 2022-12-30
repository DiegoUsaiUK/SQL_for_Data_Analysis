--- BASIC JOIN ---

--- the SELECT clause indicates which column(s) of data you'd like to see in the output 
SELECT orders.*,
	    accounts.*
--- The FROM clause indicates the first table from which we're pulling data...
	FROM orders
--- ...and the JOIN indicates the second table.
	JOIN accounts
--- The ON clause specifies the column on which you'd like to merge the two tables together
	ON orders.account_id = accounts.account_id;
	
/* If we wanted to only pull individual elements from either the orders or accounts table, we can do this by using the exact same information in the FROM and ON statements. However, in your SELECT statement, you will need to know how to specify tables and columns in the SELECT statement:

    - The table name is always before the period.
    - The column you want from that table is always after the period.
 */

SELECT accounts.name, 
		orders.occurred_at
	FROM orders
	JOIN accounts
	ON orders.account_id = accounts.account_id;

--- Alternatively, the below query pulls all the columns from both the accounts and orders table.

SELECT *
	FROM orders
	JOIN accounts
	ON orders.account_id = accounts.account_id;

/* Joining tables allows you access to each of the tables in the SELECT statement through the table name, 
and the columns will always follow a . after the table name. */


--- Entity Relationship Diagrams (ERD)

/* Some of the columns in the tables have PK or FK next to the column name, while other columns don't have 
a label at all. */


--- Keys

/*
Primary Key (PK)

The PK here stands for primary key. A primary key exists in every table, and it is a column that has a unique value for every row.
If you look at the first few rows of any of the tables in our database, you will notice that this first, PK, column is always unique. 

A primary key is a unique column in a particular table. This is the first column in each of our tables. Here, those columns are all called id, but that doesn't necessarily have to be the name. It is common that the primary key is the first column in our tables in most databases.


Foreign Key (FK)

A foreign key is a column in one table that is a primary key in a different table. We can see in the Parch & Posey ERD that the foreign keys are:

    region_id
    account_id
    sales_rep_id

Each of these is linked to the primary key of another table. In the P&P DB, each foreigh=n key is associated with 
the crow-foot notation, suggesting it can appear multiple times in the column of a table.
*/


/*
The way we join any two tables is linking the PK and FK, generally in an ON statement.

Note that the 2 forms in the ON statement produce the same result

SELECT orders.*
	FROM orders
	JOIN accounts
--- LHS: FK - RHS: PK
	ON orders.account_id = accounts.account_id;
--- RHS: PK - LHS: FK
	ON accounts.account_id = orders.account_id;
*/

--- PRACTICE

--- Join the sales_reps and region tables together

SELECT *
	--- can also swap around the table in the FROM and JOIN clauses, as long as the ON statement is correctly spelled out
	FROM sales_reps
	JOIN region
	---ON sales_reps.region_id = region.id;
	ON region.id = sales_reps.region_id;
	

--- 2.10 - ALIAS

/*
When we JOIN tables together, it is nice to give each table an alias. Frequently an alias is just the first letter 
of the table name. You actually saw something similar for column names in the Arithmetic Operators concept.
The alias for a table will normally be created in the FROM of JOIN clauses

TIP: best practice is to use lower case for the alias and underscore instead of dot

Example:

FROM tablename AS t1
JOIN tablename2 AS t2

Before, you saw something like:

SELECT col1 + col2 AS total, 
		col3

Frequently, you might also see these statements without the AS statement. 
Each of the above could be written in the following way instead, and they would still produce the exact same results:

FROM tablename t1
JOIN tablename2 t2

and

SELECT col1 + col2 total, 
		col3

Aliases for Columns in Resulting Table

While aliasing tables is the most common use case. It can also be used to alias the columns selected to have the resulting table reflect a more readable name.

Example:

Select  t1.column1 aliasname, 
		t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

The alias name fields will be what shows up in the returned table instead of t1.column1 and t2.column2
aliasname 	aliasname2
example row 	example row
example row 	example row

*/

--- Notes from video lecture:
/* 
1 - simply add a space and a character (or combination of characters) in the FROM or JOIN
2 - once the alias is declared in the FROM or JOIN clause, you can change it throughout the query
*/

SELECT o.*,
		a.*
	FROM orders o 
	JOIN accounts a
	ON o.account_id = a.account_id;


--- 2.11 - Questions 

/* 
Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
Be sure to include the primary_poc, time of the event, and the channel for each event. 
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
*/

--- RIGHT! 
SELECT a.primary_poc,
		a.name  AS acc_name,
		we.occurred_at,
		we.channel
	FROM accounts a
	JOIN web_events we
	ON a.account_id = we.account_id
	WHERE a.name LIKE 'Walmart';


/*
Provide a table that provides the region for each sales_rep along with their associated accounts. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/

--- RIGHT! 
SELECT a.name AS account,
		sr.name AS rep_name,
		r.name AS region
	FROM accounts a
	JOIN sales_reps sr
	ON a.sales_rep_id = sr.id
	JOIN region r
	ON sr.region_id = r.id
	ORDER BY account;

/*
Provide the name for each region for every order, as well as the account name and the unit price 
they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, 
account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

--- DID NOT KNOW HOW TO CALCULATE IN THE SELECT STATEMENT :(
SELECT a.name account,
		r.name region,
		o.total_amt_usd/(o.total + 0.01) unit_price
	FROM accounts a
	JOIN sales_reps sr
	ON a.sales_rep_id = sr.id
	JOIN region r
	ON sr.region_id = r.id
	JOIN orders o
	ON o.account_id = a.account_id;
		

--- 2.13/14 - Other joins

/* INNER JOIN only returns rows that are present in both tables

NOTE: it works the same without the INNER

WARNING: results are DIFFERENT from thse shown in the video, where only 5 results are shown
but account 1031 DOES HAVE orders clocked against it (the video states the opposite)

CHECK: I ran query below in their built in query window, which DID NOT return the results in the video.
Hence, the example refers to the made up tables in the video - you cannot chack code validity on actual P&P Database
*/ 

SELECT a.account_id,
		a.name,
		o.total
	FROM orders o
	/* INNER */ JOIN accounts a
	ON o.account_id = a.account_id


/* SQL CONVENSIONS

SELECT *
	FROM       left table   --- table in the FROM statement is considered the left table
	JOIN       right table  --- table in the JOIN statement is considered the right table
	
Adding a LEFT in the JOIN statement will INCLUDE in results all elements in COMMON (as in the INNER JOIN) 
	PLUS the additional rows in the "left table" 
Conversely, adding a RIGHT in the JOIN statement will INCLUDE in results all elements in COMMON (as in the INNER JOIN) 
	PLUS the additional rows in the "right table" 

The followig queries return the same resulting table - they're equivalent.

SELECT a.account_id, a.name, o.total
	FROM orders o
	RIGHT JOIN accounts a
	ON o.account_id = a.account_id

SELECT a.account_id, a.name, o.total
	FROM accounts a
	LEFT JOIN orders o
	ON o.account_id = a.account_id

However, you rarely see a RIGHT JOIN "in the wild". 
It is an accepted convention to use LEFT JOIN ONLY as it simplifies reading and understand other people's queries
*/




--- 2.15 - OUTER JOINS

/*
You might see the SQL syntax of:

LEFT OUTER JOIN OR RIGHT OUTER JOIN

These are the exact same commands as the LEFT JOIN and RIGHT JOIN we learned about in the previous video.


The last type of join is a FULL OUTER JOIN. This will return the inner join result set, as well as any unmatched rows 
from either of the two tables being joined.

Again this returns rows that do not match one another from the two tables. The use cases for a full outer join are very rare.
You can see examples of outer joins at the link here (http://www.w3resource.com/sql/joins/perform-a-full-outer-join.php) 
and a description of the rare use cases here (https://stackoverflow.com/questions/2094793/when-is-a-good-situation-to-use-a-full-outer-join)
We will not spend time on these given the few instances you might need to use them.

Similar to the above, you might see the language FULL OUTER JOIN, which is the same as OUTER JOIN.
*/


--- 2.18 - JOINS & Filtering

/*
when the database executes this query, it executes the join and everything in the ON clause first. 
Think of this as building the new result set. That result set is then filtered using the WHERE clause.


The fact that this example is a left join is important. Because inner joins only return the rows 
for which the two tables match, moving this filter to the ON clause of an inner join will produce 
the same result as keeping it in the WHERE clause.

TO SUMMARISE: - logic in the ON clause reduces rows before combining tables!
              - logic in the WHERE clause happens after the JOIN occurs
*/

SELECT orders.*,
		accounts.*
	FROM orders
	LEFT JOIN accounts
	ON orders.account_id = accounts.account_id
	WHERE accounts.sales_rep_id = 321500;
	
--- 134 rows returned because it fiters to sales_rep_id = 321500 AFTER the join!!!

/*
swapping the WHERE for and AND clause INCLUDES the filtering into the ON clause, 
in fact pre-filtering the "right table" by the condition stated before the join is executed
*/

SELECT orders.*,
		accounts.*
	FROM orders
	LEFT JOIN accounts
	ON orders.account_id = accounts.account_id
	AND accounts.sales_rep_id = 321500
	ORDER BY sales_rep_id DESC;

--- 6912 rows returned because it INCLUDES ALL ROWS from orders and "appends" all rows from accounts
--- BUT only those where sales_rep_id = 321500 have information in them, others are NULL.

--- 2.19 - Quiz

/*
1 - Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for the Midwest region. Your final table should include three columns: the region name, 
the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

--- mine
SELECT r.name AS region,
		sr.name AS rep_name,
		a.name AS account
	FROM accounts a
	JOIN sales_reps sr
	ON sr.id = a.sales_rep_id 
	JOIN region r
	ON r.id = sr.region_id
	WHERE r.name LIKE 'Midwest' 
	ORDER BY account ASC;
	
--- solution: result tables are identical!!!
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;
	
--- 48 rows affected

/*
2 - Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/

--- mine
SELECT r.name AS region,
		sr.name AS rep_name,
		a.name AS account
	FROM accounts a
	JOIN sales_reps sr
	ON sr.id = a.sales_rep_id 
	JOIN region r
	ON r.id = sr.region_id
	WHERE r.name LIKE 'Midwest' 
		AND sr.name LIKE 'S%' 
	ORDER BY account ASC;

--- solution: result tables are identical!!!
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

/*
3 - Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/

--- mine
SELECT r.name AS region,
		sr.name AS rep_name,
		a.name AS account
	FROM accounts a
	JOIN sales_reps sr
	ON sr.id = a.sales_rep_id 
	JOIN region r
	ON r.id = sr.region_id
	WHERE r.name LIKE 'Midwest' 
		AND sr.name LIKE '% K%' 
	ORDER BY account ASC;

--- solution: result tables are identical!!!
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;


/*
4 - Provide the name for each region for every order, as well as the account name and the unit price 
they paid (total_amt_usd/total) for the order. However, you should only provide the results if 
the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, 
and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful 
total_amt_usd/(total+0.01).
*/

--- mine
SELECT r.name AS region,
		a.name AS account,
		o.total_amt_usd/(o.total + 0.01) AS unit_price
	FROM accounts a
	JOIN sales_reps sr
	ON sr.id = a.sales_rep_id 
	JOIN region r
	ON r.id = sr.region_id
	JOIN orders o
	ON o.account_id = a.account_id
	WHERE o.standard_qty > 100;

--- solution: result tables are identical!!!
SELECT R.NAME REGION,
	A.NAME ACCOUNT,
	O.TOTAL_AMT_USD / (O.TOTAL + 0.01) UNIT_PRICE
FROM REGION R
JOIN SALES_REPS S ON S.REGION_ID = R.ID
JOIN ACCOUNTS A ON A.SALES_REP_ID = S.ID
JOIN ORDERS O ON O.ACCOUNT_ID = A.ACCOUNT_ID
WHERE O.STANDARD_QTY > 100;
/*
5 - Provide the name for each region for every order, as well as the account name and the unit price 
they paid (total_amt_usd/total) for the order. However, you should only provide the results if 
the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table 
should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful 
(total_amt_usd/(total+0.01).
*/

--- mine
SELECT r.name AS region,
		a.name AS account,
		o.total_amt_usd/(o.total + 0.01) AS unit_price
	FROM accounts a
	JOIN sales_reps sr
	ON sr.id = a.sales_rep_id 
	JOIN region r
	ON r.id = sr.region_id
	JOIN orders o
	ON o.account_id = a.account_id
	WHERE o.standard_qty > 100
		AND o.poster_qty > 50
	ORDER BY unit_price ASC;
	
--- solution: result tables are identical!!!
SELECT R.NAME REGION,
	A.NAME ACCOUNT,
	O.TOTAL_AMT_USD / (O.TOTAL + 0.01) UNIT_PRICE
FROM REGION R
JOIN SALES_REPS S ON S.REGION_ID = R.ID
JOIN ACCOUNTS A ON A.SALES_REP_ID = S.ID
JOIN ORDERS O ON O.ACCOUNT_ID = A.ACCOUNT_ID
WHERE O.STANDARD_QTY > 100
	AND O.POSTER_QTY > 50
ORDER BY UNIT_PRICE;
	
	
/*
6 - Provide the name for each region for every order, as well as the account name and the unit price 
they paid (total_amt_usd/total) for the order. However, you should only provide the results if 
the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table 
should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful 
(total_amt_usd/(total+0.01).
*/

--- mine
SELECT r.name AS region,
		a.name AS account,
		o.total_amt_usd/(o.total + 0.01) AS unit_price
	FROM accounts a
	JOIN sales_reps sr
	ON sr.id = a.sales_rep_id 
	JOIN region r
	ON r.id = sr.region_id
	JOIN orders o
	ON o.account_id = a.account_id
	WHERE o.standard_qty > 100
		AND o.poster_qty > 50
	ORDER BY unit_price DESC;

--- solution: result tables are identical!!!
SELECT R.NAME REGION,
	A.NAME ACCOUNT,
	O.TOTAL_AMT_USD / (O.TOTAL + 0.01) UNIT_PRICE
FROM REGION R
JOIN SALES_REPS S ON S.REGION_ID = R.ID
JOIN ACCOUNTS A ON A.SALES_REP_ID = S.ID
JOIN ORDERS O ON O.ACCOUNT_ID = A.ACCOUNT_ID
WHERE O.STANDARD_QTY > 100
	AND O.POSTER_QTY > 50
ORDER BY UNIT_PRICE DESC;
/*
7 - What are the different channels used by account id 1001? Your final table should have only 2 columns: 
account name and the different channels. You can try SELECT DISTINCT to narrow down the results to 
only the unique values.
*/

--- mine
SELECT DISTINCT A.NAME AS ACCOUNT,
	WE.CHANNEL AS CHANNEL
FROM ORDERS O
JOIN ACCOUNTS A ON O.ACCOUNT_ID = A.ACCOUNT_ID
JOIN WEB_EVENTS WE ON A.ACCOUNT_ID = WE.ACCOUNT_ID WHERE a.account_id = '1001';


--- solution: result tables are identical!!!	
SELECT DISTINCT A.NAME,
	W.CHANNEL
FROM ACCOUNTS A
JOIN WEB_EVENTS W ON A.ID = W.ACCOUNT_ID
WHERE A.ID = '1001';


/*
8 - Find all the orders that occurred in 2015. Your final table should have 4 columns: 
occurred_at, account name, order total, and order total_amt_usd.
*/

--- mine
SELECT
		o.occurred_at AS date,
		a.name AS account,
		o.total AS total,
		o.total_amt_usd AS amount
	FROM orders o
	JOIN accounts a
	ON o.account_id = a.account_id
	WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016';
	
--- solution: result tables are identical!!!	
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.account_id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;


--- 2.21  Recap

/*
Primary and Foreign Keys

You learned a key element for JOINing tables in a database has to do with primary and foreign keys:

- primary keys - are unique for every row in a table. These are generally the first column in our database 
  (like you saw with the id column for every table in the Parch & Posey database).
- foreign keys - are the primary key appearing in another table, which allows the rows to be non-unique.

Choosing the set up of data in our database is very important, but not usually the job of a data analyst. 
  This process is known as Database Normalization.
  
  
JOINs

In this lesson, you learned how to combine data from multiple tables using JOINs. The three JOIN statements 
you are most likely to use are:

- JOIN - an INNER JOIN that only pulls data that exists in both tables.
- LEFT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table 
    in the FROM even if they do not exist in the JOIN statement.
- RIGHT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table 
    in the JOIN even if they do not exist in the FROM statement.

There are a few more advanced JOINs that we did not cover here, and they are used in very specific use cases. 
UNION and UNION ALL (https://www.w3schools.com/sql/sql_union.asp), CROSS JOIN (http://www.w3resource.com/sql/joins/cross-join.php), 
and the tricky SELF JOIN (https://www.w3schools.com/sql/sql_join_self.asp). 
These are more advanced than this course will cover, but it is useful to be aware that they exist, as they 
are useful in special cases.


Alias

You learned that you can alias tables and columns using AS or not using it. This allows you to be more 
efficient in the number of characters you need to write, while at the same time you can assure that your 
column headings are informative of the data in your table.


Looking Ahead

The next lesson is aimed at aggregating data. You have already learned a ton, but SQL might still feel a bit disconnected from statistics and using Excel like platforms. Aggregations will allow you to write SQL code that will allow for more complex queries, which assist in answering questions like:

    Which channel generated more revenue?
    Which account had an order with the most items?
    Which sales_rep had the most orders? or least orders? How many orders did they have?

*/

