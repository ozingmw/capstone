from pydantic import BaseModel
from typing import Literal, Optional

from models.diary_model import Diary


class CreateDiaryInput(BaseModel):
    diary_content: str

class CreateDiaryOutput(BaseModel):
    diary: Optional[Diary]
    
class ReadDiaryOutput(BaseModel):
    diary: Optional[Diary]

class UpdateDiaryInput(BaseModel):
    diary_id: int
    diary_content: str

class UpdateDiaryOutput(BaseModel):
    diary: Optional[Diary]

class DeleteDiaryInput(BaseModel):
    diary_id: int

class DeleteDiaryOutput(BaseModel):
    bool