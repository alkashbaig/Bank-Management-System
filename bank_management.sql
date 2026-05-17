CREATE DATABASE bank;
USE bank;

-- Creating tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    address TEXT
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    account_type VARCHAR(20),
    balance DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_type VARCHAR(20), -- deposit / withdrawal
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    loan_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Sample Data
INSERT INTO Customers (name, email, phone, address) VALUES
('Alkash', 'alkash@gmail.com', '9876543210', 'Delhi'),
('Rahul', 'rahul@gmail.com', '9123456780', 'Mumbai');

INSERT INTO Accounts (customer_id, account_type, balance) VALUES
(1, 'Savings', 5000),
(2, 'Current', 10000);

-- Deposite Money
DELIMITER //

CREATE PROCEDURE DepositMoney(IN acc_id INT, IN amt DECIMAL(10,2))
BEGIN
    UPDATE Accounts 
    SET balance = balance + amt 
    WHERE account_id = acc_id;

    INSERT INTO Transactions (account_id, transaction_type, amount)
    VALUES (acc_id, 'Deposit', amt);
END //

DELIMITER ;

-- Withdrawl Money
DELIMITER //

CREATE PROCEDURE WithdrawMoney(IN acc_id INT, IN amt DECIMAL(10,2))
BEGIN
    DECLARE current_balance DECIMAL(10,2);

    SELECT balance INTO current_balance 
    FROM Accounts WHERE account_id = acc_id;

    IF current_balance >= amt THEN
        UPDATE Accounts 
        SET balance = balance - amt 
        WHERE account_id = acc_id;

        INSERT INTO Transactions (account_id, transaction_type, amount)
        VALUES (acc_id, 'Withdrawal', amt);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient Balance';
    END IF;
END //

DELIMITER ;

-- Transfer Money
DELIMITER //

CREATE PROCEDURE TransferMoney(
    IN sender INT,
    IN receiver INT,
    IN amt DECIMAL(10,2)
)
BEGIN
    DECLARE sender_balance DECIMAL(10,2);

    SELECT balance INTO sender_balance 
    FROM Accounts WHERE account_id = sender;

    IF sender_balance >= amt THEN

        UPDATE Accounts 
        SET balance = balance - amt 
        WHERE account_id = sender;

        UPDATE Accounts 
        SET balance = balance + amt 
        WHERE account_id = receiver;

        INSERT INTO Transactions (account_id, transaction_type, amount)
        VALUES (sender, 'Transfer', amt),
               (receiver, 'Transfer', amt);

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transfer Failed: Insufficient Balance';
    END IF;
END //

DELIMITER ;

-- Trigger (Prevent Negative Balance)
DELIMITER //

CREATE TRIGGER PreventNegativeBalance
BEFORE UPDATE ON Accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Balance cannot be negative';
    END IF;
END //

DELIMITER ;

SELECT * FROM Customers;

SELECT c.name, a.account_type, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;

SELECT * FROM Transactions
WHERE account_id = 1;

CALL DepositMoney(1, 2000);
CALL WithdrawMoney(1, 1000);
CALL TransferMoney(1, 2, 500);
