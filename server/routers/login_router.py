from typing import Optional
from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse, RedirectResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db

from auth import auth_handler, google
from apis import user
from schemas.user_schema import *
from schemas.login_schema import *


router = APIRouter(prefix="/login", tags=["LOGIN"])


@router.post("/")
def login(login_input: LoginInput, db: Session = Depends(get_db)) -> User:
    hashed_token = auth_handler.verify_access_token(login_input.encoded_token)
    res = user.read_user_token(hashed_token=hashed_token['id'], db=db)

    return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})


@router.post("/register")
async def register(register_input: RegisterInput, db: Session = Depends(get_db)) -> User:
    create_user_input = CreateUserInput(
        email=register_input.email,
        hashed_token=auth_handler.verify_access_token(register_input.encoded_token)['id'],
        nickname=register_input.nickname,
        disabled=False
    )
    res = user.create_user(create_user_input=create_user_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={"res": jsonable_encoder(res)})


@router.get('/auth')
def auth_google():
    auth_url = google.auth()
    return RedirectResponse(auth_url)


@router.get('/google')
def auth_google_callback(code: Optional[str] = None, error: Optional[str] = None, db: Session = Depends(get_db)):
    if code:
        token_data = google.auth_callback(code=code)

        user_exist = user.read_user_email(token_data['email'], db=db)

        jwt_token = auth_handler.create_access_token(token_data)

        return {"access_token": jwt_token, "token_type": "bearer", "user_exist": user_exist}
    
    elif error:
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"message": "로그인 실패!", "error": error})
