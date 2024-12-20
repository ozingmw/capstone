from datetime import timedelta
from sqlalchemy.orm import Session

from auth import auth_handler
from models.diary_model import *
from models.sentiment_model import *
from schemas.sentiment_schema import *
from models.user_model import UserTable


def read_weekly_sentiment(read_weekly_sentiment_input: ReadWeeklySentimentInput, db: Session, token: str) -> BaseSentimentOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    target_date = read_weekly_sentiment_input.date
    target_date_before = target_date - timedelta(days=7)

    diary_entries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime.between(target_date_before, target_date)
    ).all()

    sentiment_counts = {i: 0 for i in range(1, len(db.query(SentimentTable).all())+1)}

    for diary in diary_entries:
        sentiment = diary.sentiment
        if sentiment in sentiment_counts:
            sentiment_counts[sentiment] += 1
        
    sentiment_dict = {
        1: "기쁨",
        2: "당황",
        3: "분노",
        4: "불안",
        5: "상처",
        6: "슬픔",
    }

    sentiment_counts = {sentiment_dict[key]: value for key, value in sentiment_counts.items()}

    return {
        'target_date': f"{read_weekly_sentiment_input.date.year}/{read_weekly_sentiment_input.date.month}",
        'sentiment_counts': sentiment_counts
    }

def read_monthly_sentiment(read_monthly_sentiment_input: ReadMonthlySentimentInput, db: Session, token: str) -> BaseSentimentOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary_entries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime.between(read_monthly_sentiment_input.date - timedelta(days=30), read_monthly_sentiment_input.date)
    ).all()

    sentiment_counts = {i: 0 for i in range(1, len(db.query(SentimentTable).all())+1)}

    for diary in diary_entries:
        sentiment = diary.sentiment
        if sentiment in sentiment_counts:
            sentiment_counts[sentiment] += 1
        
    sentiment_dict = {
        1: "기쁨",
        2: "당황",
        3: "분노",
        4: "불안",
        5: "상처",
        6: "슬픔",
    }

    sentiment_counts = {sentiment_dict[key]: value for key, value in sentiment_counts.items()}

    return {
        'target_date': f"{read_monthly_sentiment_input.date.year}/{read_monthly_sentiment_input.date.month}",
        'sentiment_counts': sentiment_counts,
    }

def read_halfyear_sentiment(read_halfyear_sentiment_input: ReadHalfyearSentimentInput, db: Session, token: str) -> BaseSentimentOutput:
    decode_token = auth_handler.verify_access_token(token)['id']

    diary_entries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == decode_token,
        DiaryTable.daytime.between(read_halfyear_sentiment_input.date - timedelta(days=180), read_halfyear_sentiment_input.date)
    ).all()

    sentiment_counts = {i: 0 for i in range(1, len(db.query(SentimentTable).all())+1)}

    for diary in diary_entries:
        sentiment = diary.sentiment
        if sentiment in sentiment_counts:
            sentiment_counts[sentiment] += 1
    
    sentiment_dict = {
        1: "기쁨",
        2: "당황",
        3: "분노",
        4: "불안",
        5: "상처",
        6: "슬픔",
    }

    sentiment_counts = {sentiment_dict[key]: value for key, value in sentiment_counts.items()}

    return {
        'target_date': f"{read_halfyear_sentiment_input.date.year}/{read_halfyear_sentiment_input.date.month - 5} ~ {read_halfyear_sentiment_input.date.year}/{read_halfyear_sentiment_input.date.month}",
        'sentiment_counts': sentiment_counts,
    }
