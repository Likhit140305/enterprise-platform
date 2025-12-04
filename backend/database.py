import os
import oracledb
from typing import Optional

# Configuration
DB_USER = os.getenv("DB_USER", "admin")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_DSN = os.getenv("DB_DSN", "localhost/xepdb1")
MOCK_MODE = os.getenv("MOCK_MODE", "True").lower() == "true"

class Database:
    def __init__(self):
        self.connection = None

    def connect(self):
        global MOCK_MODE  # valid here inside method
        if MOCK_MODE:
            print("Running in MOCK MODE. No actual DB connection.")
            return
        
        try:
            self.connection = oracledb.connect(
                user=DB_USER,
                password=DB_PASSWORD,
                dsn=DB_DSN
            )
            print("Successfully connected to Oracle Database")

        except Exception as e:
            print(f"Failed to connect to Oracle DB: {e}")
            print("Falling back to MOCK MODE")
            MOCK_MODE = True  # switch to mock mode safely

    def close(self):
        if self.connection:
            self.connection.close()

    def execute_query(self, query: str, params: dict = None):
        global MOCK_MODE
        
        if MOCK_MODE:
            print("[MOCK] Query:", query)
            return []  # optional later: return mock json-based results
        
        cursor = self.connection.cursor()
        cursor.execute(query, params or {})
        columns = [col[0] for col in cursor.description]
        result = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        cursor.close()
        return result


db = Database()
