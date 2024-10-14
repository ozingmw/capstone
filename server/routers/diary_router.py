from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from auth.auth_bearer import JWTBearer
from db.connection import get_db

from apis import diary
from schemas.diary_schema import *


router = APIRouter(prefix="/diary", tags=["DIARY"])


@router.post("/create")
def create_diary(create_diary_input: CreateDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.create_diary(create_diary_input=create_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/read/monthly")
def read_monthly_diary(read_monthly_diary_input: ReadMonthlyDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.read_monthly_diary(read_monthly_diary_input=read_monthly_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/read/weekly")
def read_monthly_diary(read_weekly_diary_input: ReadWeeklyDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.read_monthly_diary(read_weekly_diary_input=read_weekly_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/read")
def read_diary(read_diary_input: ReadDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.read_diary(read_diary_input=read_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.put("/update")
def update_diary(update_diary_input: UpdateDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.update_diary(update_diary_input=update_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'r es': jsonable_encoder(res)})


@router.post("/analyze")
def analyze_diary(analyze_diary_input: AnalyzeDiaryInput) -> AnalyzeDiaryOutput:
    res = diary.analyze_diary(analyze_diary_input=analyze_diary_input)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})