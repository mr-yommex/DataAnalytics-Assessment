WITH Investment_plan AS (
    SELECT id AS plan_id, owner_id AS owner_id, 'Investment' AS type
    -- this is to consider active investment plans
    FROM plans_plan where is_deleted = 0 and is_a_fund = 1
),

Savings_plan AS (
SELECT id AS plan_id, owner_id AS owner_id, 'Savings' AS type
	-- this is to consider active investment plans
    FROM plans_plan where is_deleted = 0 and is_regular_savings = 1

),
-- I used union to achieve having both savings and investment type on the same table
Combined_Script AS (
Select * from Investment_plan 
Union ALL
Select * from Savings_plan
),

all_transactions AS (
	Select CS.*, SA.transaction_date from combined_script CS, savings_savingsaccount SA where
    CS.owner_id = SA.owner_id
    AND CS.plan_id = SA.plan_id 
    AND SA.confirmed_amount <> 0
),
-- I ranked the transactions so we can isolate the latest one per owner_id and type
ranked_transactions AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY owner_id, type ORDER BY transaction_date DESC) AS rn
    FROM all_transactions
),
-- This is to pick only the most recent transaction per owner and account type
latest_transactions AS (
    SELECT
        plan_id,
        owner_id,
        type,
        transaction_date,
        DATEDIFF(CURDATE(), transaction_date) AS inactivity_days -- this is to calculate how many days have passed since the last transaction
    FROM ranked_transactions
    WHERE rn = 1
)
-- This is to return only accounts that have been inactive for a year or more
SELECT *
FROM latest_transactions
WHERE inactivity_days >= 365;
