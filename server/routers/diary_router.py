from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db

from apis import diary
from schemas.diary_schema import *

from auth.auth_bearer import JWTBearer


router = APIRouter(prefix="/diary", tags=["DIARY"])

@router.post("/", dependencies=[Depends(JWTBearer())])
async def create_diary(create_diary_input: CreateDiaryInput, db: Session = Depends(get_db)) -> CreateDiaryOutput:
    res = diary.create_diary(create_diary_input=create_diary_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'res': jsonable_encoder(res)})
    
@router.get("/")
def read_diary(db: Session = Depends(get_db)) -> ReadDiaryOutput:
    res = diary.read_diary(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.put("/")
def update_diary(update_diary_input: UpdateDiaryInput, db: Session = Depends(get_db)) -> UpdateDiaryOutput:
    res = diary.update_diary(update_diary_input=update_diary_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.delete("/")
def delete_diary(delete_diary_input: DeleteDiaryInput, db: Session = Depends(get_db)) -> DeleteDiaryOutput:
    res = diary.delete_diary(delete_diary_input=delete_diary_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})