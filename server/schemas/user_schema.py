from pydantic import BaseModel
from typing import Literal, Optional

from models.user_model import User

# output은 User로 해도 되는데 input은 User로 하면 안됨, 다 써야함


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
    user_id: int
    nickname: str


class UpdateUserNicknameOutput(BaseModel):
    user: Optional[User]


# ------ 사용 X ------


# class ReadUserInput(BaseModel):
#     user_id: int


# class ReadUserOutput(BaseModel):
#     user: Optional[User]


# class DeleteUserInput(BaseModel):
#     user_id: int


# class DeleteUserOutput(BaseModel):
#     bool
