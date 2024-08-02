from sqlalchemy import Column, Integer, String
from pydantic import BaseModel
from db.session import Base


class Question(BaseModel):
    question_id: int
    question_content: str

class QuestionTable(Base):
    __tablename__ = 'question'

    question_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    question_content = Column(String(255), nullable=False)