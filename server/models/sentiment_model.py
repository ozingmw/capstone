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

| 1. 기쁨 | 2. 당황 | 3. 분노 | 4. 불안 | 5. 상처 | 6. 슬픔 |
"""


class Sentiment(BaseModel):
    sentiment_id: int
    sentiment_content: str


class SentimentTable(Base):
    __tablename__ = 'sentiment'

    sentiment_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    sentiment_content = Column(String(8), nullable=False)

    diary_rel = relationship('DiaryTable', back_populates='sentiment_rel')
    quote_rel = relationship('QuoteTable', back_populates='sentiment_rel')
    