from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db
from auth.auth_bearer import JWTBearer

from apis import user
from schemas.user_schema import *



router = APIRouter(prefix="/user", tags=["USER"])


@router.post("/create")
def create_user(create_user_input: CreateUserInput, db: Session = Depends(get_db)) -> CreateUserOutput:
    res = user.create_user(create_user_input=create_user_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={"res": jsonable_encoder(res)})


@router.put("/update/nickname", dependencies=[Depends(JWTBearer())])
def update_user_nickname(update_user_nickname_input: UpdateUserNicknameInput, db: Session = Depends(get_db)) -> UpdateUserNicknameOutput:
    res = user.update_user_nickname(update_user_nickname_input=update_user_nickname_input, db=db)

    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


# ------ 사용 X ------


# @router.get("/read")
# def read_user(id: int, db: Session = Depends(get_db)) -> ReadUserOutput:
#     res = user.read_user(id=id, db=db)

#     return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})


# @router.delete("/delete")
# def delete_user(delete_user_input: DeleteUserInput, db: Session = Depends(get_db)) -> DeleteUserOutput:
#     res = user.delete_user(delete_user_input=delete_user_input, db=db)

#     return JSONResponse(status_code=status.HTTP_200_OK, content={"res": jsonable_encoder(res)})
