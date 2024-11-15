from fastapi import APIRouter, Depends, UploadFile, status, File
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


@router.post("/upload/photo")
def upload_user_photo(file: UploadFile = File(...), db: Session = Depends(get_db), token: str = Depends(JWTBearer())):
    res = user.upload_user_photo(db=db, token=token, file=file)

    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/download/photo")
def downlad_user_photo(download_user_photo_input: DownloadUserPhotoInput, token: str = Depends(JWTBearer())):
    res = user.download_user_photo(token=token, download_user_photo_input=download_user_photo_input)

    return res


@router.delete("/delete/photo")
def delete_user_photo(db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseUserOutput:
    res = user.delete_user_photo(db=db, token=token)

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
