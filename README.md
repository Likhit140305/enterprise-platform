# Oracle-Powered Enterprise HR & Security Intelligence Platform

## Project Overview
This project is a comprehensive **Enterprise Intelligence Suite** designed to demonstrate advanced capabilities in **Oracle Database**, **PL/SQL**, **Oracle Autonomous Database**, and **Oracle Machine Learning (OML)**.

It consists of two major modules:
1.  **HR Payroll & Performance Management**: A robust system for managing employees, processing complex payroll logic using PL/SQL, and tracking performance.
2.  **Network Intrusion Detection System**: A security analytics platform that uses in-database Machine Learning (OML) to detect network attacks in real-time.

## Technology Stack
-   **Database**: Oracle Database 19c / 21c (HR Module), Oracle Autonomous Database (Security Module)
-   **Backend**: Python (FastAPI), OracleDB Driver
-   **Frontend**: React.js, Tailwind CSS, Recharts
-   **Machine Learning**: Oracle Machine Learning (OML) for SQL

## Resume Highlights
> Copy these points to your resume to showcase your Oracle expertise.

*   **Enterprise Application Development**: Architected a dual-module enterprise platform integrating **Oracle Database** for transactional HR systems and **Oracle Autonomous Database** for security analytics.
*   **Advanced PL/SQL Programming**: implemented complex business logic for payroll processing and leave management using **Stored Procedures**, **Functions**, **Triggers**, and **Packages**, ensuring data integrity and high performance.
*   **In-Database Machine Learning**: Deployed an Intrusion Detection System using **Oracle Machine Learning (OML)**, training classification models directly within the database to detect network threats with high accuracy.
*   **Full-Stack Integration**: Built a modern **React** dashboard connected to a **Python FastAPI** backend, utilizing **OracleDB** drivers for efficient connection pooling and data retrieval.
*   **Data Visualization & Analytics**: Designed interactive dashboards to visualize workforce metrics and security threats, mimicking **Oracle Analytics Cloud** capabilities.

## Setup Instructions

### Prerequisites
-   Python 3.9+
-   Node.js 16+
-   Oracle Database (Local XE or Cloud Autonomous DB)

### 1. Database Setup
1.  **HR Module**: Connect to your Oracle DB as a privileged user and run:
    ```sql
    @database/schema_hr.sql
    @database/procedures_hr.sql
    @database/seed_data.sql
    ```
2.  **Security Module**: Connect to your Autonomous DB (or same DB) and run:
    ```sql
    @database/schema_security.sql
    @database/ml_model_security.sql
    ```

### 2. Backend Setup
The backend includes a **Mock Mode** so you can run the UI without a live DB connection initially.

1.  Navigate to the `backend` directory (root of the project for python context):
    ```bash
    pip install -r backend/requirements.txt
    ```
2.  Run the server:
    ```bash
    uvicorn backend.main:app --reload
    ```
    *   The API will start at `http://localhost:8000`.
    *   To connect to a real DB, update `backend/database.py` or set environment variables `DB_USER`, `DB_PASSWORD`, `DB_DSN`, and set `MOCK_MODE=False`.

### 3. Frontend Setup
1.  Navigate to the `frontend` directory:
    ```bash
    cd frontend
    npm install
    ```
2.  Start the development server:
    ```bash
    npm run dev
    ```
3.  Open your browser at `http://localhost:5173`.

### 4. Running Tests
The project includes automated tests for the backend API.
1.  Navigate to the project root:
    ```bash
    pip install pytest httpx
    ```
2.  Run the tests:
    ```bash
    pytest backend/tests
    ```

### 5. Docker Support
You can containerize the backend application using the provided Dockerfile.
1.  Build the image:
    ```bash
    docker build -t oracle-enterprise-backend .
    ```
2.  Run the container:
    ```bash
    docker run -p 8000:8000 oracle-enterprise-backend
    ```


## Features

### HR Module
-   **Employee Management**: View and manage employee details.
-   **Payroll Processing**: Trigger PL/SQL procedures to calculate net salary, tax, and bonuses.
-   **Performance Tracking**: Visualize performance ratings and their impact on bonuses.

### Security Module
-   **Intrusion Detection**: Real-time classification of network logs using OML.
-   **Threat Dashboard**: Visual breakdown of attack categories (DoS, Recon, etc.).
-   **Live Alerts**: Feed of detected threats with probability scores.

## Project Structure
```
oracle_enterprise_platform/
├── backend/                # Python FastAPI Application
│   ├── routers/            # API Endpoints
│   ├── database.py         # DB Connection & Mock Logic
│   └── main.py             # Entry Point
├── database/               # SQL & PL/SQL Scripts
│   ├── schema_hr.sql       # HR Schema
│   ├── procedures_hr.sql   # HR Logic (Procedures, Triggers)
│   ├── schema_security.sql # Security Schema
│   └── ml_model_security.sql # OML Model Scripts
├── frontend/               # React Application
│   ├── src/
│   │   ├── components/     # Reusable Components
│   │   ├── pages/          # Dashboard Pages
│   │   └── App.jsx         # Main Router
└── README.md               # Documentation
```
