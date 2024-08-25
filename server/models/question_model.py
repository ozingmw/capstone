from sqlalchemy import Column, Integer, String
from pydantic import BaseModel
from db.session import Base


"""
| Column Name       | Data Type     | Constraints                          |
|-------------------|---------------|--------------------------------------|
| question_id       | Integer       | Primary Key, Not Null, Autoincrement |
| question_content  | String(255)   | Not Null                             |
"""


class Question(BaseModel):
    question_id: int
    question_content: str


class QuestionTable(Base):
    __tablename__ = 'question'

    question_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    question_content = Column(String(255), nullable=False)
    