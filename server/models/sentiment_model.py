from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


class Sentiment(BaseModel):
    sentiment_id: int
    sentiment_content: str

class SentimentTable(Base):
    __tablename__ = 'sentiment'

    sentiment_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    sentiment_content = Column(String(8), nullable=False)

    diary = relationship('DiaryTable', back_populates='sentiment')
    quote = relationship('QuoteTable', back_populates='sentiment')