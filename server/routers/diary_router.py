from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from auth.auth_bearer import JWTBearer
from db.connection import get_db

from apis import diary
from schemas.diary_schema import *


router = APIRouter(prefix="/diary", tags=["DIARY"])


@router.post("/write")
def write_diary(write_diary_input: WriteDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.write_diary(write_diary_input=write_diary_input, db=db, token=token)
    
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


@router.put("/modify")
def modify_diary(modify_diary_input: ModifyDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BasicDiaryOutput:
    res = diary.modify_diary(modify_diary_input=modify_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'r es': jsonable_encoder(res)})


@router.post("/analyze")
def analyze_diary(analyze_diary_input: AnalyzeDiaryInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> AnalyzeDiaryOutput:
    res = diary.analyze_diary(analyze_diary_input=analyze_diary_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})