from sqlalchemy import Column, Integer, String
from pydantic import BaseModel
from db.session import Base


class Sentiment(BaseModel):
    sentiment_id: int
    sentiment_content: str

    class Config:
        orm_mode = True
        use_enum_values = True
    
    def __init__(self, **kwargs):
        if '_sa_instance_state' in kwargs:
            kwargs.pop('_sa_instance_state')
        super().__init__(**kwargs)


class SentimentTable(Base):
    __tablename__ = 'sentiment'

    sentiment_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    sentiment_content = Column(String(8), nullable=False)