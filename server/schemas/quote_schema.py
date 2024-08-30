from pydantic import BaseModel
from typing import Optional

from models.quote_model import Quote


class ReadQuoteInput(BaseModel):
    quote_id: int


class ReadQuoteOutput(BaseModel):
    quote: Optional[Quote]


# ------ 사용 X ------


# class CreateQuoteInput(BaseModel):
#     quote_content: str


# class CreateQuoteOutput(BaseModel):
#     quote: Optional[Quote]


# class ReadQuoteOutput(BaseModel):
#     quote: Optional[Quote]


# class UpdateQuoteInput(BaseModel):
#     quote_id: int
#     quote_content: str


# class UpdateQuoteOutput(BaseModel):
#     quote: Optional[Quote]


# class DeleteQuoteInput(BaseModel):
#     quote_id: int


# class DeleteQuoteOutput(BaseModel):
#     bool
