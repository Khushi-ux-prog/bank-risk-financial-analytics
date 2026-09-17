-----------11. FINAL BUSINESS/ RISK INSIGHTS----

----1: Loan Portfolio Health
SELECT COUNT(*) AS OverdueLoanCount
FROM loans WHERE LoanStatusID = (SELECT LoanStatusID FROM loan_statuses WHERE StatusName='Overdue');
--Result: 34 loans are currently overdue. Identifying each customer's single largest loan helps priortize which specific loan matters
--when reviewing a customer's file.

----2: Customer Risk Exposure
SELECT COUNT(*) AS CustomersWithExposure FROM vw_cust_risk_exp;
--Result:262 customers carry both loan principal and account balance, with
--exposure ratios used to identify over-leveraged customers.The highest 
--exposed customers owes several times more than they currently hold in accounts.

----3. Branch activity distribution
--Transaction volume is fairly evenly spread across branches(~2.0%- 2.16% each
--out of 50) - no single branch represents a meaningful concentration risk

----4. High-Value Account Segmentation
--For each account type, the 3 accounts with the highest balances are pulled
--out a short, ready-made list of the accounts worth the most attention.
----5. Customer Activity Patterns
--364 customers show above-average total transaction activity (9.1.2) —
--a broad engagement segment, useful for cross-sell targeting.

----6. Anomaly Monitoring
--Balance swing detection (9.3.3) — comparing each transaction to both
--the prior transaction and a short rolling average — is designed as an
--ongoing monitoring signal rather than a one-time finding.

----7. Data Quality Notes
--Duplicate rows were identified and removed from loans (3 rows) and
--accounts (16 rows) during cleaning (stage 4.2); blank TransactionDate
--values were converted to NULL rather than left as empty strings; all
--financial columns were explicitly typed as DECIMAL/DATE rather than
--raw text — ensuring every downstream calculation in stages 6-10 was
--built on reliable data.

