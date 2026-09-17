# Bank Risk & Financial Analytics Pipeline (SQL)

An end-to-end SQL project analyzing a relational banking dataset — from raw data cleaning through advanced risk analytics, views, and stored procedures — built in Microsoft SQL Server (T-SQL).

## Overview

This project simulates a bank's internal analytics workflow: importing raw customer, account, loan, and transaction data, cleaning and validating it, then progressively building from basic reporting up to advanced SQL techniques (CTEs, subqueries, window functions) to surface customer risk exposure, loan portfolio health, and transaction anomalies.

**Dataset:** ~50,000 transactions, 1,600+ accounts, 330+ loans, 1,100+ customers, across 50 branches (source: Kaggle).

## Tech Stack

- Microsoft SQL Server (T-SQL)
- Raw CSV data, imported via `BULK INSERT`

## Project Structure

The project follows a 12-stage roadmap:

1. Database & Raw Table Setup
2. Import Raw Data
3. Initial Data Understanding / Checks
4. Data Cleaning & Validation
5. Create & Populate Cleaned Tables
6. Basic Financial Analysis
7. Aggregated Financial Analysis
8. Relationship-Based Financial Analysis
9. **Advanced SQL & Risk Analysis** (CTEs, subqueries, window functions)
10. Views & Stored Procedures
11. Final Business/Risk Insights
12. This documentation

## Highlights

**Data Cleaning (Stage 4)**
- Identified and removed duplicate rows (3 in `loans`, 16 in `accounts`)
- Converted blank date strings to proper `NULL` values
- Validated and cast all financial columns to `DECIMAL`/`DATE` types (not left as raw text)

**Advanced SQL (Stage 9)**
- *CTEs:* multi-step customer risk exposure (loan principal vs. account balance), high-activity customer segmentation, branch-level transaction concentration
- *Subqueries:* existence checks (`NOT EXISTS`), correlated subqueries for "most recent transaction," type-relative comparisons
- *Window Functions:* `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, and `AVG() OVER (ROWS BETWEEN...)` for account ranking, loan tiering, and transaction anomaly detection

**Views & Stored Procedures (Stage 10)**
- `vw_customer_risk_exposure` — reusable exposure-ratio calculation
- `vw_account_directory_restricted` — access-control view masking account balances
- `GetCustomerLoanSummary` — parameterized single-customer lookup with input validation
- `FlagHighRiskCustomers` — parameterized risk-threshold query

## Key Insights

1. **Customer Risk Exposure** — customers ranked by loan-to-balance exposure ratio to identify over-leveraged accounts.
2. **Loan Portfolio Health** — 34 loans currently `Overdue`.
3. **Branch Activity Distribution** — transaction volume is evenly spread across branches (~2.0%–2.16% each of 50) — no single-branch concentration risk.
4. **High-Value Account Segmentation** — top 3 highest-balance accounts per account type, for relationship management.
5. **Customer Activity Patterns** — 364 customers show above-average transaction activity, a cross-sell/engagement segment.
6. **Anomaly Monitoring** — transaction-to-transaction balance swing detection, designed for ongoing monitoring.
7. **Data Quality** — duplicate rows removed, blank dates handled, financial columns properly typed.

## Repository Structure

The project is split into per-stage `.sql` files for easier navigation:

```
1-raw tables.sql
2-import data.sql
3&4-datacheck & data cleaning.sql
5-cleaned table.sql
6&7-basic and aggregated analysis.sql
8-relationship based analysis.sql
9-advanced risk analysis.sql
10-views and sp.sql
11-insights.sql
```

## How to Run

1. Update the `BULK INSERT` file paths in `2-import data.sql` to your local CSV directory.
2. Run each file in order (1 through 11) in SQL Server Management Studio (or Azure Data Studio).
3. Views and stored procedures (`10-views and sp.sql`) require `GO` batch separators before each `CREATE VIEW`/`CREATE PROCEDURE` statement if run alongside other queries.

## Author

Gurumayum Khushi Devi
