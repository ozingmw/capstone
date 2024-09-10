from pydantic import BaseModel
from typing import Optional

from models.user_model import User


class BaseUserOutput(BaseModel):
    user: Optional[User]


class CreateUserInput(BaseModel):
    email: str
    hashed_token: str
    nickname: str
    disabled: bool = False


class UpdateUserNicknameInput(BaseModel):
    token: str
    nickname: str


class DeleteUserInput(BaseModel):
    token: int


class DeleteUserOutput(BaseModel):
    user: Optional[User]


class CheckTokenInput(BaseModel):
    token: str
