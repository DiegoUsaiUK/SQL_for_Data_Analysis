-- 1.34 - LIKE operator

/* The LIKE operator is extremely useful for working with text. You will use LIKE within a WHERE clause. 
The LIKE operator is frequently used with %. The % tells us that we might want any number of characters 
leading up to a particular set of characters or following a certain set of characters, as we saw with 
the google syntax above. Remember you will need to use single quotes for the text you pass to the LIKE operator, 
because of this lower and uppercase letters are not the same within the string. 
Searching for 'T' is not the same as searching for 't'. In other SQL environments (outside the classroom), 
you can use either single or double quotes.

Hopefully you are starting to get more comfortable with SQL, as we are starting to move toward operations 
that have more applications, but this also means we can't show you every use case. Hopefully, you can start 
to think about how you might use these types of applications to identify phone numbers from a certain region, 
or an individual where you can't quite remember the full name.                

EXPERT TIP - If I use an equal sign in the "where" clause I get zero result  */

-- similar to example in course video 
SELECT *
FROM accounts
WHERE website LIKE '%.mic%'


-- 1.35 - QUIZ - lesson 1 
-- Questions using the LIKE operator

/* Use the accounts table to find    All the companies whose names start with 'C' */
SELECT 
	id,
	--account_id,
	name
FROM accounts
WHERE name LIKE 'C%';


/* Use the accounts table to find    All companies whose names contain the string 'one' somewhere in the name.  */
SELECT 
	id,
	--account_id,
	name
FROM accounts
WHERE name LIKE '%one%';


/* Use the accounts table to find    All companies whose names end with 's'.  */
SELECT 
	id,
	--account_id,
	name
FROM accounts
WHERE name LIKE '%s';


-- 1.37 - IN operator

/* The IN operator is useful for working with both numeric and text columns. This operator allows you 
to use an =, but for more than one item of that particular column. We can check one, two or many 
column values for which we want to pull data, but all within the same query. In the upcoming concepts, 
you will see the OR operator that would also allow us to perform these tasks, but the IN operator 
is a cleaner way to write these queries.

Expert Tip

In most SQL environments, although not in our Udacity's classroom, you can use single or double 
quotation marks - and you may NEED to use double quotation marks if you have an apostrophe within 
the text you are attempting to pull.
In our Udacity SQL workspaces, note you can include an apostrophe by putting two single quotes together. 
For example, Macy's in our workspace would be 'Macy''s'. */

-- EXAMPLE from video
SELECT *
FROM accounts
WHERE name IN ('Walmart' , 'Apple');


-- 1.38 - QUIZ - lesson 1 
-- Questions using IN operator

/*    Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom. */
SELECT 
	name, 
	primary_poc, 
	sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


/*    Use the web_events table to find all information regarding individuals who were contacted 
via the channel of organic or adwords. */
SELECT -- DISTINCT
	account_id,
	channel
FROM web_events
WHERE channel IN ('direct', 'adwords')
ORDER BY account_id ASC;


-- NOT operator

/* The NOT operator is an extremely useful operator for working with the previous two operators we introduced: 
IN and LIKE. By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular criteria. */

-- EXAMPLE from video - all accounts handles by 2 sales reps 321500 , 321570
-- adding NOT to filter to those account NOT handled by 2 sales reps
SELECT 
	sales_rep_id,
	name
FROM accounts
WHERE sales_rep_id NOT IN (321500 , 321570);


-- 1.41 - QUIZ - lesson 1 
-- Questions using the NOT operator

-- We can pull all of the rows that were excluded from the queries in the previous two concepts with our new operator.

/*  Use the accounts table to find the account name, primary poc, and sales rep id for all stores 
	except Walmart, Target, and Nordstrom. */
SELECT 
	name, 
	primary_poc, 
	sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

/*    Use the web_events table to find all information regarding individuals who were contacted 
via any method except using organic or adwords methods. */
SELECT -- DISTINCT
	account_id,
	channel
FROM web_events
WHERE channel NOT IN ('direct', 'adwords')
ORDER BY channel ASC;


-- Use the accounts table to find

/*    All the companies whose names do not start with 'C'. */
SELECT 
	id,
	--account_id,
	name
FROM accounts
WHERE name NOT LIKE 'C%';

/*    All companies whose names do not contain the string 'one' somewhere in the name. */
SELECT 
	id,
	--account_id,
	name
FROM accounts
WHERE name NOT LIKE '%one%';

/* All companies whose names do not end with 's'.  */
SELECT 
	id,
	--account_id,
	name
FROM accounts
WHERE name NOT LIKE '%s';

-- AND and BETWEEN operators

/* The AND operator is used within a WHERE statement to consider more than one logical clause at a time. 
Each time you link a new statement with an AND, you will need to specify the column you 
are interested in looking at. 
You may link as many statements as you would like to consider at the same time. 
This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /). 
LIKE, IN, and NOT logic can also be linked together using the AND operator.  */

-- Example from video
SELECT *
FROM orders
where occurred_at >= '2016-04-01' AND occurred_at < '2016-10-01'
ORDER BY occurred_at DESC; -- order desc to check all orders after 2016-10-01 are excluded


/* Sometimes we can make a cleaner statement using BETWEEN than we can using AND. 
Particularly this is true when we are using the same column for different parts of our AND statement. 

Instead of writing :
WHERE column >= 6 AND column <= 10

we can instead write, equivalently:
WHERE column BETWEEN 6 AND 10

 */

