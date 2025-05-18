WITH transaction_count AS (
-- Here I calculated total transactions and profits for each customer
    SELECT
        owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_value,
        -- Converted kobo to naira and calculated 0.1% of total value as profit 
        ((SUM(amount)/100) * (0.1/100)) as profit
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
-- This is to calculate account tenure in months per customer
tenure AS (
    SELECT
        id AS customer_id,
        TIMESTAMPDIFF(MONTH, MIN(date_joined), CURDATE()) AS tenure_months
    FROM users_customuser
    GROUP BY id
)
--  I joined the all the common table expressions with calculated for CLV
    SELECT
        CU.id AS customer_id,
        CONCAT(CU.first_name, ' ', CU.last_name) AS name,
        T.tenure_months,
        TC.total_transactions,
        -- Estimated CLV formula: (total_transactions / tenure) * 12 * avg profit rounded up to 2
        ROUND((TC.total_transactions /T.tenure_months) * 12 * (TC.profit / TC.total_transactions), 2) AS estimated_clv
    FROM users_customuser CU,
	transaction_count TC,
    tenure T
    where CU.id = TC.customer_id
    AND CU.id = T.customer_id ORDER BY estimated_clv DESC
