from fastapi.testclient import TestClient
from backend.main import app
import os

# Force Mock Mode for testing
os.environ["MOCK_MODE"] = "True"

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to the Oracle Enterprise Intelligence Platform API"}

def test_get_employees():
    response = client.get("/api/hr/employees")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0
    assert "name" in data[0]

def test_calculate_payroll():
    response = client.post("/api/hr/payroll/calculate?month=2023-10")
    assert response.status_code == 200
    assert response.json()["status"] == "SUCCESS"

def test_get_salary_report():
    response = client.get("/api/hr/reports/salary")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert "gross_salary" in data[0]

def test_get_security_logs():
    response = client.get("/api/security/logs")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert "src_ip" in data[0]

def test_get_security_predictions():
    response = client.get("/api/security/predictions")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert "predicted_label" in data[0]
