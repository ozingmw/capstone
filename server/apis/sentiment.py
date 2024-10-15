from sqlalchemy import extract
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from auth import auth_handler
from models.diary_model import *
from models.sentiment_model import *
from schemas.sentiment_schema import *
from models.user_model import UserTable


def read_monthly_sentiment(read_monthly_sentiment_input: ReadMonthlySentimentInput, db: Session, token: str) -> Sentiment:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary_entries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        extract('year', DiaryTable.daytime) == read_monthly_sentiment_input.date.year,
        extract('month', DiaryTable.daytime) == read_monthly_sentiment_input.date.month
    ).all()

    sentiment_model_counts = {i: 0 for i in range(1, len(db.query(SentimentTable).all())+1)}
    sentiment_user_counts = {i: 0 for i in range(1, len(db.query(SentimentTable).all())+1)}

    for diary in diary_entries:
        sentiment_model = diary.sentiment_model
        sentiment_user = diary.sentiment_user
        if sentiment_model in sentiment_model_counts:
            sentiment_model_counts[sentiment_model] += 1
        if sentiment_user in sentiment_user_counts:
            sentiment_user_counts[sentiment_user] += 1

    return {
        'target_date': f"{read_monthly_sentiment_input.date.year}/{read_monthly_sentiment_input.date.month}",
        'sentiment_model_counts': sentiment_model_counts,
        'sentiment_user_counts': sentiment_user_counts
    }

def read_halfyear_sentiment(read_halfyear_sentiment_input: ReadHalfyearSentimentInput, db: Session, token: str) -> Sentiment:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary_entries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        extract('year', DiaryTable.daytime) == read_halfyear_sentiment_input.date.year,
        extract('month', DiaryTable.daytime) <= read_halfyear_sentiment_input.date.month,
        extract('month', DiaryTable.daytime) > read_halfyear_sentiment_input.date.month - 6
    ).all()

    sentiment_model_counts = {i: 0 for i in range(1, len(db.query(SentimentTable).all())+1)}
    sentiment_user_counts = {i: 0 for i in range(1, len(db.query(SentimentTable).all())+1)}

    for diary in diary_entries:
        sentiment_model = diary.sentiment_model
        sentiment_user = diary.sentiment_user
        if sentiment_model in sentiment_model_counts:
            sentiment_model_counts[sentiment_model] += 1
        if sentiment_user in sentiment_user_counts:
            sentiment_user_counts[sentiment_user] += 1

    return {
        'target_date': f"{read_halfyear_sentiment_input.date.year}/{read_halfyear_sentiment_input.date.month - 6} ~ {read_halfyear_sentiment_input.date.year}/{read_halfyear_sentiment_input.date.month}",
        'sentiment_model_counts': sentiment_model_counts,
        'sentiment_user_counts': sentiment_user_counts
    }
