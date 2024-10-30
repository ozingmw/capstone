from pydantic import BaseModel
from typing import Optional

from models.question_model import Question


class ReadQuestionInput(BaseModel):
    question_id: int


class ReadQuestionOutput(BaseModel):
    question: Optional[Question]