-- Example from video
SELECT *
FROM orders
where occurred_at BETWEEN '2016-04-01' AND '2016-10-01'
ORDER BY occurred_at DESC; -- order desc to check all orders after 2016-10-01 are excluded


-- 1.44 - QUIZ - lesson 1 
-- Questions using AND and BETWEEN operators

/*    Write a query that returns all the orders where the standard_qty is over 1000, 
the poster_qty is 0, and the gloss_qty is 0 */
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;


/*    Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'. */
SELECT 
	*
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE 's';



/*    When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? 
Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data 
for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator 
included the begin and end values or not. */
SELECT
	occurred_at,
	gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 and 29
ORDER BY gloss_qty DESC;

-- So the answer to the question is that yes, the BETWEEN operator in SQL is inclusive; 
-- that is, the endpoint values are included. 


/*    Use the web_events table to find all information regarding individuals who were contacted via 
the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest. */
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') 
	AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
	
-- You will notice that using BETWEEN is tricky for dates! While BETWEEN is generally inclusive of endpoints, 
-- it assumes the time is at 00:00:00 (i.e. midnight) for dates. This is the reason why we set the right-side endpoint 
-- of the period at '2017-01-01'.



-- OR operator

/* Similar to the AND operator, the OR operator can combine multiple statements. Each time you link a new statement 
with an OR, you will need to specify the column you are interested in looking at. You may link as many statements 
as you would like to consider at the same time. This operator works with all of the operations we have seen so far 
including arithmetic operators (+, *, -, /), LIKE, IN, NOT, AND, and BETWEEN logic can all be linked together using 
the OR operator. */

-- Example from first video - I believe it's trying to find all combinations where at least one of the 3 is zero (YES, it is)
SELECT
	account_id,
	occurred_at,
	standard_qty,
	gloss_qty,
	poster_qty
FROM orders
-- DOES NOT WORK COZ NULLS ARE SUPPOSED TO BE ZEROES 
-- comment from my original import from excel files -> it works on T15 coz I created DB via code!
 WHERE standard_qty = 0 
	OR gloss_qty = 0
	OR poster_qty = 0
	-- adding an extra OR would have total number returned grow as queries becomes more inclusive
ORDER BY standard_qty DESC

/* When combining multiple of these operations, we frequently might need to use parentheses to assure that logic we want 
to perform is being executed correctly. The video below shows an example of one of these situations.  
In brackets the OR chain of statements is being combined so that you can add and AND statement in the WHERE clause
*/

-- Example from second video
SELECT
	account_id,
	occurred_at,
	standard_qty,
	gloss_qty,
	poster_qty
FROM orders
-- wrap them in () so that if one of the logical statement is true the whole statement is true
WHERE (standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0)
	AND occurred_at >= '2016-10-01'
ORDER BY standard_qty DESC


-- 1.47 - QUIZ - lesson 1
-- Questions using the OR operator


/* Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table.  */
SELECT id	
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;


/*   Write a query that returns a list of orders where the standard_qty 
is zero and either the gloss_qty or poster_qty is over 1000.   */
SELECT *	
FROM orders
WHERE (gloss_qty > 1000 OR poster_qty > 1000)
	AND standard_qty IS NULL;


/*   Find all the company names that start with a 'C' or 'W', and the primary contact 
contains 'ana' or 'Ana', but it doesn't contain 'eana'.   */
SELECT 
	name,
	primary_poc
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
	AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
	AND primary_poc NOT LIKE '%eana%')

-- Recap
/* Commands

You have already learned a lot about writing code in SQL! 
Let's take a moment to recap all that we have covered before moving on: */

-- Statement 	How to Use It 	               	Other Details
-- SELECT 	    SELECT Col1, Col2, ... 	       	Provide the columns you want
-- FROM 	    FROM Table 						Provide the table where the columns exist
-- LIMIT 	    LIMIT 10 						Limits based number of rows returned
-- ORDER BY 	ORDER BY Col 					Orders table based on the column. Used with DESC.
-- WHERE 	    WHERE Col > 5 					A conditional statement to filter your results
-- LIKE 	    WHERE Col LIKE '%me%' 			Only pulls rows where column has 'me' within the text
-- IN 	        WHERE Col IN ('Y', 'N') 		A filter for only rows with column of 'Y' or 'N'
-- NOT      	WHERE Col NOT IN ('Y', 'N') 	NOT is frequently used with LIKE and IN
-- AND      	WHERE Col1 > 5 AND Col2 < 3 	Filter rows where two or more conditions must be true
-- OR       	WHERE Col1 > 5 OR Col2 < 3 		Filter rows where at least one condition must be true
-- BETWEEN 	    WHERE Col BETWEEN 3 AND 5 		Often easier syntax than using an AND


-- Other Tips

/* Though SQL is not case sensitive (it doesn't care if you write your statements as all uppercase or lowercase), 
we discussed some best practices. The order of the key words does matter! 
Using what you know so far, you will want to write your statements as: */

SELECT col1, col2
FROM table1
WHERE col3  > 5 AND col4 LIKE '%os%'
ORDER BY col5
LIMIT 10;

/* Notice, you can retrieve different columns than those being used in the ORDER BY and WHERE statements. 
Assuming all of these column names existed in this way (col1, col2, col3, col4, col5) within a table called table1, 
this query would run just fine. */

