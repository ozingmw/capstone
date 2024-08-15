from datetime import date, datetime
from sqlalchemy import Column, Integer, String, ForeignKey, DATE
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


"""
| Column Name      | Data Type     | Constraints                                   |
|------------------|---------------|-----------------------------------------------|
| diary_id         | Integer       | Primary Key, Not Null, Autoincrement          |
| user_id          | Integer       | Foreign Key(user.user_id), Not Null           |
| sentiment_user   | Integer       | Foreign Key(sentiment.sentiment_id), Not Null |
| sentiment_model  | Integer       | Foreign Key(sentiment.sentiment_id), Not Null |
| diary_content    | String(255)   | Not Null                                      |
| daytime          | DATE          | Not Null, Default=datetime.now().date         |
| temp_content     | String(255)   | Nullable                                      |
"""


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
    sentiment_user_rel = relationship('SentimentTable', foreign_keys=[sentiment_user], back_populates='diary_user')
    sentiment_model_rel = relationship('SentimentTable', foreign_keys=[sentiment_model], back_populates='diary_model')
