from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.sentiment_model import *
from schemas.sentiment_schema import *


def create_sentiment(create_sentiment_input: CreateSentimentInput, db: Session) -> Sentiment:
    sentiment = SentimentTable(sentiment_content=create_sentiment_input.sentiment_content)

    try:
        db.add(sentiment)
        db.commit()
        db.refresh(sentiment)

        return sentiment
    
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 sentiment입니다")

def read_sentiment(db: Session):
    sentiment = db.query(SentimentTable).all()

    if not sentiment:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 sentiment이 존재하지 않습니다")
    
    return sentiment
    
def update_sentiment(update_sentiment_input: UpdateSentimentInput, db: Session) -> Sentiment:
    try:
        sentiment = db.query(SentimentTable).filter(SentimentTable.sentiment_id == update_sentiment_input.sentiment_id).first()

        if not sentiment:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 sentiment이 존재하지 않습니다")
        
        for key, value in update_sentiment_input.model_dump().items():
            setattr(sentiment, key, value)

        db.add(sentiment)
        db.commit()
        db.refresh(sentiment)

        return sentiment

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")

def delete_sentiment(delete_sentiment_input: DeleteSentimentInput, db: Session) -> bool:
    try:
        sentiment = db.query(SentimentTable).filter(SentimentTable.sentiment_id == delete_sentiment_input.sentiment_id).first()

        if not sentiment:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 sentiment이 존재하지 않습니다")
        
        db.delete(sentiment)
        db.commit()

        return True

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")