-- Drop table if it exists
DROP TABLE IF EXISTS StudentEnrollments;

-- Create table
CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE
);

-- Insert sample data
INSERT INTO StudentEnrollments (student_id, student_name, course_id, enrollment_date)
VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');
-- Start transaction
START TRANSACTION;

-- Lock row 1 first
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-01'
WHERE student_id = 1;

-- Now try to update row 2 (this will conflict with Session 2)
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-02'
WHERE student_id = 2;

-- Commit
COMMIT;
-- Start transaction
START TRANSACTION;

-- Lock row 2 first
UPDATE StudentEnrollments
SET enrollment_date = '2024-08-01'
WHERE student_id = 2;

-- Now try to update row 1 (conflicts with Session 1)
UPDATE StudentEnrollments
SET enrollment_date = '2024-08-02'
WHERE student_id = 1;

-- Commit
COMMIT;

-- Start transaction
START TRANSACTION;

-- Read current enrollment_date (MVCC snapshot)
SELECT enrollment_date 
FROM StudentEnrollments
WHERE student_id = 1;

-- Result: 2024-06-01
-- Start transaction
START TRANSACTION;

-- Update the same row
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-10'
WHERE student_id = 1;

COMMIT;
SELECT enrollment_date 
FROM StudentEnrollments
WHERE student_id = 1;

-- Result still shows 2024-06-01 (old snapshot)
-- Because of MVCC, the read sees a consistent snapshot
-- Session 1 (Reader)
START TRANSACTION;

-- Lock the row with SELECT FOR UPDATE
SELECT enrollment_date 
FROM StudentEnrollments
WHERE student_id = 1
FOR UPDATE;

-- Session 2 (Writer)
START TRANSACTION;

-- Attempt to update the same row
UPDATE StudentEnrollments
SET enrollment_date = '2024-08-01'
WHERE student_id = 1;

-- ❌ Session 2 will be BLOCKED until Session 1 commits


-- Session 1 (Reader)
START TRANSACTION;

-- Normal SELECT (no FOR UPDATE)
SELECT enrollment_date 
FROM StudentEnrollments
WHERE student_id = 1;

-- Session 2 (Writer)
START TRANSACTION;
UPDATE StudentEnrollments
SET enrollment_date = '2024-08-01'
WHERE student_id = 1;
COMMIT;

-- Session 1 continues
SELECT enrollment_date 
FROM StudentEnrollments
WHERE student_id = 1;

-- Session 1 still sees old value (MVCC snapshot)
