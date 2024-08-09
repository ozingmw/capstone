from pydantic import BaseModel


class CallbackInput(BaseModel):
    state: str
    code: str
    scope: str
    authuser: int
    prompt: str