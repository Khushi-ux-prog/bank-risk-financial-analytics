CREATE DATABASE FinancialAnalytics;

--------1. Creating raw tables
USE FinancialAnalytics;
GO

CREATE TABLE customer_types_raw (
    CustomerTypeID VARCHAR(50),
    TypeName VARCHAR(50)
);

CREATE TABLE account_types_raw (
    AccountTypeID VARCHAR(50),
    TypeName VARCHAR(50)
);

CREATE TABLE account_statuses_raw (
    AccountStatusID VARCHAR(50),
    StatusName VARCHAR(50)
);

CREATE TABLE loan_statuses_raw (
    LoanStatusID VARCHAR(50),
    StatusName VARCHAR(50)
);

CREATE TABLE transaction_types_raw (
    TransactionTypeID VARCHAR(50),
    TypeName VARCHAR(50)
);

CREATE TABLE addresses_raw (
    AddressID VARCHAR(50),
    Street VARCHAR(200),
    City VARCHAR(100),
    Country VARCHAR(100)
);

CREATE TABLE customers_raw (
    CustomerID VARCHAR(50),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    DateOfBirth VARCHAR(50),
    AddressID VARCHAR(50),
    CustomerTypeID VARCHAR(50)
);

CREATE TABLE branches_raw (
    BranchID VARCHAR(50),
    BranchName VARCHAR(100),
    AddressID VARCHAR(50)
);

CREATE TABLE accounts_raw (
    AccountID VARCHAR(50),
    CustomerID VARCHAR(50),
    AccountTypeID VARCHAR(50),
    AccountStatusID VARCHAR(50),
    Balance VARCHAR(50),
    OpeningDate VARCHAR(50)
);

CREATE TABLE loans_raw (
    LoanID VARCHAR(50),
    AccountID VARCHAR(50),
    LoanStatusID VARCHAR(50),
    PrincipalAmount VARCHAR(50),
    InterestRate VARCHAR(50),
    StartDate VARCHAR(50),
    EstimatedEndDate VARCHAR(50)
);

CREATE TABLE transactions_raw (
    TransactionID VARCHAR(50),
    AccountOriginID VARCHAR(50),
    AccountDestinationID VARCHAR(50),
    TransactionTypeID VARCHAR(50),
    Amount VARCHAR(50),
    TransactionDate VARCHAR(50),
    BranchID VARCHAR(50),
    Description VARCHAR(500)
);