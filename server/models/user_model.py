import enum
from datetime import date
from sqlalchemy import Column, Integer, String, Boolean, DATE, Enum
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from db.session import Base


"""
TABLE SCHEMA
| Column Name    | Data Type     | Constraints                          |
|----------------|---------------|--------------------------------------|
| user_id        | Integer       | Primary Key, Not Null, Autoincrement |
| email          | String(50)    | Not Null                             |
| hashed_token   | String(100)   | Not Null                             |
| nickname       | String(12)    | Not Null                             |
| photo_url      | String(100)   | Default=Null                         |
| disabled       | Boolean       | Not Null, Default=False(0)           |
| disabled_at    | Date          | Default=Null                         |

EVENT SCHEDULE
| Event Name      | Description                                         |
|-----------------|-----------------------------------------------------|
| delete_old_user | Delete users with disabled_at older than 2 weeks    |
"""


class GenderEnum(str, enum.Enum):
    M = 'M'
    F = 'F'

class User(BaseModel):
    user_id: int
    email: str
    hashed_token: str
    nickname: str
    photo_url: str
    age: int
    gender: GenderEnum
    disabled: bool
    disabled_at: date

class UserTable(Base):
    __tablename__ = 'user'

    user_id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    email = Column(String(50), nullable=False)
    hashed_token = Column(String(100), nullable=False)
    nickname = Column(String(12), nullable=False)
    age = Column(Integer, default=None)
    gender = Column(Enum(GenderEnum), default=None)
    photo_url = Column(String(100), default=None)
    disabled = Column(Boolean, nullable=False, default=False)
    disabled_at = Column(DATE, default=None)

    diary = relationship('DiaryTable', back_populates='user')