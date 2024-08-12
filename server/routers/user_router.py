from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session
 
from db.connection import get_db

from views import user_view
from schemas.user_schema import *


router = APIRouter(prefix="/user", tags=["USER"])

@router.post("/create")
def create_user_email(create_user_email_input: CreateUserEmailInput, db: Session = Depends(get_db)) -> CreateUserOutput:
    user = user_view.create_user_email(create_user_email_input=create_user_email_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'user': jsonable_encoder(user)})

@router.get("/read")
def read_user(id: int, db: Session = Depends(get_db)) -> ReadUserOutput:
    user = user_view.read_user(id=id, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'user': jsonable_encoder(user)})

# @router.put("/update/nickname")
# def update_user_nickname(update_user_nickname_input: UpdateUserNicknameInput, db: Session = Depends(get_db)) -> UpdateUserNicknameOutput:
#     user = user_view.update_user_nickname(update_user_nickname_input=update_user_nickname_input, db=db)
    
#     return JSONResponse(status_code=status.HTTP_200_OK, content={'user': jsonable_encoder(user)})

@router.delete("/delete")
def delete_user(delete_user_input: DeleteUserInput, db: Session = Depends(get_db)) -> DeleteUserOutput:
    user = user_view.delete_user(delete_user_input=delete_user_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'user': jsonable_encoder(user)})