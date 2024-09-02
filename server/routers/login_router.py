from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session
from google.oauth2 import id_token
from google.auth.transport import requests

from core.config import Settings
from db.connection import get_db

from auth import auth_handler
from apis import user
from schemas.user_schema import *
from schemas.login_schema import *


router = APIRouter(prefix="/login", tags=["LOGIN"])
settings = Settings()


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


@router.post('/google')
async def google_auth_test(request: LoginInput, db: Session = Depends(get_db)):
    try:
        user_data = id_token.verify_oauth2_token(request.token, requests.Request(), settings.IOS_GOOGLE_CLIENT_ID)

        if user_data['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise ValueError('Wrong issuer.')
        
        user_exist = user.read_user_email(user_data['email'], db=db)
        jwt_token = auth_handler.create_access_token(user_data)

        return JSONResponse(status_code=status.HTTP_200_OK, content={"access_token": jwt_token, "user_exist": user_exist})
    
    except ValueError as e:
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"error": e})
    