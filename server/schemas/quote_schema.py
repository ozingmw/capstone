from pydantic import BaseModel
from typing import Optional

from models.quote_model import Quote


class ReadQuoteInput(BaseModel):
    sentiment: str


class BaseQuoteOutput(BaseModel):
    quote: Optional[Quote]
