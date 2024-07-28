from sqlalchemy import Column, Integer, String
from pydantic import BaseModel
from db.session import Base


class Question(BaseModel):
    question_id: int
    question_content: str

    class Config:
        orm_mode = True
        use_enum_values = True
    
    def __init__(self, **kwargs):
        if '_sa_instance_state' in kwargs:
            kwargs.pop('_sa_instance_state')
        super().__init__(**kwargs)


class QuestionTable(Base):
    __tablename__ = 'question'

    question_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    question_content = Column(String(255), nullable=False)