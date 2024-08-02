from datetime import date, datetime
from sqlalchemy import Column, Integer, String, ForeignKey, DATE
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


class Diary(BaseModel):
    diary_id: int
    user_id: int
    sentiment_user: int
    sentiment_model: int
    diary_content: str
    daytime: date
    temp_content: str

class DiaryTable(Base):
    __tablename__ = 'diary'

    diary_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.user_id'), nullable=False)
    sentiment_user = Column(Integer, ForeignKey('sentiment.sentiment_id'), nullable=False)
    sentiment_model = Column(Integer, ForeignKey('sentiment.sentiment_id'), nullable=False)
    diary_content = Column(String(255), nullable=False)
    daytime = Column(DATE, nullable=False, default=datetime.now().date)
    temp_content = Column(String(255), nullable=True)

    user = relationship('UserTable', back_populates='diary')
    sentiment = relationship('SentimentTable', back_populates='diary')