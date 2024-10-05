from datetime import date
from pydantic import BaseModel
from typing import Optional

from models.diary_model import Diary


class WriteDiaryInput(BaseModel):
    sentiment_user: int
    sentiment_model: int
    diary_content: str


class WriteDiaryOutput(BaseModel):
    diary: Optional[Diary]
    

class ReadMonthlyDiaryInput(BaseModel):
    token: str
    date: date


class ReadMonthlyDiaryOutput(BaseModel):
    diary: Optional[Diary]


class ReadDiaryInput(BaseModel):
    token: str
    date: date


class ReadDiaryOutput(BaseModel):
    diary: Optional[Diary]


class ModifyDiaryInput(BaseModel):
    token: str
    diary_id: int
    diary_content: str


class ModifyDiaryOutput(BaseModel):
    diary: Optional[Diary]


# ------ 사용 X ------


# class CreateDiaryInput(BaseModel):
#     diary_content: str


# class CreateDiaryOutput(BaseModel):
#     diary: Optional[Diary]


# class ReadDiaryOutput(BaseModel):
#     diary: Optional[Diary]


# class UpdateDiaryInput(BaseModel):
#     diary_id: int
#     diary_content: str


# class UpdateDiaryOutput(BaseModel):
#     diary: Optional[Diary]


# class DeleteDiaryInput(BaseModel):
#     diary_id: int


# class DeleteDiaryOutput(BaseModel):
#     bool
