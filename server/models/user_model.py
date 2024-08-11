from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


class User(BaseModel):
    user_id: int
    email: str
    hashed_token: str
    nickname: str
    disabled: bool

class UserTable(Base):
    __tablename__ = 'user'

    user_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    email = Column(String(50), nullable=False)
    hashed_token = Column(String(100), nullable=False)
    nickname = Column(String(12), nullable=False)
    disabled = Column(Boolean, nullable=False, default=False)

    diary = relationship('DiaryTable', back_populates='user')