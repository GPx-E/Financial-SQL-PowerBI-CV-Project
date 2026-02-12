/*
After uploading all csv archives and creating the stage tables, I can continue creating the core tables.

Core tables are gonna be our already filtering tables. In other words, I'm gonna cleanup all the information, select the type of information and process it from the raw stage.

Bur first thing first, Let's start creating the core tables starting from: 
- Reference tables (small ones). 
- Dimensional tables (medium ones).
- Fact tables (big ones).
*/

-- REFERENCE TABLES --

-- Customer Types:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_customer_types`(
customer_type_id INT64 NOT NULL,
type_name STRING NOT NULL
);

-- Account Types:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_account_types`(
account_type_id INT64 NOT NULL,
type_name STRING NOT NULL
);

--Account Statuses:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_account_statuses`(
account_status_id INT64 NOT NULL,
status_name STRING NOT NULL
);

--Loan Statuses: 
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_loan_statuses`(
loan_status_id INT64 NOT NULL,
status_name STRING NOT NULL
);

--Transaction Types:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_transaction_types`(
transaction_type_id INT64 NOT NULL,
type_name STRING NOT NULL
);

----------------------------------------------------------------------------------

-- DIMENSIONAL TABLES --

--Addresses:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_addresses`(
address_id INT64 NOT NULL,
street STRING,
city STRING,
country STRING
);

-- Branches:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_branches`(
branch_id INT64 NOT NULL,
branch_name STRING,
address_id INT64
);

-- Customers:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_customers`(
customer_id INT64 NOT NULL,
first_name STRING,
last_name STRING,
date_of_birth DATE,
address_id INT64,
customer_type_id INT64
);

-- Accounts:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_accounts`(
account_id INT64 NOT NULL,
customer_id INT64,
account_type_id INT64,
account_status_id INT64,
balance NUMERIC,
opening_date DATE
);

---------------------------------------------------------------------------
-- FACT TABLES --

-- Loans:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_loans`(
loan_id INT64 NOT NULL,
account_id INT64,
loan_status_id INT64,
principal_amount NUMERIC,
interest_rate NUMERIC,
start_date DATE,
estimated_end_date DATE
);

-- Transactions:
CREATE OR REPLACE TABLE `project-sql-cv.BankCVdataset.core_transactions`(
transaction_id INT64 NOT NULL,
account_origin_id INT64,
account_destination_id INT64,
transaction_type_id INT64,
amount NUMERIC,
transaction_ts TIMESTAMP,
branch_id INT64,
description STRING
);
