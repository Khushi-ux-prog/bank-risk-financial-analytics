----------10: VIEWS AND STORED PROCEDURES-----
-----10.1:Views
---10.1.1:customer risk exposure
CREATE VIEW vw_cust_risk_exp AS
SELECT le.CustomerID, le.total_loan_principal, ab.total_balance,
       ROUND(le.total_loan_principal/NULLIF(ab.total_balance,0),2) AS exposure_ratio 
FROM(SELECT a.CustomerID, SUM(l.PrincipalAmount) AS total_loan_principal
     FROM loans l JOIN accounts a ON a.AccountID=l.AccountID
     GROUP BY a.CustomerID) le
JOIN( SELECT CustomerID, SUM(Balance) AS total_balance
      FROM accounts GROUP BY CustomerID) ab ON ab.CustomerID=le.CustomerID;

---10.1.2: view for account directory restricted
CREATE VIEW vw_account_directory_restricted AS 
SELECT a.AccountID, a.CustomerID, at.TypeName AS AccountType,
       ast.TypeName As AccountStatus,a.OpeningDate
FROM accounts a
JOIN account_types at ON at.AccountTypeID=a.AccountTypeID
JOIN account_statuses ast ON ast.AccountStatusID=a.AccountStatusID;

---10.1.3: view for customer directory restricted
CREATE VIEW vw_cust_directory_restricted AS
SELECT c.CustomerID, c.FirstName, c.LastName, ct.TypeName AS CustomerType
FROM customers c
JOIN customer_types ct ON ct.CustomerTypeID = c.CustomerTypeID;

------10.2: Creating Stored Procedures
---10.2.1:: GetCustomerLoanSummary - look up one customer's loan and exposure summary by ID
CREATE PROCEDURE GetCustomerLoanSummary
  @CustomerID VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM customers WHERE CustomerID=@CustomerID)
    BEGIN 
       SELECT CONCAT( 'No customer found with ID', @CustomerID) AS Message;
      END
      ELSE
      BEGIN
      SELECT c.CustomerID, c.FirstName, c.LastName,
              r.total_loan_principal, r.total_balance, r.exposure_ratio
      FROM customers c LEFT JOIN vw_cust_risk_exp r ON r.CustomerID=c.CustomerID
      WHERE c.CustomerID=@CustomerID;
      END
END;
--check:
EXEC GetCustomerLoanSummary @CustomerID ='10289'
---10.2.2:FlagHighRiskCustomers-return every customer whose exposure ratio exceeds a threshold supply
CREATE PROCEDURE Flag_High_Risk_Customers
  @Threshold DECIMAL(10,2)
  AS
  BEGIN
     SELECT r.CustomerID,r.total_loan_principal, r.total_balance, r.exposure_ratio
     FROM vw_cust_risk_exp r
     WHERE r.exposure_ratio > @Threshold
     ORDER BY r.exposure_ratio DESC;
  END;
  ---checking stored procedure
  EXEC Flag_High_Risk_Customers @Threshold = 5;

