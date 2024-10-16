from pydantic import BaseModel
from typing import Optional

from models.question_model import Question


class ReadQuestionInput(BaseModel):
    question_id: int


class ReadQuestionOutput(BaseModel):
    question: Optional[Question]


# ------ 사용 X ------


# class CreateQuestionInput(BaseModel):
#     question_content: str


# class CreateQuestionOutput(BaseModel):
#     question: Optional[Question]


# class ReadQuestionOutput(BaseModel):
#     question: Optional[Question]


# class UpdateQuestionInput(BaseModel):
#     question_id: int
#     question_content: str


# class UpdateQuestionOutput(BaseModel):
#     question: Optional[Question]


# class DeleteQuestionInput(BaseModel):
#     question_id: int


# class DeleteQuestionOutput(BaseModel):
#     bool
