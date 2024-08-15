from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


"""
| Column Name    | Data Type     | Constraints                                   |
|----------------|---------------|-----------------------------------------------|
| quote_id       | Integer       | Primary Key, Not Null, Autoincrement          |
| sentiment_id   | Integer       | Foreign Key(sentiment.sentiment_id), Not Null |
| quote_content  | String(255)   | Not Null                                      |
"""


class Quote(BaseModel):
    quote_id: int
    sentiment_id: int
    quote_content: str

class QuoteTable(Base):
    __tablename__ = 'quote'

    quote_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    sentiment_id = Column(Integer, ForeignKey('sentiment.sentiment_id'), nullable=False)
    quote_content = Column(String(255), nullable=False)

    sentiment = relationship('SentimentTable', back_populates='quote')