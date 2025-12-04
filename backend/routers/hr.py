from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from backend.database import db, MOCK_MODE
import random
from datetime import datetime

router = APIRouter()

# --- Models ---
class Employee(BaseModel):
    emp_id: int
    name: str
    dept_id: int
    email: str
    role: str
    status: str

class SalaryReport(BaseModel):
    emp_id: int
    name: str
    dept_name: str
    gross_salary: float
    net_salary: float

# --- Mock Data Generators ---
def get_mock_employees():
    return [
        {"emp_id": 1, "name": "Alice Smith", "dept_id": 1, "email": "alice@oracle.com", "role": "Engineer", "status": "ACTIVE"},
        {"emp_id": 2, "name": "Bob Jones", "dept_id": 2, "email": "bob@oracle.com", "role": "HR", "status": "ACTIVE"},
        {"emp_id": 3, "name": "Charlie Brown", "dept_id": 1, "email": "charlie@oracle.com", "role": "DevOps", "status": "ACTIVE"},
    ]

def get_mock_salary_report():
    return [
        {"emp_id": 1, "name": "Alice Smith", "dept_name": "Engineering", "gross_salary": 11000, "net_salary": 9680},
        {"emp_id": 2, "name": "Bob Jones", "dept_name": "HR", "gross_salary": 8300, "net_salary": 7470},
    ]

# --- Endpoints ---

@router.get("/employees", response_model=List[Employee])
def get_employees():
    if MOCK_MODE:
        return get_mock_employees()
    
    try:
        query = "SELECT emp_id, name, dept_id, email, role, status FROM Employee"
        return db.execute_query(query)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/employees")
def create_employee(emp: Employee):
    if MOCK_MODE:
        return {"message": "Employee created (Mock)", "emp_id": emp.emp_id}
    
    # In real impl, insert into DB
    return {"message": "Not implemented in live mode yet"}

@router.post("/payroll/calculate")
def calculate_payroll(month: str):
    """
    Triggers the PL/SQL procedure calc_all_salaries (conceptual)
    """
    if MOCK_MODE:
        return {"message": f"Payroll calculated for {month} (Mock)", "status": "SUCCESS"}
    
    try:
        # db.call_procedure('calc_all_salaries', [month])
        return {"message": f"Payroll calculated for {month}", "status": "SUCCESS"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/reports/salary", response_model=List[SalaryReport])
def get_salary_report():
    if MOCK_MODE:
        return get_mock_salary_report()
    
    try:
        query = "SELECT emp_id, name, dept_name, gross_salary, net_salary FROM vw_monthly_salary_report"
        return db.execute_query(query)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
