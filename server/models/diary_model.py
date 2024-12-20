from datetime import date, datetime
from sqlalchemy import Column, Integer, String, ForeignKey, DATE, Boolean
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


"""
| Column Name      | Data Type     | Constraints                                   |
|------------------|---------------|-----------------------------------------------|
| diary_id         | Integer       | Primary Key, Not Null, Autoincrement          |
| user_id          | Integer       | Foreign Key(user.user_id), Not Null           |
| sentiment        | Integer       | Foreign Key(sentiment.sentiment_id), Null     |
| diary_content    | String(255)   | Not Null                                      |
| daytime          | DATE          | Not Null, Default=datetime.now().date         |
| question_id      | Integer       | Foreign Key(question.question_id), Null       |
"""


class Diary(BaseModel):
    diary_id: int
    user_id: int
    sentiment: int
    diary_content: str
    daytime: date
    question_id: int

class DiaryTable(Base):
    __tablename__ = 'diary'

    diary_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.user_id'), nullable=False)
    sentiment = Column(Integer, ForeignKey('sentiment.sentiment_id'), default=None)
    diary_content = Column(String(255), nullable=False)
    daytime = Column(DATE, nullable=False, default=datetime.now().date)
    question_id = Column(Integer, ForeignKey('question.question_id'), default=None)

    user_rel = relationship('UserTable', back_populates='diary_rel')
    sentiment_rel = relationship('SentimentTable', back_populates='diary_rel')
    question_rel = relationship('QuestionTable', back_populates='diary_rel')