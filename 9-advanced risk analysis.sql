----------9.ADVANCED SQL RISK ANALYSIS---
-----9.1: CTEs

---9.1.1: Multi step Customer Risk Exposure
WITH loan_exposure AS (
  SELECT a.CustomerID,
       SUM(l.PrincipalAmount) AS total_loan_principal
  FROM loans l
  JOIN accounts a ON a.AccountID=l.AccountID
  GROUP BY a.CustomerID),
account_balance AS (
  SELECT CustomerID,
       SUM(balance) AS total_balance
  FROM accounts
  GROUP BY CustomerID)
SELECT le.CustomerID,le.total_loan_principal,ab.total_balance,
   ROUND(le.total_loan_principal/NULLIF(ab.total_balance,0),2) AS exposure_ratio
FROM loan_exposure le
JOIN account_balance ab ON ab.CustomerID=le.CustomerID
ORDER BY exposure_ratio DESC;

---9.1.2: Customers with high transaction activity
WITH customer_activity AS(
  SELECT a.CustomerID,
     SUM(t.Amount) AS total_transaction_amount
  FROM transactions t
  JOIN accounts a ON a.AccountID=t.AccountOriginID
  GROUP BY a.CustomerID)
 
SELECT CustomerID, total_transaction_amount
FROM customer_activity
WHERE total_transaction_amount > (SELECT AVG(total_transaction_amount) FROM customer_activity)
ORDER BY total_transaction_amount DESC;

---9.1.3:Branch-Level Transaction Volume Concentration
WITH branch_volume AS(
   SELECT BranchID,SUM(Amount) AS total_volume
   FROM transactions
   GROUP BY BranchID)
SELECT BranchID,total_volume,ROUND(100.0*total_volume/
   (SELECT SUM(total_volume) FROM branch_volume),2) AS network_share_pct
FROM branch_volume
WHERE total_volume > (SELECT AVG(total_volume) FROM branch_volume)
ORDER BY total_volume DESC;

-----9.2: Using subqueries
---9.2.1: Accounts with no associated loans
SELECT a.AccountID,a.CustomerID,a.Balance
FROM accounts a
WHERE NOT EXISTS(
  SELECT 1 FROM loans l WHERE l.AccountID=a.AccountID);

---9.2.2: Customers whose most recent transaction was a withdrawal
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName
FROM customers c
JOIN accounts a ON a.CustomerID=c.CustomerID
JOIN transactions t ON t.AccountOriginID=a.AccountID
WHERE t.TransactionDate=(
   SELECT MAX(t2.TransactionDate)
   FROM transactions t2
   JOIN accounts a2 ON a2.AccountID=t2.AccountOriginID
   WHERE a2.CustomerID=c.CustomerID)
 AND t.TransactionTypeID=(SELECT TransactionTypeID FROM transaction_types WHERE TypeName='Withdrawal');

---9.2.3: Transactions above their transaction type average
SELECT t.TransactionID,tt.TypeName,t.Amount
FROM transactions t 
JOIN transaction_types tt ON tt.TransactionTypeID=t.TransactionTypeID
WHERE t.Amount > (
  SELECT AVG(t2.Amount) FROM transactions t2 WHERE t2.TransactionTypeID = t.TransactionTypeID)
  ORDER BY t.Amount DESC;

-----9.3: Window Functions
---9.3.1:Top 3 Highest-Balance Accounts by Account Type
SELECT AccountID, AccountTypeID, Balance, row_num
FROM(
     SELECT AccountID, AccountTypeID, Balance, 
        ROW_NUMBER() OVER(PARTITION BY AccountTypeID ORDER BY Balance DESC) AS row_num
     FROM accounts) ranked
WHERE row_num <= 3
ORDER BY AccountTypeID, row_num;

---9.3.2: Each Customer's Largest Loan, With Tie-Safe Tiering
SELECT a.CustomerID, l.LoanID, l.PrincipalAmount,
   RANK() OVER(PARTITION BY a.CustomerID ORDER BY l.PrincipalAmount DESC) AS loan_rank,
   DENSE_RANK() OVER(PARTITION BY a.CustomerID ORDER BY l.PrincipalAmount DESC) AS loan_tier
FROM loans l
JOIN accounts a ON a.AccountID=l.AccountID;

---9.3.3: Balance Swing Detection with Recent-Trend Context
SELECT AccountOriginID, TransactionDate, Amount,
  LAG(Amount) OVER(PARTITION BY AccountOriginID ORDER BY TransactionDate) AS prev_amount,
  AVG(Amount) OVER(PARTITION BY AccountOriginID ORDER BY TransactionDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS recent_avg
FROM transactions
WHERE TransactionDate IS NOT NULL AND TransactionDate <> '';


