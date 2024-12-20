import re
import requests
import json
import random
from datetime import timedelta
from sqlalchemy import extract
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from auth import auth_handler
from schemas.diary_schema import *
from models.question_model import QuestionTable
from models.diary_model import DiaryTable
from models.user_model import UserTable
from models.sentiment_model import SentimentTable
from core.config import Settings

from apis.gpt import Model
from apis.prompt import SENTIMENT_SYSTEM_PROMPT


settings = Settings()

def create_diary(create_diary_input: CreateDiaryInput, db: Session, token: str) -> BaseDiaryOutput:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']

        if db.query(DiaryTable).join(UserTable).filter(
            UserTable.hashed_token == decode_token,
            DiaryTable.daytime == create_diary_input.daytime
        ).first():
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 diary입니다")

        sentiment = db.query(SentimentTable).filter(SentimentTable.sentiment_content == create_diary_input.sentiment).first()

        if create_diary_input.question_content:
            question = db.query(QuestionTable).filter(QuestionTable.question_content == create_diary_input.question_content).first()

        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()
        
        diary = DiaryTable(
            user_id=user.user_id,
            sentiment=sentiment.sentiment_id,
            diary_content=create_diary_input.diary_content,
            daytime=create_diary_input.daytime,
            question_id=question.question_id if create_diary_input.question_content else None
        )
    
        db.add(diary)
        db.commit()
        db.refresh(diary)

        return diary

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 diary입니다")


def read_monthly_diary(read_monthly_diary_input: ReadMonthlyDiaryInput, db: Session, token: str) -> BaseDiaryOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    year = read_monthly_diary_input.date.year
    month = read_monthly_diary_input.date.month

    diaries = (
        db.query(DiaryTable)
        .join(UserTable)
        .filter(
            UserTable.hashed_token == decode_token,
            extract('year', DiaryTable.daytime) == year,
            extract('month', DiaryTable.daytime) == month
        )
        .all()
    )

    for diary in diaries:
        setattr(diary, 'sentiment', diary.sentiment_rel.sentiment_content)

        delattr(diary, 'sentiment_rel')

    return diaries


def read_weekly_diary(read_weekly_diary_input: ReadWeeklyDiaryInput, db: Session, token: str) -> BaseDiaryOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    start_of_week = read_weekly_diary_input.date - timedelta(days=read_weekly_diary_input.date.weekday())
    end_of_week = start_of_week + timedelta(days=6)

    diaries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime >= start_of_week,
        DiaryTable.daytime <= end_of_week
    ).all()

    for diary in diaries:
        setattr(diary, 'sentiment', diary.sentiment_rel.sentiment_content)

        delattr(diary, 'sentiment_rel')

    return diaries


def read_today_diary(read_today_diary_input: ReadTodayDiaryInput, db: Session, token: str) -> BaseDiaryOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime == read_today_diary_input.date
    ).first()

    if diary:
        setattr(diary, 'sentiment', diary.sentiment_rel.sentiment_content)
        delattr(diary, 'sentiment_rel')

        if diary.question_id:
            setattr(diary, 'question_content', diary.question_rel.question_content)
            delattr(diary, 'question_rel')

    return diary


def update_diary(update_diary_input: UpdateDiaryInput, db: Session, token: str) -> BaseDiaryOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    if update_diary_input.sentiment:
        sentiment = db.query(SentimentTable).filter(SentimentTable.sentiment_content == update_diary_input.sentiment).first()

    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime == update_diary_input.date
    ).first()

    if not diary:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
    
    for key, value in update_diary_input.model_dump().items():
        if key == 'date':
            continue
        if value:
            setattr(diary, key, value)
            if key == 'sentiment':
                setattr(diary, key, sentiment.sentiment_id)

    db.add(diary)
    db.commit()
    db.refresh(diary)

    sentiment = db.query(SentimentTable).filter(SentimentTable.sentiment_id == diary.sentiment).first()

    diary.sentiment = sentiment.sentiment_content

    return diary


def delete_diary(delete_diary_input: DeleteDiaryInput, db: Session, token: str):
    try:
        decode_token = auth_handler.verify_access_token(token)['id']

        diary = db.query(DiaryTable).join(UserTable).filter(
            UserTable.hashed_token == decode_token,
            DiaryTable.daytime == delete_diary_input.date
        ).first()

        if not diary:
            raise HTTPException(status_code=404, detail="Diary entry not found")

        # 다이어리 삭제
        db.delete(diary)
        db.commit()  

        return {"result": True}
    except:
        return {"result": False}


def analyze_diary(analyze_diary_input: AnalyzeDiaryInput, db: Session, token: str) -> AnalyzeDiaryOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    user = db.query(UserTable).filter(
        UserTable.hashed_token == decode_token,
    ).first()
    
    body = {
        "diary_content": analyze_diary_input.diary_content,
        "age": user.age,
        "gender": user.gender
    }

    try:
        response = requests.post(f"{settings.MODEL_HOST}/predict", data=json.dumps(body)).json()
        used_model = 'local'
    except:
        model = Model()

        system_msg = SENTIMENT_SYSTEM_PROMPT.format(age=user.age, gender=user.gender, sentence=analyze_diary_input.diary_content)
        response = model.generate_single(system_msg, "")

        try:
            response = re.search(r'<emotion>(.*?)</emotion>', response).group(1)
        except:
            response = 'error'

        used_model = 'gpt'

    return {'sentiment': response, 'used_model': used_model}


def pig_alert(db: Session, token: str) -> PigAlertOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    diaries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token
    ).all()

    alert = False
    unhappy_diaries = []
    happy_diaries = []

    for diary in diaries:
        if diary.sentiment != 1:
            unhappy_diaries.append(diary)
        else:
            happy_diaries.append(diary)

    if len(diaries) == 0 or len(happy_diaries) <= 3:
        return {"alert": alert, "diary": {}}

    if len(unhappy_diaries) / len(diaries) >= 0.5:
        alert = True
        happy_diary = happy_diaries[random.randint(0, len(happy_diaries)-1)]

        return {"alert": alert, "diary": happy_diary}
    
    return {"alert": alert, "diary": {}}
