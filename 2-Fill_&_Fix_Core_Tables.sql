-- First I fix possible errors in dates:

CREATE TEMP FUNCTION parse_date_any(s STRING) AS (
COALESCE(
SAFE.PARSE_DATE('%Y-%m-%d', s),
SAFE.PARSE_DATE('%Y/%m/%d', s),
SAFE.PARSE_DATE('%d/%m/%Y', s),
SAFE.PARSE_DATE('%m/%d/%Y', s),
SAFE.PARSE_DATE('%Y-%m-%d', SUBSTR(s, 1, 10))
)
);

CREATE TEMP FUNCTION parse_ts_any(s STRING) AS (
COALESCE(
SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%E*S', s),
SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', s),
SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%E*S', s),
SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', s)
)
);

-------------------------------------------------------------------------------------------
-- I know this is just a small project but I prefer tu use the truncate command to avoid duplicates. 

TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_transactions`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_loans`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_accounts`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_customers`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_branches`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_addresses`;

TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_transaction_types`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_loan_statuses`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_account_statuses`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_account_types`;
TRUNCATE TABLE `project-sql-cv.BankCVdataset.core_customer_types`;

-- Once the base are done I can start with the proper tables. I think it's always better to start from: 
-- 1) Reference tables (small ones).
-- 2) Dimensional tables (medium size).
-- 3) Fact tables (big ones).

------------------------------------------------------------------------------------------
-- REFERENCE TABLES --

