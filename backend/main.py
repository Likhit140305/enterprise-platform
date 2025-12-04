from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.routers import hr, security

app = FastAPI(
    title="Oracle Enterprise Intelligence Platform",
    description="Backend API for HR Payroll & Security Analytics",
    version="1.0.0"
)

# CORS Configuration
origins = [
    "http://localhost:3000",
    "http://localhost:5173", # Vite default
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(hr.router, prefix="/api/hr", tags=["HR Management"])
app.include_router(security.router, prefix="/api/security", tags=["Security Analytics"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the Oracle Enterprise Intelligence Platform API"}
