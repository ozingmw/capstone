from pydantic import BaseModel
from typing import Literal, Optional

from models.user_model import User


class CreateUserInput(BaseModel):
    nickname: str
    sex: Literal['M', 'F']
    age: int

class CreateUserOutput(BaseModel):
    user: Optional[User]

class ReadUserInput(BaseModel):
    user_id: int

class ReadUserOutput(BaseModel):
    user_id: int
    nickname: str
    sex: Literal['M', 'F']
    age: int