INSERT INTO `project-sql-cv.BankCVdataset.core_customer_types` (customer_type_id, type_name)
SELECT
customer_type_id,
type_name
FROM (
SELECT
SAFE_CAST(CustomerTypeID AS INT64) AS customer_type_id,
CAST(TypeName AS STRING) AS type_name,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(CustomerTypeID AS INT64)
ORDER BY CAST(TypeName AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_customer_types`
WHERE CustomerTypeID IS NOT NULL
AND TypeName IS NOT NULL
)
WHERE rn = 1
AND customer_type_id IS NOT NULL
AND type_name IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_account_types` (account_type_id, type_name)
SELECT
account_type_id,
type_name
FROM (
SELECT
SAFE_CAST(AccountTypeID AS INT64) AS account_type_id,
CAST(TypeName AS STRING) AS type_name,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(AccountTypeID AS INT64)
ORDER BY CAST(TypeName AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_account_types`
WHERE AccountTypeID IS NOT NULL
AND TypeName IS NOT NULL
)
WHERE rn = 1
AND account_type_id IS NOT NULL
AND type_name IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_account_statuses` (account_status_id, status_name)
SELECT
account_status_id,
status_name
FROM (
SELECT
SAFE_CAST(AccountStatusID AS INT64) AS account_status_id,
CAST(StatusName AS STRING) AS status_name,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(AccountStatusID AS INT64)
 ORDER BY CAST(StatusName AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_account_statuses`
WHERE AccountStatusID IS NOT NULL
AND StatusName IS NOT NULL
)
WHERE rn = 1
AND account_status_id IS NOT NULL
AND status_name IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_loan_statuses` (loan_status_id, status_name)
SELECT
loan_status_id,
status_name
FROM (
SELECT
SAFE_CAST(LoanStatusID AS INT64) AS loan_status_id,
CAST(StatusName AS STRING) AS status_name,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(LoanStatusID AS INT64)
ORDER BY CAST(StatusName AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_loan_statuses`
WHERE LoanStatusID IS NOT NULL
AND StatusName IS NOT NULL
)
WHERE rn = 1
AND loan_status_id IS NOT NULL
AND status_name IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_transaction_types` (transaction_type_id, type_name)
SELECT
transaction_type_id,
type_name
FROM (
SELECT
SAFE_CAST(TransactionTypeID AS INT64) AS transaction_type_id,
CAST(TypeName AS STRING) AS type_name,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(TransactionTypeID AS INT64)
ORDER BY CAST(TypeName AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_transaction_types`
WHERE TransactionTypeID IS NOT NULL
AND TypeName IS NOT NULL
)
WHERE rn = 1
AND transaction_type_id IS NOT NULL
AND type_name IS NOT NULL;

-- ----------------------------------------------------------------------------------------
-- DIMENSIONAL --

INSERT INTO `project-sql-cv.BankCVdataset.core_addresses` (address_id, street, city, country)
SELECT
address_id,
street,
city,
country
FROM (
SELECT
SAFE_CAST(AddressID AS INT64) AS address_id,
CAST(Street AS STRING) AS street,
CAST(City AS STRING) AS city,
CAST(Country AS STRING) AS country,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(AddressID AS INT64)
ORDER BY CAST(Street AS STRING), CAST(City AS STRING), CAST(Country AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_addresses`
WHERE AddressID IS NOT NULL
)
WHERE rn = 1
AND address_id IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_branches` (branch_id, branch_name, address_id)
SELECT
branch_id,
branch_name,
address_id
FROM (
SELECT
SAFE_CAST(BranchID AS INT64) AS branch_id,
CAST(BranchName AS STRING) AS branch_name,
SAFE_CAST(AddressID AS INT64) AS address_id,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(BranchID AS INT64)
 ORDER BY CAST(BranchName AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_branches`
WHERE BranchID IS NOT NULL
)
WHERE rn = 1
AND branch_id IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_customers`
(customer_id, first_name, last_name, date_of_birth, address_id, customer_type_id)
SELECT
customer_id,
first_name,
last_name,
date_of_birth,
address_id,
customer_type_id
FROM (
SELECT
SAFE_CAST(CustomerID AS INT64) AS customer_id,
CAST(FirstName AS STRING) AS first_name,
CAST(LastName AS STRING) AS last_name,
parse_date_any(CAST(DateOfBirth AS STRING)) AS date_of_birth,
SAFE_CAST(AddressID AS INT64) AS address_id,
SAFE_CAST(CustomerTypeID AS INT64) AS customer_type_id,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(CustomerID AS INT64)
ORDER BY CAST(LastName AS STRING), CAST(FirstName AS STRING)
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_customers`
WHERE CustomerID IS NOT NULL
)
WHERE rn = 1
AND customer_id IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_accounts`
(account_id, customer_id, account_type_id, account_status_id, balance, opening_date)
SELECT
account_id,
customer_id,
account_type_id,
account_status_id,
balance,
opening_date
FROM (
SELECT
SAFE_CAST(AccountID AS INT64) AS account_id,
SAFE_CAST(CustomerID AS INT64) AS customer_id,
SAFE_CAST(AccountTypeID AS INT64) AS account_type_id,
SAFE_CAST(AccountStatusID AS INT64) AS account_status_id,
SAFE_CAST(Balance AS NUMERIC) AS balance,
parse_date_any(CAST(OpeningDate AS STRING)) AS opening_date,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(AccountID AS INT64)
ORDER BY SAFE_CAST(Balance AS NUMERIC) DESC
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_accounts`
WHERE AccountID IS NOT NULL
)
WHERE rn = 1
AND account_id IS NOT NULL;

-----------------------------------------------------------------------------------------------------------
-- FACTS --


INSERT INTO `project-sql-cv.BankCVdataset.core_loans`
(loan_id, account_id, loan_status_id, principal_amount, interest_rate, start_date, estimated_end_date)
SELECT
loan_id,
account_id,
loan_status_id,
principal_amount,
interest_rate,
start_date,
estimated_end_date
FROM (
SELECT
SAFE_CAST(LoanID AS INT64) AS loan_id,
SAFE_CAST(AccountID AS INT64) AS account_id,
SAFE_CAST(LoanStatusID AS INT64) AS loan_status_id,
SAFE_CAST(PrincipalAmount AS NUMERIC) AS principal_amount,
SAFE_CAST(InterestRate AS NUMERIC) AS interest_rate,
parse_date_any(CAST(StartDate AS STRING)) AS start_date,
parse_date_any(CAST(EstimatedEndDate AS STRING)) AS estimated_end_date,
ROW_NUMBER() OVER (
PARTITION BY SAFE_CAST(LoanID AS INT64)
ORDER BY parse_date_any(CAST(StartDate AS STRING)) DESC
) AS rn
FROM `project-sql-cv.BankCVdataset.stage_loans`
WHERE LoanID IS NOT NULL
)
WHERE rn = 1
AND loan_id IS NOT NULL;

INSERT INTO `project-sql-cv.BankCVdataset.core_transactions`
(transaction_id, account_origin_id, account_destination_id, transaction_type_id, amount, transaction_ts, branch_id, description)
SELECT
SAFE_CAST(TransactionID AS INT64),
SAFE_CAST(AccountOriginID AS INT64),
SAFE_CAST(AccountDestinationID AS INT64),
SAFE_CAST(TransactionTypeID AS INT64),
SAFE_CAST(Amount AS NUMERIC),
TransactionDate,
SAFE_CAST(BranchID AS INT64),
CAST(Description AS STRING)
FROM `project-sql-cv.BankCVdataset.stage_transactions`
WHERE TransactionID IS NOT NULL;


