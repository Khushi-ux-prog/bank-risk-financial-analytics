----------6. BASIC FINANCIAL ANALYSIS-----
----6.1: Account Balance Analysis
SELECT AccountID, CustomerID, Balance, OpeningDate
FROM accounts WHERE Balance<0;
----6.2: Account Balance Ranking
SELECT TOP 10 * FROM accounts 
ORDER BY Balance DESC;
SELECT COUNT(*) AS TotalAccounts
FROM accounts;
----6.3:Recently opened accounts
SELECT TOP 10 *
FROM accounts
ORDER BY OpeningDate DESC;
----6.4:Account status analysis
SELECT
    AccountStatusID,
    COUNT(*) AS AccountCount
FROM accounts
GROUP BY AccountStatusID
ORDER BY AccountCount DESC;


-----------7.AGGREGATED FINANCIAL ANALYSIS
----7.1 — Account Distribution by Account Type
SELECT at.TypeName, 
COUNT(*) AS AccountCount
FROM accounts AS a
JOIN account_types AS at
ON a.AccountTypeID=at.AccountTypeID
GROUP BY at.TypeName;

----7.2 — Transaction Flow Analysis
---Objective: Identify the most active account-to-account money flows by measuring how many 
---transactions occur between each origin and destination account and the total amount transferred.
SELECT AccountOriginID,AccountDestinationID,
COUNT(*) AS no_of_transactions,
SUM(Amount) AS TotalAmount
FROM Transactions 
WHERE AccountDestinationID IS NOT NULL
 AND AccountOriginID IS NOT NULL
GROUP BY AccountOriginID, AccountDestinationID
ORDER BY TotalAmount DESC;

----7.3: Loan status analysis
---Objective: Measure the distribution of loans across their current statuses, giving us a basic view
---of the loan portfolio and a foundation for later risk analysis
SELECT LoanStatusID, COUNT(*) AS LoanCount,
SUM(PrincipalAmount) AS TotalPrincipal
FROM loans
GROUP BY LoanStatusID
ORDER BY LoanCount DESC;

----7.4 — Transaction Activity by Month
---Objective: Identify how transaction activity and transaction value
---change over time. This gives us a baseline for spotting unusual
---periods later during the fraud/risk analysis.
SELECT YEAR(TransactionDate) AS TransactionYear,
       Month(TransactionDate) AS TransactionMonth,
       COUNT(*) AS TransactionCount,
       SUM(Amount) AS TotalAmount
FROM Transactions
GROUP BY YEAR(TransactionDate),Month(TransactionDate)
ORDER BY TransactionYear,TransactionMonth;
