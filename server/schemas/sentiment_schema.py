from pydantic import BaseModel
from datetime import date


class ReadMonthlySentimentInput(BaseModel):
    date: date


class ReadHalfyearSentimentInput(BaseModel):
    date: date
