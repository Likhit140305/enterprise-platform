-- HR PAYROLL & PERFORMANCE MANAGEMENT SYSTEM
-- PL/SQL Procedures, Functions, Triggers & Views

-- -----------------------------------------------------------------------------
-- 1. For viewing of files 
-- -----------------------------------------------------------------------------

-- Monthly Salary Report
CREATE OR REPLACE VIEW vw_monthly_salary_report AS
SELECT 
    e.emp_id,
    e.name,
    d.dept_name,
    s.basic,
    s.hra,
    s.allowance,
    (s.basic + s.hra + s.allowance) AS gross_salary,
    ((s.basic + s.hra + s.allowance) * s.tax_percent / 100) AS tax_deduction,
    ((s.basic + s.hra + s.allowance) * (1 - s.tax_percent / 100)) AS net_salary
FROM Employee e
JOIN Salary s ON e.emp_id = s.emp_id
JOIN Department d ON e.dept_id = d.dept_id;

-- Top Performers
CREATE OR REPLACE VIEW vw_top_performers AS
SELECT 
    p.review_month,
    e.name,
    d.dept_name,
    p.rating,
    p.bonus_amount
FROM Performance p
JOIN Employee e ON p.emp_id = e.emp_id
JOIN Department d ON e.dept_id = d.dept_id
WHERE p.rating >= 4.5
ORDER BY p.rating DESC, p.bonus_amount DESC;

-- -----------------------------------------------------------------------------
-- 2. Functions used in the system ( like calculate bonus, basic salaary, bonus percentage etc)
-- -----------------------------------------------------------------------------

-- Function: Calculate Bonus
CREATE OR REPLACE FUNCTION get_performance_bonus(p_emp_id NUMBER, p_rating NUMBER) 
RETURN NUMBER IS
    v_basic_salary NUMBER;
    v_bonus_pct    NUMBER;
BEGIN
    -- Get basic salary
    SELECT basic INTO v_basic_salary FROM Salary WHERE emp_id = p_emp_id;
    
    -- Determine bonus percentage
    IF p_rating >= 4.8 THEN v_bonus_pct := 0.20; -- 20%
    ELSIF p_rating >= 4.0 THEN v_bonus_pct := 0.10; -- 10%
    ELSIF p_rating >= 3.0 THEN v_bonus_pct := 0.05; -- 5%
    ELSE v_bonus_pct := 0;
    END IF;
    
    RETURN v_basic_salary * v_bonus_pct;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- -----------------------------------------------------------------------------
-- 3. PROCEDURES
-- -----------------------------------------------------------------------------

-- Procedure: Calculate Salary for an Employee for a specific month
-- For this demo, we'll output to DBMS_OUTPUT and conceptually this would populate a Payslip table
CREATE OR REPLACE PROCEDURE calc_salary(p_emp_id NUMBER, p_month VARCHAR2) IS
    v_emp_rec       Employee%ROWTYPE;
    v_sal_rec       Salary%ROWTYPE;
    v_overtime_hrs  NUMBER := 0;
    v_bonus         NUMBER := 0;
    v_gross         NUMBER;
    v_tax           NUMBER;
    v_net           NUMBER;
    v_overtime_pay  NUMBER;
BEGIN
    -- Get Employee & Salary details
    SELECT * INTO v_emp_rec FROM Employee WHERE emp_id = p_emp_id;
    SELECT * INTO v_sal_rec FROM Salary WHERE emp_id = p_emp_id;
    
    -- Calculate Overtime (Sum of overtime hours for the month)
    SELECT NVL(SUM(overtime_hours), 0) INTO v_overtime_hrs
    FROM Attendance 
    WHERE emp_id = p_emp_id 
    AND TO_CHAR(work_date, 'YYYY-MM') = p_month;
    
    -- Overtime rate: (Basic / 160 hours) * 1.5
    v_overtime_pay := (v_sal_rec.basic / 160) * 1.5 * v_overtime_hrs;
    
    -- Get Bonus if exists for that month
    BEGIN
        SELECT bonus_amount INTO v_bonus 
        FROM Performance 
        WHERE emp_id = p_emp_id AND review_month = p_month;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_bonus := 0;
    END;
    
    -- Final Calculation
    v_gross := v_sal_rec.basic + v_sal_rec.hra + v_sal_rec.allowance + v_overtime_pay + v_bonus;
    v_tax := v_gross * (v_sal_rec.tax_percent / 100);
    v_net := v_gross - v_tax;
    
    DBMS_OUTPUT.PUT_LINE('Payslip for ' || v_emp_rec.name || ' (' || p_month || ')');
    DBMS_OUTPUT.PUT_LINE('Basic: ' || v_sal_rec.basic);
    DBMS_OUTPUT.PUT_LINE('Overtime Pay: ' || ROUND(v_overtime_pay, 2));
    DBMS_OUTPUT.PUT_LINE('Bonus: ' || v_bonus);
    DBMS_OUTPUT.PUT_LINE('Gross: ' || ROUND(v_gross, 2));
    DBMS_OUTPUT.PUT_LINE('Net Salary: ' || ROUND(v_net, 2));
    
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error calculating salary: ' || SQLERRM);
END;
/

-- Procedure: Process Leave Request
CREATE OR REPLACE PROCEDURE process_leave_request(
    p_emp_id NUMBER, 
    p_leave_date DATE, 
    p_leave_type VARCHAR2
) IS
    v_count NUMBER;
BEGIN
    -- Check if already on leave
    SELECT COUNT(*) INTO v_count FROM Leave 
    WHERE emp_id = p_emp_id AND leave_date = p_leave_date;
    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee already has a leave record for this date.');
    END IF;
    
    -- Auto-approve if Casual leave, else Pending
    INSERT INTO Leave (emp_id, leave_date, leave_type, status)
    VALUES (
        p_emp_id, 
        p_leave_date, 
        p_leave_type, 
        CASE WHEN p_leave_type = 'CASUAL' THEN 'APPROVED' ELSE 'PENDING' END
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Leave request submitted successfully.');
END;
/

-- -----------------------------------------------------------------------------
-- 4. TRIGGERS
-- -----------------------------------------------------------------------------

-- Trigger: Auto-calculate bonus when Performance is inserted
CREATE OR REPLACE TRIGGER trg_calc_bonus
BEFORE INSERT ON Performance
FOR EACH ROW
BEGIN
    :NEW.bonus_amount := get_performance_bonus(:NEW.emp_id, :NEW.rating);
END;
/

-- Trigger: Audit Salary Changes (Concept)
-- Would typically write to an Audit table
CREATE OR REPLACE TRIGGER trg_salary_audit
AFTER UPDATE OF basic ON Salary
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salary changed for Emp ID ' || :OLD.emp_id || 
                         ' from ' || :OLD.basic || ' to ' || :NEW.basic);
END;
/
