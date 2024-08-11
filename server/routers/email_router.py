from fastapi import APIRouter, Depends
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from db.connection import get_db

from views import email_view as view


session_data = {}

router = APIRouter(prefix="/login", tags=["LOGIN"])

@router.post("/email")
def login_email(email: str, db: Session = Depends(get_db)):
    if view.check_email(email=email, db=db):
        # 로그인하기
        pass
    else:
        # 회원가입하기
        
        pass
        

@router.post("/social")
def login_social(token: str, db: Session = Depends(get_db)):
    view.login_social(token=token, db=db)