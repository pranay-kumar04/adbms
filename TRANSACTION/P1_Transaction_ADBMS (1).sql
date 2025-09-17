DROP TABLE IF EXISTS FeePayments;

CREATE TABLE FeePayments (
    payment_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_date DATE NOT NULL
);

-- ===============================
-- Part A
-- ===============================
START TRANSACTION;
INSERT INTO FeePayments VALUES (1, 'Ashish', 5000.00, '2024-06-01');
INSERT INTO FeePayments VALUES (2, 'Smaran', 4500.00, '2024-06-02');
INSERT INTO FeePayments VALUES (3, 'Vaibhav', 5500.00, '2024-06-03');
COMMIT;
SELECT * FROM FeePayments;

-- ===============================
-- Part B
-- ===============================
START TRANSACTION;
INSERT INTO FeePayments VALUES (4, 'Kiran', 4000.00, '2024-06-04');
INSERT INTO FeePayments VALUES (1, 'Ashish', -3000.00, '2024-06-05'); -- duplicate + invalid
ROLLBACK;
SELECT * FROM FeePayments;

-- ===============================
-- Part C
-- ===============================
START TRANSACTION;
INSERT INTO FeePayments VALUES (5, 'Neha', 6000.00, '2024-06-06');
INSERT INTO FeePayments VALUES (6, NULL, 7000.00, '2024-06-07'); -- invalid NULL
ROLLBACK;
SELECT * FROM FeePayments;

-- ===============================
-- Part D
-- ===============================
START TRANSACTION;
INSERT INTO FeePayments VALUES (7, 'Rohit', 6500.00, '2024-06-08');
INSERT INTO FeePayments VALUES (2, 'Duplicate', 3000.00, '2024-06-09'); -- duplicate
ROLLBACK;

START TRANSACTION;
INSERT INTO FeePayments VALUES (8, 'Priya', 7000.00, '2024-06-10');
COMMIT;

SELECT * FROM FeePayments;