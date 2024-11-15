from datetime import date
from pydantic import BaseModel
from typing import Optional

from models.diary_model import Diary


class BaseDiaryOutput(BaseModel):
    diary: Optional[Diary]


class CreateDiaryInput(BaseModel):
    sentiment: str
    diary_content: str
    daytime: Optional[date] = date.today()
    question_content: Optional[str] = None


class ReadMonthlyDiaryInput(BaseModel):
    date: date


class ReadWeeklyDiaryInput(BaseModel):
    date: date


class ReadTodayDiaryInput(BaseModel):
    date: date


class UpdateDiaryInput(BaseModel):
    date: date
    diary_content: Optional[str] = None
    sentiment: Optional[str] = None


class DeleteDiaryInput(BaseModel):
    date: date


class AnalyzeDiaryInput(BaseModel):
    diary_content: str


class AnalyzeDiaryOutput(BaseModel):
    sentiment: str
    used_model: str
    

class PigAlertOutput(BaseModel):
    alert: bool
    diary: Diary
    