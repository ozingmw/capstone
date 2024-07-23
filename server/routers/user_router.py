from fastapi import APIRouter, Depends
from fastapi import HTTPException, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session
from db.connection import get_db

from views import user_view as view

from schemas.user_schema import *


router = APIRouter(prefix="/user", tags=["USER"])

@router.post("/")
async def create_user(create_user_input: CreateUserInput, db: Session = Depends(get_db)) -> CreateUserOutput:
    user = view.create_user(create_user_input=create_user_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'user': jsonable_encoder(user)})
    
@router.get("/")
def read_user(db: Session = Depends(get_db)) -> ReadUserOutput:
    user = view.read_user(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'user': jsonable_encoder(user)})
    
# @router.get("/{user_id}")
# def read_user_by_user_id(user_id: int, db: Session = Depends(get_db)) -> ReadUserOutput:
#     user = view.read_user_by_user_id(user_id=user_id, db=db)
    
#     return JSONResponse(status_code=status.HTTP_200_OK, content={'user': jsonable_encoder(user)})

@router.put("/")
def update_user(update_user_input: UpdateUserInput, db: Session = Depends(get_db)) -> UpdateUserOutput:
    user = view.update_user(update_user_input=update_user_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'user': jsonable_encoder(user)})

@router.delete("/")
def delete_user(delete_user_input: DeleteUserInput, db: Session = Depends(get_db)) -> DeleteUserOutput:
    user = view.delete_user(delete_user_input=delete_user_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'user': jsonable_encoder(user)})