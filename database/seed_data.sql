-- SEED DATA SCRIPT
-- Populates HR and Security tables with sample data for demonstration

-- 1. User Logins
INSERT INTO User_Login (username, password_hash, role) VALUES ('admin', 'hashed_secret', 'ADMIN');
INSERT INTO User_Login (username, password_hash, role) VALUES ('hr_manager', 'hashed_secret', 'HR');
INSERT INTO User_Login (username, password_hash, role) VALUES ('john_doe', 'hashed_secret', 'EMPLOYEE');

-- 2. Departments
INSERT INTO Department (dept_name, location) VALUES ('Engineering', 'Building A');
INSERT INTO Department (dept_name, location) VALUES ('Human Resources', 'Building B');
INSERT INTO Department (dept_name, location) VALUES ('Sales', 'Building C');

-- 3. Employees
INSERT INTO Employee (name, dept_id, email, role, status, user_id) 
VALUES ('Alice Smith', 1, 'alice@oracle-demo.com', 'Software Engineer', 'ACTIVE', 3);

INSERT INTO Employee (name, dept_id, email, role, status, user_id) 
VALUES ('Bob Jones', 2, 'bob@oracle-demo.com', 'HR Specialist', 'ACTIVE', 2);

INSERT INTO Employee (name, dept_id, email, role, status, user_id) 
VALUES ('Charlie Brown', 1, 'charlie@oracle-demo.com', 'DevOps Engineer', 'ACTIVE', NULL);

-- Update Manager for Depts
UPDATE Department SET manager_id = 1 WHERE dept_id = 1; -- Alice manages Engineering

-- 4. Salaries
INSERT INTO Salary (emp_id, basic, hra, allowance, tax_percent) VALUES (1, 8000, 2000, 1000, 12);
INSERT INTO Salary (emp_id, basic, hra, allowance, tax_percent) VALUES (2, 6000, 1500, 800, 10);
INSERT INTO Salary (emp_id, basic, hra, allowance, tax_percent) VALUES (3, 7500, 1800, 900, 12);

-- 5. Attendance (Sample for current month)
INSERT INTO Attendance (emp_id, work_date, hours_worked, overtime_hours) 
VALUES (1, SYSDATE - 1, 9, 1);
INSERT INTO Attendance (emp_id, work_date, hours_worked, overtime_hours) 
VALUES (1, SYSDATE - 2, 8, 0);
INSERT INTO Attendance (emp_id, work_date, hours_worked, overtime_hours) 
VALUES (2, SYSDATE - 1, 8, 0);

-- 6. Performance
INSERT INTO Performance (emp_id, review_month, rating, reviewer_id, comments)
VALUES (1, TO_CHAR(SYSDATE, 'YYYY-MM'), 4.8, 2, 'Exceptional performance in Q3');

INSERT INTO Performance (emp_id, review_month, rating, reviewer_id, comments)
VALUES (3, TO_CHAR(SYSDATE, 'YYYY-MM'), 3.5, 1, 'Met expectations but needs improvement in communication');

-- 7. Network Logs (Security Module)
-- Normal Traffic
INSERT INTO Network_Logs (src_ip, dst_ip, attack_cat, label, dbytes) 
VALUES ('192.168.1.10', '10.0.0.5', 'Normal', 0, 500);
INSERT INTO Network_Logs (src_ip, dst_ip, attack_cat, label, dbytes) 
VALUES ('192.168.1.12', '10.0.0.5', 'Normal', 0, 1200);

-- Attack Traffic
INSERT INTO Network_Logs (src_ip, dst_ip, attack_cat, label, dbytes) 
VALUES ('203.0.113.55', '10.0.0.5', 'DoS', 1, 50000);
INSERT INTO Network_Logs (src_ip, dst_ip, attack_cat, label, dbytes) 
VALUES ('198.51.100.23', '10.0.0.5', 'Reconnaissance', 1, 200);

COMMIT;
