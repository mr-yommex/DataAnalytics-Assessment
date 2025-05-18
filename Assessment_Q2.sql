WITH monthly_transaction AS (
-- I calculated the number of transactions per customer per month
    SELECT
        SA.owner_id AS owner_id,
        DATE_FORMAT(SA.transaction_date, '%Y-%m') AS month, -- I formatted the date to achieve the months
        COUNT(*) AS transaction_count
    FROM savings_savingsaccount SA, users_customuser CU
    where SA.owner_id = CU.id
    GROUP BY SA.owner_id, month
    
),
customer_monthly_avg AS (
-- this is for each owner_id based on their average monthly transaction count
 SELECT
        owner_id,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM monthly_transaction
    GROUP BY owner_id
)
SELECT
    CASE
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(owner_id) AS customer_count,
    -- I rounded the of the average transactions for each category to suit requirement
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM customer_monthly_avg
GROUP BY frequency_category;