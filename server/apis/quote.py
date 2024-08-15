from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.quote_model import *
from schemas.quote_schema import *


def create_quote(create_quote_input: CreateQuoteInput, db: Session) -> Quote:
    quote = QuoteTable(
        quote_content=create_quote_input.quote_content
    )

    try:
        db.add(quote)
        db.commit()
        db.refresh(quote)

        return quote
    
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 quote입니다")

def read_quote(db: Session):
    quote = db.query(QuoteTable).all()

    if not quote:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 quote이 존재하지 않습니다")
    
    return quote
    
def update_quote(update_quote_input: UpdateQuoteInput, db: Session) -> Quote:
    try:
        quote = db.query(QuoteTable).filter(QuoteTable.quote_id == update_quote_input.quote_id).first()

        if not quote:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 quote이 존재하지 않습니다")
        
        for key, value in update_quote_input.model_dump().items():
            setattr(quote, key, value)

        db.add(quote)
        db.commit()
        db.refresh(quote)

        return quote

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")

def delete_quote(delete_quote_input: DeleteQuoteInput, db: Session) -> bool:
    try:
        quote = db.query(QuoteTable).filter(QuoteTable.quote_id == delete_quote_input.quote_id).first()

        if not quote:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 quote이 존재하지 않습니다")
        
        db.delete(quote)
        db.commit()

        return True

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")