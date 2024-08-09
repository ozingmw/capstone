from typing import Optional
from fastapi import APIRouter, Depends, status, Request
from fastapi.responses import JSONResponse, RedirectResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db

from views import auth_view as view
from schemas.auth_schema import *


router = APIRouter(prefix="/login", tags=["LOGIN"])

@router.get('/auth')
def auth_google():
    auth_url = view.auth_google()
    
    return RedirectResponse(auth_url)

@router.get('/google')
def auth_google_callback(request: Request, code: Optional[str] = None, error: Optional[str] = None, db: Session = Depends(get_db)):
    if code:
        # params = dict(request.query_params)
        view.auth_google_callback(code=code, db=db)
        return JSONResponse(status_code=status.HTTP_200_OK, content={"message": "로그인 성공!"})
    
    elif error:
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"message": "로그인 실패!", "error": error})
