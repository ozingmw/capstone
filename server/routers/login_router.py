import requests
from PIL import Image
from io import BytesIO

from fastapi import APIRouter, Depends, status
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from google.oauth2 import id_token
from google.auth.transport import requests as GoogleRequests

from auth.auth_bearer import JWTBearer
from core.config import Settings
from db.connection import get_db

from auth import auth_handler
from apis import user
from schemas.user_schema import *
from schemas.login_schema import *


router = APIRouter(prefix="/login", tags=["LOGIN"])
settings = Settings()


@router.post('/google')
async def google_login(login_input: LoginInput, db: Session = Depends(get_db)):
    try:
        client_id = settings.ANDROID_GOOGLE_CLIENT_ID if login_input.os == 'android' else settings.IOS_GOOGLE_CLIENT_ID
        user_token_data = id_token.verify_oauth2_token(login_input.token, GoogleRequests.Request(), client_id)

        if user_token_data['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise ValueError('Wrong issuer.')
        
        user_data = user.read_user_email(user_token_data['email'], db=db)

        access_token, refresh_token = auth_handler.create_token(user_token_data)

        if not user_data:
            create_user_input = CreateUserInput(
                email=user_token_data['email'],
                hashed_token=user_token_data['sub'],
                nickname=''
            )
            user_data = user.create_user(create_user_input=create_user_input, db=db)
            is_nickname = False

            if user_token_data['picture']:
                response = requests.get(user_token_data['picture'])

                if response.status_code == 200:
                    image_data = BytesIO(response.content)
                    image = Image.open(image_data)
                    file_path = f"./data/img/{user_data.user_id}.jpg"
                    image.save(file_path)

                    user_data.photo_url = file_path

                    db.add(user_data)
                    db.commit()
                    db.refresh(user_data)
        else:
            is_nickname = True if user_data.nickname else False

        return JSONResponse(
            status_code=status.HTTP_200_OK,
            content={
                "access_token": access_token,
                "refresh_token": refresh_token,
                "user_exist": True if user_data else False,
                "is_nickname": is_nickname,
                "user_data": jsonable_encoder(user_data)
            })
    
    except ValueError as e:
        print(e)
        return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"error": e})
    

@router.post('/guest')
def guest_login(db: Session = Depends(get_db)):
    guest_sub = auth_handler.create_guest_sub()

    access_token, refresh_token = auth_handler.create_token({"sub": guest_sub})

    create_user_input = CreateUserInput(
        email=f'guest_{guest_sub}@guest.guest',
        hashed_token=guest_sub,
        nickname=''
    )
    user_data = user.create_user(create_user_input=create_user_input, db=db)
    is_nickname = False
    
    return JSONResponse(
        status_code=status.HTTP_200_OK,
        content={
            "access_token": access_token,
            "refresh_token": refresh_token,
            "user_exist": False,
            "is_nickname": is_nickname,
            'user_data': jsonable_encoder(user_data)
        })


@router.post("/sync/user")
def sync_guest_to_user(sync_user_input: SyncUserInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())):
    res = user.sync_guest_to_user(sync_user_input=sync_user_input, db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})


@router.get("/check/user")
def check_user(db: Session = Depends(get_db), token: str = Depends(JWTBearer())):
    res = user.check_token(token=token, db=db)

    if res:
        if user.check_nickname(token=token, db=db):
            return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})

    return JSONResponse(status_code=status.HTTP_404_NOT_FOUND, content={"res": jsonable_encoder(res)})


@router.get("/refresh/token")
def refresh_token(db: Session = Depends(get_db), token: str = Depends(JWTBearer())):
    data = auth_handler.verify_access_token(token)
    token_sub = data['id']
    
    access_token, refresh_token = auth_handler.create_token({"sub": token_sub})

    user.update_user_token(refresh_token=refresh_token, db=db)

    return JSONResponse(status_code=status.HTTP_200_OK, content={"access_token": access_token, "refresh_token": refresh_token})
