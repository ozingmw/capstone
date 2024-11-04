from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from auth.auth_bearer import JWTBearer
from db.connection import get_db

from apis import user
from schemas.user_schema import *


router = APIRouter(prefix="/user", tags=["USER"])


@router.post("/create")
def create_user(create_user_input: CreateUserInput, db: Session = Depends(get_db)) -> BaseUserOutput:
    res = user.create_user(create_user_input=create_user_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={"res": jsonable_encoder(res)})


@router.get("/read")
def read_user(db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.check_token(db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})


@router.patch("/update/nickname")
def update_user_nickname(update_user_nickname_input: UpdateUserNicknameInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.update_user_nickname(update_user_nickname_input=update_user_nickname_input, db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.patch("/update/photo")
def update_user_photo(update_user_photo_input: UpdateUserPhotoInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.update_user_photo(update_user_photo_input=update_user_photo_input, db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.patch("/update/age")
def update_user_age(update_user_age_input: UpdateUserAgeInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.update_user_age(update_user_age_input=update_user_age_input, db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.patch("/update/gender")
def update_user_gender(update_user_gender_input: UpdateUserGenderInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.update_user_gender(update_user_gender_input=update_user_gender_input, db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.patch("/delete")
def update_user_disabled(db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.update_user_disabled(db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})


@router.patch("/restore")
def update_user_enabled(db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.update_user_enabled(db=db, token=token)

    return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})
