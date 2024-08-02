from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


class Quote(BaseModel):
    quote_id: int
    sentiment_id: int
    quote_content: str

    class Config:
        orm_mode = True
        use_enum_values = True
    
    def __init__(self, **kwargs):
        if '_sa_instance_state' in kwargs:
            kwargs.pop('_sa_instance_state')
        super().__init__(**kwargs)


class QuoteTable(Base):
    __tablename__ = 'quote'

    quote_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    sentiment_id = Column(Integer, ForeignKey('sentiment.sentiment_id'), nullable=False)
    quote_content = Column(String(255), nullable=False)

    sentiment = relationship('SentimentTable', back_populates='quote')