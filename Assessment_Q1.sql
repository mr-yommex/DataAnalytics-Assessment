WITH savings_counts AS (
    -- I am isolating and counting savings plans per oowner_id
    SELECT owner_id, 
    COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    AND amount > 0
    GROUP BY owner_id
),

investment_counts AS (
    -- I am isolating and counting savings plans per oowner_id
    SELECT owner_id, 
    COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    AND amount > 0
    GROUP BY owner_id
),

deposits AS (
    -- I rounded each values up to 2 decimal places to suit the reqirement and divided by 100 since all amount fields are in kobo as specified
    SELECT owner_id, 
    ROUND(SUM(confirmed_amount) / 100, 2) AS total_deposits
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
)

SELECT
	CU.ID as owner_id,
    -- I concatenated the customer's firstname and second name. This is neccessary for both to be on the same column.
	CONCAT(CU.first_name, ' ', CU.last_name) AS name,
    SC.savings_count AS savings_count,
    IC.investment_count AS investment_count,
    D.total_deposits AS total_deposits
    FROM 
    users_customuser CU,
    savings_counts SC,
    investment_counts IC,
    deposits D
    WHERE 
    CU.id = SC.owner_id
    AND CU.id = IC.owner_id
    AND CU.id = D.owner_id
	AND SC.savings_count > 0 AND IC.investment_count > 0 ORDER BY total_deposits;