from datetime import date
from pydantic import BaseModel
from typing import Optional

from models.diary_model import Diary


class BasicDiaryOutput(BaseModel):
    diary: Optional[Diary]


class WriteDiaryInput(BaseModel):
    sentiment_user: int
    sentiment_model: int
    diary_content: str
    

class ReadMonthlyDiaryInput(BaseModel):
    date: date


class ReadWeeklyDiaryInput(BaseModel):
    date: date


class ReadDiaryInput(BaseModel):
    date: date


class ModifyDiaryInput(BaseModel):
    diary_id: int
    diary_content: str


class AnalyzeDiaryInput(BaseModel):
    diary_content: str


class AnalyzeDiaryOutput(BaseModel):
    sentiment_model: int
    