from pydantic import BaseModel
from datetime import date


class BaseSentimentOutput(BaseModel):
    target_date: str
    sentiment_model_counts: dict
    sentiment_user_counts: dict


class ReadWeeklySentimentInput(BaseModel):
    date: date


class ReadMonthlySentimentInput(BaseModel):
    date: date


class ReadHalfyearSentimentInput(BaseModel):
    date: date
