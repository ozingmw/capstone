from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base

from models.diary_model import DiaryTable


"""
| Column Name        | Data Type     | Constraints                          |
|--------------------|---------------|--------------------------------------|
| sentiment_id       | Integer       | Primary Key, Not Null, Autoincrement |
| sentiment_content  | String(8)     | Not Null                             |
"""


class Sentiment(BaseModel):
    sentiment_id: int
    sentiment_content: str

class SentimentTable(Base):
    __tablename__ = 'sentiment'

    sentiment_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    sentiment_content = Column(String(8), nullable=False)

    diary_user = relationship('DiaryTable', foreign_keys=[DiaryTable.sentiment_user], back_populates='sentiment_user_rel')
    diary_model = relationship('DiaryTable', foreign_keys=[DiaryTable.sentiment_model], back_populates='sentiment_model_rel')
    quote = relationship('QuoteTable', back_populates='sentiment')