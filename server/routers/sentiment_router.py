from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db

from views import sentiment_view as view
from schemas.sentiment_schema import *


router = APIRouter(prefix="/sentiment", tags=["SENTIMENT"])

@router.post("/")
async def create_sentiment(create_sentiment_input: CreateSentimentInput, db: Session = Depends(get_db)) -> CreateSentimentOutput:
    sentiment = view.create_sentiment(create_sentiment_input=create_sentiment_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'sentiment': jsonable_encoder(sentiment)})
    
@router.get("/")
def read_sentiment(db: Session = Depends(get_db)) -> ReadSentimentOutput:
    sentiment = view.read_sentiment(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'sentiment': jsonable_encoder(sentiment)})

@router.put("/")
def update_sentiment(update_sentiment_input: UpdateSentimentInput, db: Session = Depends(get_db)) -> UpdateSentimentOutput:
    sentiment = view.update_sentiment(update_sentiment_input=update_sentiment_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'sentiment': jsonable_encoder(sentiment)})

@router.delete("/")
def delete_sentiment(delete_sentiment_input: DeleteSentimentInput, db: Session = Depends(get_db)) -> DeleteSentimentOutput:
    sentiment = view.delete_sentiment(delete_sentiment_input=delete_sentiment_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'sentiment': jsonable_encoder(sentiment)})