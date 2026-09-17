---------3.INITIAL DATA UNDERSTANDING/CHECKS----
USE FinancialAnalytics;
GO

SELECT 'customer_types_raw' AS TableName, COUNT(*) AS TotalRows FROM customer_types_raw
UNION ALL
SELECT 'account_types_raw', COUNT(*) FROM account_types_raw
UNION ALL
SELECT 'account_statuses_raw', COUNT(*) FROM account_statuses_raw
UNION ALL
SELECT 'loan_statuses_raw', COUNT(*) FROM loan_statuses_raw
UNION ALL
SELECT 'transaction_types_raw', COUNT(*) FROM transaction_types_raw
UNION ALL
SELECT 'addresses_raw', COUNT(*) FROM addresses_raw
UNION ALL
SELECT 'customers_raw', COUNT(*) FROM customers_raw
UNION ALL
SELECT 'branches_raw', COUNT(*) FROM branches_raw
UNION ALL
SELECT 'accounts_raw', COUNT(*) FROM accounts_raw
UNION ALL
SELECT 'loans_raw', COUNT(*) FROM loans_raw
UNION ALL
SELECT 'transactions_raw', COUNT(*) FROM transactions_raw;


----------4.DATA CLEANING AND VALIDATION----
------4.1: check for duplicate records and duplicate IDs

--customer_types
SELECT CustomerTypeID, COUNT(*) AS DuplicateCount
FROM customer_types_raw
GROUP BY CustomerTypeID
HAVING COUNT(*) >1;
--account types
SELECT AccountTypeID, COUNT(*) AS DuplicateCount
FROM account_types_raw
GROUP BY AccountTypeID
HAVING COUNT(*) > 1;
-- 3. Account Statuses
SELECT AccountStatusID, COUNT(*) AS DuplicateCount
FROM account_statuses_raw
GROUP BY AccountStatusID
HAVING COUNT(*) > 1;
-- 4. Loan Statuses
SELECT LoanStatusID, COUNT(*) AS DuplicateCount
FROM loan_statuses_raw
GROUP BY LoanStatusID
HAVING COUNT(*) > 1;
-- 5. Transaction Types
SELECT TransactionTypeID, COUNT(*) AS DuplicateCount
FROM transaction_types_raw
GROUP BY TransactionTypeID
HAVING COUNT(*) > 1;
-- 6. Addresses
SELECT AddressID, COUNT(*) AS DuplicateCount
FROM addresses_raw
GROUP BY AddressID
HAVING COUNT(*) > 1;
-- 7. Customers
SELECT CustomerID, COUNT(*) AS DuplicateCount
FROM customers_raw
GROUP BY CustomerID
HAVING COUNT(*) > 1;
-- 8. Branches
SELECT BranchID, COUNT(*) AS DuplicateCount
FROM branches_raw
GROUP BY BranchID
HAVING COUNT(*) > 1;
-- 9. Accounts
SELECT AccountID, COUNT(*) AS DuplicateCount
FROM accounts_raw
GROUP BY AccountID
HAVING COUNT(*) > 1;
-- 10. Loans
SELECT LoanID, COUNT(*) AS DuplicateCount
FROM loans_raw
GROUP BY LoanID
HAVING COUNT(*) > 1;
-- 11. Transactions
SELECT TransactionID, COUNT(*) AS DuplicateCount
FROM transactions_raw
GROUP BY TransactionID
HAVING COUNT(*) > 1;

----4.2 removing duplicate rows
--1. addresses
WITH duplicates AS(
  SELECT *, ROW_NUMBER() OVER(
    PARTITION BY AddressID, Street, City, Country
    ORDER BY AddressID)AS RowNum
  FROM addresses_raw)
DELETE FROM duplicates WHERE RowNum>1;
--2. customers
WITH duplicates AS(
  SELECT *, ROW_NUMBER() OVER(
    PARTITION BY CustomerID, FirstName, LastName, DateOfBirth, AddressID, CustomerTypeID
    ORDER BY CustomerID)AS RowNum
  FROM customers_raw)
DELETE FROM duplicates WHERE RowNum>1;
--3.accounts
WITH duplicates AS (
  SELECT *,ROW_NUMBER() OVER (
     PARTITION BY AccountID, CustomerID, AccountTypeID,AccountStatusID, Balance, OpeningDate
     ORDER BY AccountID) AS RowNum
    FROM accounts_raw)
DELETE FROM duplicates
WHERE RowNum > 1;
--4.Loans
WITH duplicates AS (
  SELECT *,ROW_NUMBER() OVER (
    PARTITION BY LoanID, AccountID, LoanStatusID, PrincipalAmount,
    InterestRate,StartDate, EstimatedEndDate
    ORDER BY LoanID) AS RowNum
    FROM loans_raw)
