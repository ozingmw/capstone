from pydantic import BaseModel
from typing import Optional

from models.quote_model import Quote


class CreateQuoteInput(BaseModel):
    quote_content: str

class CreateQuoteOutput(BaseModel):
    quote: Optional[Quote]
    
class ReadQuoteOutput(BaseModel):
    quote: Optional[Quote]

class UpdateQuoteInput(BaseModel):
    quote_id: int
    quote_content: str

class UpdateQuoteOutput(BaseModel):
    quote: Optional[Quote]

class DeleteQuoteInput(BaseModel):
    quote_id: int

class DeleteQuoteOutput(BaseModel):
    bool