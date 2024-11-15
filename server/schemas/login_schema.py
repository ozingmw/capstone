from pydantic import BaseModel


class LoginInput(BaseModel):
    token: str
    os: str


class SyncUserInput(BaseModel):
    guest_token: str
    