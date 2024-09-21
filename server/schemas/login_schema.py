from pydantic import BaseModel


class LoginInput(BaseModel):
    token: str
    os: str