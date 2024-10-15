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
def read_weekly_diary(read_weekly_diary_input: ReadWeeklyDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.read_weekly_diary(read_weekly_diary_input=read_weekly_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/read/today")
def read_today_diary(read_today_diary_input: ReadTodayDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.read_today_diary(read_today_diary_input=read_today_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.patch("/update")
def update_diary(update_diary_input: UpdateDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.update_diary(update_diary_input=update_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/analyze")
def analyze_diary(analyze_diary_input: AnalyzeDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> AnalyzeDiaryOutput:
    res = diary.analyze_diary(analyze_diary_input=analyze_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})