DELETE FROM duplicates
WHERE RowNum > 1;
--5.transactions
WITH duplicates AS (
  SELECT *,ROW_NUMBER() OVER (
    PARTITION BY TransactionID, AccountOriginID,AccountDestinationID, 
    TransactionTypeID,Amount, TransactionDate, BranchID, Description
    ORDER BY TransactionID) AS RowNum
    FROM transactions_raw)
DELETE FROM duplicates
WHERE RowNum > 1;

----check missing values
-- STEP 4.3: CHECK MISSING VALUES

SELECT
    'customers',
    COUNT(*) AS MissingRows
FROM customers_raw
WHERE CustomerID = ''
   OR FirstName = ''
   OR LastName = ''
   OR DateOfBirth = ''
   OR AddressID = ''
   OR CustomerTypeID = ''

UNION ALL

SELECT
    'accounts',
    COUNT(*)
FROM accounts_raw
WHERE AccountID = ''
   OR CustomerID = ''
   OR AccountTypeID = ''
   OR AccountStatusID = ''
   OR Balance = ''
   OR OpeningDate = ''

UNION ALL

SELECT
    'loans',
    COUNT(*)
FROM loans_raw
WHERE LoanID = ''
   OR AccountID = ''
   OR LoanStatusID = ''
   OR PrincipalAmount = ''
   OR InterestRate = ''
   OR StartDate = ''

UNION ALL

SELECT
    'transactions',
    COUNT(*)
FROM transactions_raw
WHERE TransactionID = ''
   OR AccountOriginID = ''
   OR AccountDestinationID = ''
   OR TransactionTypeID = ''
   OR Amount = ''
   OR TransactionDate = ''
   OR BranchID = '';

----4.4: data type validation
-- Customers
SELECT * FROM customers_raw
WHERE TRY_CONVERT(INT, CustomerID) IS NULL
   OR TRY_CONVERT(INT, AddressID) IS NULL
   OR TRY_CONVERT(INT, CustomerTypeID) IS NULL
   OR TRY_CONVERT(DATE, DateOfBirth) IS NULL;

-- Branches
SELECT * FROM branches_raw
WHERE TRY_CONVERT(INT, BranchID) IS NULL
   OR TRY_CONVERT(INT, AddressID) IS NULL;

-- Accounts
SELECT * FROM accounts_raw
WHERE TRY_CONVERT(INT, AccountID) IS NULL
   OR TRY_CONVERT(INT, CustomerID) IS NULL
   OR TRY_CONVERT(INT, AccountTypeID) IS NULL
   OR TRY_CONVERT(INT, AccountStatusID) IS NULL
   OR TRY_CONVERT(DECIMAL(18,2), Balance) IS NULL
   OR TRY_CONVERT(DATE, OpeningDate) IS NULL;

-- Loans
SELECT * FROM loans_raw
WHERE TRY_CONVERT(INT, LoanID) IS NULL
   OR TRY_CONVERT(INT, AccountID) IS NULL
   OR TRY_CONVERT(INT, LoanStatusID) IS NULL
   OR TRY_CONVERT(DECIMAL(18,2), PrincipalAmount) IS NULL
   OR TRY_CONVERT(DECIMAL(6,4), InterestRate) IS NULL
   OR TRY_CONVERT(DATE, StartDate) IS NULL
   OR TRY_CONVERT(DATE, EstimatedEndDate) IS NULL;

-- Transactions
SELECT * FROM transactions_raw
WHERE TRY_CONVERT(INT, TransactionID) IS NULL
   OR TRY_CONVERT(INT, AccountOriginID) IS NULL
   OR TRY_CONVERT(INT, AccountDestinationID) IS NULL
   OR TRY_CONVERT(INT, TransactionTypeID) IS NULL
   OR TRY_CONVERT(DECIMAL(18,2), Amount) IS NULL
   OR TRY_CONVERT(DATETIME, TransactionDate) IS NULL
   OR TRY_CONVERT(INT, BranchID) IS NULL;

---cleaning identified date issues
UPDATE customers_raw
SET DateOfBirth = NULL
WHERE DateOfBirth = 'NaT';

ALTER TABLE transactions
ALTER COLUMN TransactionDate DATETIME2;

UPDATE t
SET t.TransactionDate = TRY_CONVERT(DATETIME2, r.TransactionDate)
FROM transactions t
JOIN transactions_raw r
    ON t.TransactionID = TRY_CONVERT(INT, r.TransactionID);

