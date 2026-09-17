----------8.RELATIONSHIP BASED FINANCIAL ANALYSIS----

----8.1:Customer Account Overview
---Objective: connect customers with their accounts to identify account ownership and current balances
SELECT c.CustomerID,c.FirstName,c.LastName,a.AccountID,a.Balance 
FROM customers AS c
JOIN accounts AS a
ON c.CustomerID=a.CustomerID;

----8.2: Customer Loan Exposure
---Objective: connect customers, accounts and loans to identify how much loan principal
---is associated with each customer
SELECT c.CustomerID, c.FirstName, c.LastName,
ls.StatusName AS LoanStatus,
COUNT(l.LoanID) AS LoanCount,
SUM(l.PrincipalAmount) AS TotalLoanPrincipal
FROM customers AS c
JOIN accounts AS a
  ON c.CustomerID=a.CustomerID
JOIN loans AS l
  ON a.AccountID=l.AccountID
JOIN loan_statuses AS ls
  ON l.LoanStatusID=ls.LoanStatusID
GROUP BY c.CustomerID,c.FirstName,c.LastName,ls.StatusName
ORDER BY TotalLoanPrincipal DESC;

----8.3 — Loan Exposure by Account Status
---Objective: Identify how loan exposure is distributed across different account statuses, helping us assess whether loans are concentrated in active, closed, or other account categories.
SELECT 
  ast.TypeName AS AccountStatus,
  COUNT(l.LoanID) AS LoanCount,
  SUM(l.PrincipalAmount) AS TotalLoanPrincipal
FROM loans AS l
JOIN accounts AS a
   ON l.AccountID=a.AccountID
JOIN account_statuses AS ast
   ON a.AccountStatusID=ast.AccountStatusID
GROUP BY ast.TypeName
ORDER BY TotalLoanPrincipal DESC;

----8.4 — Transaction Type and Account Flow
---Objective: Identify how different transaction types move between accounts by combining transaction type with origin and destination accounts.
SELECT 
  tt.TypeName AS TransactionType,
  t.AccountOriginID,
  t.AccountDestinationID,
  COUNT(*) AS TransactionCount,
  SUM(t.Amount) AS TotalAmount
FROM transactions AS t
JOIN transaction_types AS tt
 ON t.TransactionTypeID=tt.TransactionTypeID
WHERE t.AccountOriginID IS NOT NULL
 AND t.AccountDestinationID IS NOT NULL
GROUP BY tt.TypeName,t.AccountOriginID,t.AccountDestinationID
ORDER BY TotalAmount DESC;
