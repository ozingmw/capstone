from pydantic import BaseModel
from typing import Literal, Optional

from models.user_model import User

# output은 User로 해도 되는데 input은 User로 하면 안됨, 다 써야함


class CreateUserEmailInput(BaseModel):
    email: str
    nickname: str

class CreateUserOutput(BaseModel):
    user: Optional[User]


class ReadUserInput(BaseModel):
    user_id: int
    
class ReadUserOutput(BaseModel):
    user: Optional[User]

class UpdateUserNicknameInput(BaseModel):
    user_id: int
    nickname: str

class UpdateUserNicknameOutput(BaseModel):
    user: Optional[User]

class DeleteUserInput(BaseModel):
    user_id: int

class DeleteUserOutput(BaseModel):
    bool