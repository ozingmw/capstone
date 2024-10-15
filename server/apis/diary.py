from datetime import timedelta
from sqlalchemy import extract
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from auth import auth_handler
from schemas.diary_schema import *
from models.diary_model import *
from models.user_model import UserTable
from models.sentiment_model import SentimentTable
from apis.model import run_model


def create_diary(create_diary_input: CreateDiaryInput, db: Session, token: str) -> Diary:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        create_diary_input.daytime = create_diary_input.daytime or date.today()
        
        diary = DiaryTable(
            user_id=user.user_id,
            sentiment_user=create_diary_input.sentiment_user,
            sentiment_model=create_diary_input.sentiment_model,
            diary_content=create_diary_input.diary_content,
            daytime=create_diary_input.daytime
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

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        extract('year', DiaryTable.daytime) == read_monthly_diary_input.date.year,
        extract('month', DiaryTable.daytime) == read_monthly_diary_input.date.month
    ).all()

    return diary


def read_weekly_diary(read_weekly_diary_input: ReadWeeklyDiaryInput, db: Session, token: str) -> Diary:
    decode_token = auth_handler.verify_access_token(token)['id']

    start_of_week = read_weekly_diary_input.date - timedelta(days=read_weekly_diary_input.date.weekday())
    end_of_week = start_of_week + timedelta(days=6)

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime >= start_of_week,
        DiaryTable.daytime <= end_of_week
    ).all()

    return diary


def read_today_diary(read_today_diary_input: ReadTodayDiaryInput, db: Session, token: str) -> Diary:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime == read_today_diary_input.date
    ).all()

    return diary


def update_diary(update_diary_input: UpdateDiaryInput, db: Session, token: str) -> Diary:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime == update_diary_input.date
    ).first()

    if not diary:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
    
    for key, value in update_diary_input.model_dump().items():
        if value:
            setattr(diary, key, value)

    db.add(diary)
    db.commit()
    db.refresh(diary)

    return diary


def analyze_diary(analyze_diary_input: AnalyzeDiaryInput, db: Session, token: str) -> AnalyzeDiaryOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    user = db.query(UserTable).filter(
        UserTable.hashed_token == decode_token,
    ).first()
        
    sentiment_model_int = run_model.generate(analyze_diary_input.diary_content, user.age, user.gender)

    sentiment_model = db.query(SentimentTable).filter(SentimentTable.sentiment_id == sentiment_model_int).first()
    
    return {'sentiment_model': sentiment_model}
