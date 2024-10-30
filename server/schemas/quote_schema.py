from pydantic import BaseModel
from typing import Optional

from models.quote_model import Quote


class BasicQuoteOutput(BaseModel):
    quote: Optional[Quote]
