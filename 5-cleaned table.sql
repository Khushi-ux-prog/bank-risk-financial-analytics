----------5. CREATE THE CLEANED TABLES----
-- STEP 5.1: CREATE CLEANED TABLES

CREATE TABLE customer_types (
    CustomerTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50));

CREATE TABLE account_types (
    AccountTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50));

CREATE TABLE account_statuses (
    AccountStatusID INT PRIMARY KEY,
    TypeName VARCHAR(50));

CREATE TABLE loan_statuses (
    LoanStatusID INT PRIMARY KEY,
    StatusName VARCHAR(50));

CREATE TABLE transaction_types (
    TransactionTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50));

CREATE TABLE addresses (
    AddressID INT PRIMARY KEY,
    Street VARCHAR(200),
    City VARCHAR(100),
    Country VARCHAR(50));

CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    CustomerTypeID INT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    AddressID INT,
    DateOfBirth DATE);

CREATE TABLE branches (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    AddressID INT);

CREATE TABLE accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountTypeID INT,
    AccountStatusID INT,
    Balance DECIMAL(18,2),
    OpeningDate DATE);

CREATE TABLE loans (
    LoanID INT PRIMARY KEY,
    AccountID INT,
    LoanStatusID INT,
    PrincipalAmount DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    EstimatedEndDate DATE);

CREATE TABLE transactions (
    TransactionID INT PRIMARY KEY,
    AccountOriginID INT,
    AccountDestinationID INT,
    TransactionTypeID INT,
    Amount DECIMAL(18,2),
    TransactionDate DATETIME,
    BranchID INT,
    Description VARCHAR(500));

-----5.2: insert cleaned data
ALTER TABLE loans
ALTER COLUMN InterestRate DECIMAL(6,4);

-- Customers
INSERT INTO customers
(
    CustomerID,
    CustomerTypeID,
    FirstName,
    LastName,
    AddressID,
    DateOfBirth
)
SELECT
    TRY_CONVERT(INT, CustomerID),
    TRY_CONVERT(INT, CustomerTypeID),
    FirstName,
    LastName,
    TRY_CONVERT(INT, AddressID),
    TRY_CONVERT(DATE, NULLIF(DateOfBirth, ''))
FROM customers_raw;


-- Branches
INSERT INTO branches
(
    BranchID,
    BranchName,
    AddressID
)
SELECT
    TRY_CONVERT(INT, BranchID),
    BranchName,
    TRY_CONVERT(INT, AddressID)
FROM branches_raw;


-- Accounts
INSERT INTO accounts
(
    AccountID,
    CustomerID,
    AccountTypeID,
    AccountStatusID,
    Balance,
    OpeningDate
)
SELECT
    TRY_CONVERT(INT, AccountID),
    TRY_CONVERT(INT, CustomerID),
    TRY_CONVERT(INT, AccountTypeID),
    TRY_CONVERT(INT, AccountStatusID),
    TRY_CONVERT(DECIMAL(18,2), Balance),
    TRY_CONVERT(DATE, NULLIF(OpeningDate, ''))
FROM accounts_raw;


-- Loans
INSERT INTO loans
(
    LoanID,
    AccountID,
    LoanStatusID,
    PrincipalAmount,
    InterestRate,
    StartDate,
    EstimatedEndDate
)
SELECT
    TRY_CONVERT(INT, LoanID),
    TRY_CONVERT(INT, AccountID),
    TRY_CONVERT(INT, LoanStatusID),
    TRY_CONVERT(DECIMAL(18,2), PrincipalAmount),
    TRY_CONVERT(DECIMAL(6,4), InterestRate),
    TRY_CONVERT(DATE, NULLIF(StartDate, '')),
    TRY_CONVERT(DATE, NULLIF(EstimatedEndDate, ''))
FROM loans_raw;


-- Transactions
INSERT INTO transactions
(
    TransactionID,
    AccountOriginID,
    AccountDestinationID,
    TransactionTypeID,
    Amount,
    TransactionDate,
    BranchID,
    Description
)
SELECT
    TRY_CONVERT(INT, TransactionID),
    TRY_CONVERT(INT, AccountOriginID),
    TRY_CONVERT(INT, AccountDestinationID),
    TRY_CONVERT(INT, TransactionTypeID),
    TRY_CONVERT(DECIMAL(18,2), Amount),
    TRY_CONVERT(DATETIME, NULLIF(TransactionDate, '')),
    TRY_CONVERT(INT, BranchID),
    Description
FROM transactions_raw;

