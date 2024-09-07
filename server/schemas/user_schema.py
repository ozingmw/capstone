from pydantic import BaseModel
from typing import Optional

from models.user_model import User


class CreateUserInput(BaseModel):
    email: str
    hashed_token: str
    nickname: str
    disabled: bool = False


class CreateUserOutput(BaseModel):
    user: Optional[User]


class UpdateUserTokenInput(BaseModel):
    email: str
    hashed_token: str


class UpdateUserNicknameInput(BaseModel):
    token: str
    nickname: str


class UpdateUserNicknameOutput(BaseModel):
    user: Optional[User]


class DeleteUserInput(BaseModel):
    user_id: int


class DeleteUserOutput(BaseModel):
    user: Optional[User]


# ------ 사용 X ------


# class ReadUserInput(BaseModel):
#     user_id: int


# class ReadUserOutput(BaseModel):
#     user: Optional[User]
