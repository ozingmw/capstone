from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db

from views import diary_view as view
from schemas.diary_schema import *


router = APIRouter(prefix="/diary", tags=["DIARY"])

@router.post("/")
async def create_diary(create_diary_input: CreateDiaryInput, db: Session = Depends(get_db)) -> CreateDiaryOutput:
    diary = view.create_diary(create_diary_input=create_diary_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'diary': jsonable_encoder(diary)})
    
@router.get("/")
def read_diary(db: Session = Depends(get_db)) -> ReadDiaryOutput:
    diary = view.read_diary(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'diary': jsonable_encoder(diary)})

@router.put("/")
def update_diary(update_diary_input: UpdateDiaryInput, db: Session = Depends(get_db)) -> UpdateDiaryOutput:
    diary = view.update_diary(update_diary_input=update_diary_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'diary': jsonable_encoder(diary)})

@router.delete("/")
def delete_diary(delete_diary_input: DeleteDiaryInput, db: Session = Depends(get_db)) -> DeleteDiaryOutput:
    diary = view.delete_diary(delete_diary_input=delete_diary_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'diary': jsonable_encoder(diary)})