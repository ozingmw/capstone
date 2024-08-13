from typing import Optional
from fastapi import APIRouter, Depends, status, Request
from fastapi.responses import JSONResponse, RedirectResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db

from auth import auth_handler, google
from views import user_view
from schemas.user_schema import *


router = APIRouter(prefix="/login", tags=["LOGIN"])

@router.get('/auth')
def auth_google():
    auth_url = google.auth_google()
    return RedirectResponse(auth_url)

@router.get('/google')
def auth_google_callback(code: Optional[str] = None, error: Optional[str] = None, db: Session = Depends(get_db)):
    if code:
        token_data = google.auth_google_callback(code=code, db=db)

        if not user_view.read_user_email(token_data['email'], db=db):
            user_view.create_user_email(token_data['email'], db=db)
        
        user_view.update_user_token(
            UpdateUserTokenInput(
                email=token_data['email'],
                hashed_token=token_data['sub'],
            ), db=db
        )
        jwt_token = auth_handler.create_access_token(token_data)
        return {"access_token": jwt_token, "token_type": "bearer"}
    
    elif error:
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"message": "로그인 실패!", "error": error})
