from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db
from auth.auth_bearer import JWTBearer

from apis import diary
from schemas.diary_schema import *
from auth import auth_handler


router = APIRouter(prefix="/diary", tags=["DIARY"])


@router.post("/read/monthly", dependencies=[Depends(JWTBearer())])
def read_monthly_diary(read_monthly_diary_input: ReadMonthlyDiaryInput, db: Session = Depends(get_db)) -> ReadMonthlyDiaryOutput:
    read_monthly_diary_input.token = auth_handler.verify_access_token(read_monthly_diary_input.token)
    res = diary.read_monthly_diary(read_monthly_diary_input=read_monthly_diary_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/read", dependencies=[Depends(JWTBearer())])
def read_diary(read_diary_input: ReadDiaryInput, db: Session = Depends(get_db)) -> ReadDiaryOutput:
    read_diary_input.token = auth_handler.verify_access_token(read_diary_input.token)
    res = diary.read_diary(read_diary_input=read_diary_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.put("/modify", dependencies=[Depends(JWTBearer())])
def modify_diary(modify_diary_input: ModifyDiaryInput, db: Session = Depends(get_db)) -> ModifyDiaryOutput:
    modify_diary_input.token = auth_handler.verify_access_token(modify_diary_input.token)
    res = diary.modify_diary(modify_diary_input=modify_diary_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


# ------ 사용 X ------


# @router.post("/", dependencies=[Depends(JWTBearer())])
# def create_diary(create_diary_input: CreateDiaryInput, db: Session = Depends(get_db)) -> CreateDiaryOutput:
#     res = diary.create_diary(create_diary_input=create_diary_input, db=db)

#     return JSONResponse(status_code=status.HTTP_201_CREATED, content={'res': jsonable_encoder(res)})


# @router.get("/")
# def read_diary(db: Session = Depends(get_db)) -> ReadDiaryOutput:
#     res = diary.read_diary(db=db)
    
#     return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


# @router.put("/")
# def update_diary(update_diary_input: UpdateDiaryInput, db: Session = Depends(get_db)) -> UpdateDiaryOutput:
#     res = diary.update_diary(update_diary_input=update_diary_input, db=db)
    
#     return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


# @router.delete("/")
# def delete_diary(delete_diary_input: DeleteDiaryInput, db: Session = Depends(get_db)) -> DeleteDiaryOutput:
#     res = diary.delete_diary(delete_diary_input=delete_diary_input, db=db)
    
#     return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})
