from datetime import date
from pydantic import BaseModel
from typing import Optional

from models.diary_model import Diary


class BasicDiaryOutput(BaseModel):
    diary: Optional[Diary]


class CreateDiaryInput(BaseModel):
    sentiment_user: str
    sentiment_model: str
    diary_content: str
    daytime: Optional[date] = date.today()


class ReadMonthlyDiaryInput(BaseModel):
    date: date


class ReadWeeklyDiaryInput(BaseModel):
    date: date


class ReadTodayDiaryInput(BaseModel):
    date: date


class UpdateDiaryInput(BaseModel):
    date: date
    diary_content: Optional[str] = None
    sentiment_model: Optional[str] = None
    sentiment_user: Optional[str] = None


class AnalyzeDiaryInput(BaseModel):
    diary_content: str


class AnalyzeDiaryOutput(BaseModel):
    sentiment_model: str
    