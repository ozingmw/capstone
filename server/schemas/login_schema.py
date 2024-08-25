from pydantic import BaseModel


class RegisterInput(BaseModel):
    email: str
    encoded_token: str
    nickname: str


class LoginInput(BaseModel):
    encoded_token: str