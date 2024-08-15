from pydantic import BaseModel
from typing import Optional

from models.sentiment_model import Sentiment


class CreateSentimentInput(BaseModel):
    sentiment_content: str

class CreateSentimentOutput(BaseModel):
    sentiment: Optional[Sentiment]
    
class ReadSentimentOutput(BaseModel):
    sentiment: Optional[Sentiment]

class UpdateSentimentInput(BaseModel):
    sentiment_id: int
    sentiment_content: str

class UpdateSentimentOutput(BaseModel):
    sentiment: Optional[Sentiment]

class DeleteSentimentInput(BaseModel):
    sentiment_id: int

class DeleteSentimentOutput(BaseModel):
    bool