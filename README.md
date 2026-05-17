# Bank Management System using MySQL

A complete SQL-based Bank Management System developed using MySQL. This project simulates core banking operations such as customer management, account handling, deposits, withdrawals, fund transfers, loan management, and transaction tracking.

---

## Features

- Create and manage customers
- Open different types of bank accounts
- Deposit money
- Withdraw money with balance validation
- Transfer funds between accounts
- Record all transactions automatically
- Manage customer loans
- Prevent negative balances using triggers
- Handle errors using SQL SIGNAL

---

## Database Tables

### Customers
Stores customer personal information.

### Accounts
Stores account details such as account type and balance.

### Transactions
Maintains a history of all deposits, withdrawals, and transfers.

### Loans
Stores loan information including loan amount, interest rate, and status.

---

## Stored Procedures

### DepositMoney(acc_id, amt)
Deposits money into an account and records the transaction.

### WithdrawMoney(acc_id, amt)
Withdraws money after checking sufficient balance.

### TransferMoney(sender, receiver, amt)
Transfers money between two accounts and logs both transactions.

---

## Trigger

### PreventNegativeBalance
Prevents any account balance from becoming negative.

---

## Technologies Used

- MySQL
- SQL
- MySQL Workbench

---

## SQL Concepts Demonstrated

- CREATE DATABASE
- CREATE TABLE
- PRIMARY KEY
- FOREIGN KEY
- AUTO_INCREMENT
- STORED PROCEDURES
- TRIGGERS
- JOINS
- SIGNAL for custom error handling
- TIMESTAMP
- DECIMAL data type

---

## Sample Operations

```sql
CALL DepositMoney(1, 2000);
CALL WithdrawMoney(1, 1000);
CALL TransferMoney(1, 2, 500);
