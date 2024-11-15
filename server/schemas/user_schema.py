from fastapi import File
from pydantic import BaseModel
from typing import Optional, Literal

from models.user_model import User


class BaseUserOutput(BaseModel):
    user: Optional[User]


class CreateUserInput(BaseModel):
    email: str
    hashed_token: str
    nickname: str


class UpdateUserNicknameInput(BaseModel):
    nickname: str
    

class DownloadUserPhotoInput(BaseModel):
    photo_url: str


class UpdateUserAgeInput(BaseModel):
    age: int


class UpdateUserGenderInput(BaseModel):
    gender: Literal['M', 'F']


class DeleteUserInput(BaseModel):
    token: int
