from fastapi import APIRouter, HTTPException
from typing import List, Dict, Any
from backend.database import db, MOCK_MODE
import random
from datetime import datetime, timedelta

router = APIRouter()

# --- Mock Data ---
def get_mock_logs():
    logs = []
    attacks = ["DoS", "Reconnaissance", "Fuzzers", "Normal"]
    for i in range(10):
        cat = random.choice(attacks)
        logs.append({
            "log_id": 100 + i,
            "src_ip": f"192.168.1.{random.randint(10, 99)}",
            "dst_ip": "10.0.0.5",
            "attack_cat": cat,
            "label": 1 if cat != "Normal" else 0,
            "timestamp": (datetime.now() - timedelta(minutes=i*10)).isoformat()
        })
    return logs

def get_mock_stats():
    return [
        {"attack_cat": "DoS", "count": 150},
        {"attack_cat": "Reconnaissance", "count": 80},
        {"attack_cat": "Fuzzers", "count": 45},
    ]

# --- Endpoints ---

@router.get("/logs")
def get_recent_logs():
    if MOCK_MODE:
        return get_mock_logs()
    
    try:
        query = "SELECT * FROM Network_Logs ORDER BY log_timestamp DESC FETCH FIRST 50 ROWS ONLY"
        return db.execute_query(query)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/predictions")
def get_predictions():
    """
    Returns predictions from the OML model view
    """
    if MOCK_MODE:
        # Simulate predictions
        data = get_mock_logs()
        for d in data:
            d["predicted_label"] = d["label"] # Perfect prediction for mock
            d["probability"] = 0.95 if d["label"] == 1 else 0.02
        return data

    try:
        query = "SELECT * FROM vw_intrusion_predictions FETCH FIRST 50 ROWS ONLY"
        return db.execute_query(query)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/stats")
def get_attack_stats():
    if MOCK_MODE:
        return get_mock_stats()
    
    try:
        query = "SELECT attack_cat, attack_count FROM vw_attack_stats"
        return db.execute_query(query)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
