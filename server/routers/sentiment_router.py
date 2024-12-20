from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db
from auth.auth_bearer import JWTBearer

from apis import sentiment
from schemas.sentiment_schema import *


router = APIRouter(prefix="/sentiment", tags=["SENTIMENT"])


@router.post("/weekly")
def read_weekly_sentiment(read_weekly_sentiment_input: ReadWeeklySentimentInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseSentimentOutput:
    res = sentiment.read_weekly_sentiment(read_weekly_sentiment_input=read_weekly_sentiment_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/monthly")
def read_monthly_sentiment(read_monthly_sentiment_input: ReadMonthlySentimentInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseSentimentOutput:
    res = sentiment.read_monthly_sentiment(read_monthly_sentiment_input=read_monthly_sentiment_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})


@router.post("/halfyear")
def read_halfyear_sentiment(read_halfyear_sentiment_input: ReadHalfyearSentimentInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> BaseSentimentOutput:
    res = sentiment.read_halfyear_sentiment(read_halfyear_sentiment_input=read_halfyear_sentiment_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})
