from sqlalchemy import Column, Integer, Enum, String
from sqlalchemy.orm import relationship
from pydantic import BaseModel
import enum
from db.session import Base


class SexEnum(str, enum.Enum):
    M = 'M'
    F = 'F'

class User(BaseModel):
    user_id: int
    nickname: str
    sex: SexEnum
    age: int

    class Config:
        orm_mode = True
        use_enum_values = True
    
    def __init__(self, **kwargs):
        if '_sa_instance_state' in kwargs:
            kwargs.pop('_sa_instance_state')
        super().__init__(**kwargs)


class UserTable(Base):
    __tablename__ = 'user'

    user_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    nickname = Column(String(12), nullable=False)
    sex = Column(Enum(SexEnum), nullable=False)
    age = Column(Integer, nullable=False)

    diary = relationship('DiaryTable', back_populates='user')