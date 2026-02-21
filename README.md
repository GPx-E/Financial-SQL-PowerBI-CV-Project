# 🎓Financial-SQL-PowerBI-CV-Project🎓
## Project Overview

This project simulates a real-world end-to-end data analytics workflow using a banking dataset.
The objective is to transform raw CSV data into a structured analytical model and build interactive dashboards that support future business decision making.

The project is articulate as a full analytics lifecycle following the next steps:
```markdown
1) Data ingestion
2) Data cleaning & transformation
3) Data modelling
4) Metric creation
5) Dashboard development
```

The goal of this project is to analyse banking operations from different perspectives such as:

  - Customer behaviour.
  - Account performance.
  - Loan portfolio health.
  - Transaction activity.
  - Branch performance.

With that said, some relevant bussines questions the project aim to answer are:
```markdown
1) How active are customers and accounts?
2) Which branches generate the highest transaction volume?
3) What is the distribution of loans by status?
4) How does transaction activity evolve over time?
```

Before starting the project architecture and reasoning, it would be nice to know which programs and lenguages I had use in order:

  - SQL (modeling).
  - Google Cloud BigQuery (Data warehouse).
  - PowerBI (modeling data and dashboards)
  - DAX (KPI and bussines metrics)

## SQL and BigQuery

After importing the different CSV archives, the first step was to design a structured data workflow that separates raw from analytical data.

To achieve this, the project follows a two-layer architecture:

1) Stage Layer or Raw Data: All CSV files were initially loaded into staging tables using BigQuery’s automatic schema detection. The objective was to stored data with minimal transformations.

2) Once staging tables were created, core tables were built using SQL transformations to prepare the data for analysis. This process included:
  - Casting data types to ensure consistency.
  - Removing duplicates and filtering invalid data.
  - Standardising column names.
  - Applying basic business logic.

## Data Modeling

After procesing all data and creating the core tables, the next goal was define which model to use in PowerBI.

Following the data estructure and how all tables where related by id columns, the naturally step was creating a star schema where transactional tables act as fact tables and descriptive tables provide dimensional context.

1) FACT TABLES

  These tables contain measurable business events and numeric metrics.
    - core_transactions: Financial activity between accounts.
    - core_loans: Loan information including principal and interest.
    - core_accounts: Account-level financial metrics

2) DIMENSIONAL TABLES

  Tables provide descriptive attributes used for filtering and grouping:
    - core_customers
    - core_customer_types
    - core_account_types
    - core_account_statuses
    - core_transaction_types
    - core_branches
    - core_addresses
    - core_loan_statuses

## DAX Measures

After connecting all tables, I built a dedicated Measures Table to centralise calculations and improve model readability. The next metrics where added in the new table:

  - Total Transactions
  - Total Transaction Amount
  - Average Transaction
  - Total Loans
  - Total Principal Amount
  - Total Customers
  - Total Accounts
  - Total Balance
  - Active Accounts
  - Active Account %
  - Loans per Account
  - Transactions per Account

This separation keeps business logic independent from the data structure and improves maintainability of the modeling.

## PowerBI Dashboard Logic
Two dashboards were developed to demonstrate different analytical perspectives:

1) EXECUTIVE DASHBOARD
   
  This dashboard aims to support strategic decision-making with minimal cognitive load. The executive view focuses on high-level KPIs and quick insights like:

      - KPI cards for transactions, balances, and loans.
      - Transaction distribution by customer type.
      - Branch performance comparison.
      - Time-series overview of transaction activity.
      - Interactive filters for time, branch, and customer type.


   
2) ANALYTICAL DASHBOARD

     This dashboard allows users to investigate patterns, detect anomalies, and explore performance. In other words, is the analytical view provides deeper exploration of operational performance:

        - Loan portfolio breakdown by status
        - Interest rate comparison across loan states
        - Transaction performance by account
        - Branch-level performance matrix
        - Time-based trends combining volume and value metrics

## Wrapping Up

This project demonstrates an end-to-end analytical workflow covering:

1) Data ingestion and transformation in BigQuery
2) Data warehouse layering (stage → core)
3) Analytical data modelling
4) Power BI integration using DirectQuery
5) DAX measure design and metric standardisation

## EXTRA INFORMATION
To maintain a proper reading structure, I recommend opening the 1-Creation_Core_Tables.sql first, followed by 2-Fill_&_Fix_Core_Tables.sql. After that, opening PowerBI.pbix. Additionally, the dataset has too many different CSV achives so, to optimise space and improve reading of the project, I uploaded all the data used in a zip achive (Data from Kaggle.zip).

Thank you very much for reading this far.

Best regards.

GPx-E
