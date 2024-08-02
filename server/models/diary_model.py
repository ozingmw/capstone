from datetime import datetime
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


class Diary(BaseModel):
    diary_id: int
    user_id: int
    sentiment_user: int
    sentiment_model: int
    diary_content: str
    daytime: datetime
    temp_content: str

    class Config:
        orm_mode = True
        use_enum_values = True
    
    def __init__(self, **kwargs):
        if '_sa_instance_state' in kwargs:
            kwargs.pop('_sa_instance_state')
        super().__init__(**kwargs)


class DiaryTable(Base):
    __tablename__ = 'diary'

    diary_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.user_id'), nullable=False)
    sentiment_user = Column(Integer, ForeignKey('sentiment.sentiment_id'), nullable=False)
    sentiment_model = Column(Integer, ForeignKey('sentiment.sentiment_id'), nullable=False)
    diary_content = Column(String(255), nullable=False)
    daytime = Column(DateTime, nullable=False, default=datetime.now())
    temp_content = Column(String(255), nullable=False)

    user = relationship('UserTable', back_populates='diary')
    sentiment = relationship('SentimentTable', back_populates='diary')