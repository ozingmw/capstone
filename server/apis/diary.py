from sqlalchemy import extract
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from auth import auth_handler
from models.diary_model import *
from schemas.diary_schema import *
from models.user_model import UserTable
from apis.model import run_model


def create_diary(create_diary_input: CreateDiaryInput, db: Session, token: str) -> Diary:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()
        
        diary = DiaryTable(
            user_id=user.user_id,
            sentiment_user=create_diary_input.sentiment_user,
            sentiment_model=create_diary_input.sentiment_model,
            diary_content=create_diary_input.diary_content
        )
    
        db.add(diary)
        db.commit()
        db.refresh(diary)

        return diary

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 diary입니다")


def read_monthly_diary(read_monthly_diary_input: ReadMonthlyDiaryInput, db: Session, token: str) -> Diary:
    decode_token = auth_handler.verify_access_token(token)['id']
    user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        extract('year', DiaryTable.daytime) == read_monthly_diary_input.date.year,
        extract('month', DiaryTable.daytime) == read_monthly_diary_input.date.month
    ).all()

    return diary


def read_weekly_diary(read_weekly_diary_input: ReadWeeklyDiaryInput, db: Session, token: str) -> Diary:
    decode_token = auth_handler.verify_access_token(token)['id']
    user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        extract('year', DiaryTable.daytime) == read_weekly_diary_input.date.year,
        extract('month', DiaryTable.daytime) == read_weekly_diary_input.date.month
    ).all()

    return diary


def read_diary(read_diary_input: ReadDiaryInput, db: Session, token: str) -> Diary:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime == read_diary_input.date
    ).all()

    return diary


def update_diary(update_diary_input: UpdateDiaryInput, db: Session) -> Diary:
    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == update_diary_input.token['id'],
        DiaryTable.diary_id == update_diary_input.diary_id
    ).first()

    if not diary:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
    
    for key, value in update_diary_input.model_dump(exclude={'token'}).items():
        setattr(diary, key, value)

    db.add(diary)
    db.commit()
    db.refresh(diary)

    return diary


def analyze_diary(analyze_diary_input: AnalyzeDiaryInput) -> AnalyzeDiaryOutput:
    sentiment_model = run_model.generate(analyze_diary_input.diary_content)
    
    return {'sentiment_model': sentiment_model}