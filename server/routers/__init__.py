from typing import Optional
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.connection import get_db
from sqlalchemy import text


db_check = APIRouter(prefix="/dbcheck", tags=["db_check"])

@db_check.get("/")
def check_db_connection(db: Session = Depends(get_db)):
    try:
        # 간단한 쿼리를 실행하여 연결 확인
        db.execute(text("SELECT 1"))
        return {"status": "Database connection successful"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection failed: {str(e)}")
    
@db_check.get("/token")
def get_token():
    return {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEwMjc2MDA5MjkxMjEwNzk4MDk3NSIsImV4cGlyZXMiOjE4MzAxNjQ4MzN9.5qmfEZO2-JIctGnW-5Day2K3ScHRTnTpzIUXJfIWeLU"}