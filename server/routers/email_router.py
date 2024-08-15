from fastapi import APIRouter, Depends
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from db.connection import get_db

from apis import email


session_data = {}

router = APIRouter(prefix="/login", tags=["LOGIN"])

@router.post("/email")
def login_email(email_str: str, db: Session = Depends(get_db)):
    if email.check_email(email=email_str, db=db):
        # 로그인하기
        pass
    else:
        # 회원가입하기
        
        pass
        

@router.post("/social")
def login_social(token: str, db: Session = Depends(get_db)):
    email.login_social(token=token, db=db)