from datetime import date
from pydantic import BaseModel
from typing import Optional

from models.diary_model import Diary


class BasicDiaryOutput(BaseModel):
    diary: Optional[Diary]


class CreateDiaryInput(BaseModel):
    sentiment_user: int
    sentiment_model: int
    diary_content: str
    daytime: Optional[date] = None


class ReadMonthlyDiaryInput(BaseModel):
    date: date


class ReadWeeklyDiaryInput(BaseModel):
    date: date


class ReadTodayDiaryInput(BaseModel):
    date: date


class UpdateDiaryInput(BaseModel):
    date: date
    diary_content: Optional[str] = None
    sentiment_model: Optional[int] = None
    sentiment_user: Optional[int] = None


class UpdateDiaryContentInput(BaseModel):
    date: date
    diary_content: str


class AnalyzeDiaryInput(BaseModel):
    diary_content: str


class AnalyzeDiaryOutput(BaseModel):
    sentiment_model: str
    