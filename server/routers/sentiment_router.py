from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db
from auth.auth_bearer import JWTBearer

from apis import sentiment
from schemas.sentiment_schema import *


router = APIRouter(prefix="/sentiment", tags=["SENTIMENT"])

@router.post("/")
async def create_sentiment(create_sentiment_input: CreateSentimentInput, db: Session = Depends(get_db)) -> CreateSentimentOutput:
    res = sentiment.create_sentiment(create_sentiment_input=create_sentiment_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'res': jsonable_encoder(res)})
    
@router.get("/")
def read_sentiment(db: Session = Depends(get_db)) -> ReadSentimentOutput:
    res = sentiment.read_sentiment(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.put("/")
def update_sentiment(update_sentiment_input: UpdateSentimentInput, db: Session = Depends(get_db)) -> UpdateSentimentOutput:
    res = sentiment.update_sentiment(update_sentiment_input=update_sentiment_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.delete("/")
def delete_sentiment(delete_sentiment_input: DeleteSentimentInput, db: Session = Depends(get_db)) -> DeleteSentimentOutput:
    res = sentiment.delete_sentiment(delete_sentiment_input=delete_sentiment_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})