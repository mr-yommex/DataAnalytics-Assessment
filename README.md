DATA ANALYST ASSESSMENT
===================================================================
- Assessment_Q1.sql - High-Value Customers with Multiple Products


APPROACH:

1. I selected the required columns and joined the 3 (users_customuser, savings_savingsaccount, and plans_plan) tables using the owner_id.

2. I used conditions amount and confirmed amount greater than zero to select customers with at least one funded savings account and one investment plan .

3. I used CTE to make the script readable and ordered by total deposits.

CHALLENGES:

1. I was getting the error ‘Error Code: 2013. Lost connection to MySQL server during query’, which I suspected was due to the query taking too long to drop, and I was able to resolve it by rewriting the script and breaking it down into bits. The initial way would be more suitable for oracle SQL developer.

=========================================================================
- Assessment_Q2.sql - Transaction Frequency Analysis


APPROACH:

1. I created a common table expression that holds owner_id, month and transaction count for each month.

2. I used CASE statements for segmentation and calculated average monthly transactions per customer using the table expression.

3. I confirmed accuracy using SELECT count(id) FROM users_customuser where id in (
select distinct owner_id from savings_savingsaccount);

CHALLENGES:

1. Determining accurate monthly transaction counts from transaction dates.

2. I was unable to group by frequency_category until I separated the script using another CTE for average per month

=================================================================
- Assessment_Q3.sql - Account Inactivity Alert


APPROACH:

1. I combined transactions from both investments and savings accounts into one dataset

2. I considered only active investment plans and excluded failed transactions using confirmed_amount <> 0.

3. I calculated how many days have passed since the last transaction using ‘DATEDIFF()’ to calculate inactivity in days.

CHALLENGES:

1. Integrating both savings and investment data sources into a single table was a bit tricky before I figured that I could use union to achieve this.

2. The process of ensuring the accurate selection of the most recent transaction date per owner_id was also a bit challenging. However, I was able to achieve this using common table expressions for this one as well.  

========================================================================
## Assessment_Q4.sql - Customer Lifetime Value (CLV) Estimation


APPROACH:

1. I calculated the total number of transactions and the total transaction value in kobo for each customer from the savings_savingsaccount table. Since the profit is based on 0.1% of the transaction value and the amounts are in kobo, I converted them to Naira using the 0.1% profit formula.

2. I then calculated how long each customer has had their account using the users_customuser table. I used TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) to get the tenure in months.

3. Finally, I joined all the data back with the customer names for clarity and sorted by CLV to see the top customers.

CHALLENGES:

1. I encountered an SQL error saying:
“In aggregated query without GROUP BY, expression X is incompatible with sql_mode=only_full_group_by”. To fix this, I changed the logic to manually calculate average profit as (total_profit / total_transactions) and removed the aggregation.
2. Initially, I tried doing everything in one query, but it became hard to debug and slow to run.
3. The transaction values were in kobo, but I initially treated them as Naira, which threw off my CLV calculations so I added a step to divide the values by 100 to convert to Naira, before applying the 0.1% profit calculation.


===============================================================================

I used MySQL server and workbench for this assessments and also used the beautify option on workbench to keep the script optimized for readability.
