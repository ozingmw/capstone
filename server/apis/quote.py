import random
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.quote_model import *
from schemas.quote_schema import *
from auth import auth_handler


def read_quote(db: Session, token: str) -> Quote:
    decode_token = auth_handler.verify_access_token(token)['id']

    quote_list = db.query(QuoteTable).all()
    quote = db.query(QuoteTable).filter(QuoteTable.quote_id == random.randint(1, len(quote_list))).first()

    if not quote:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 quote이 존재하지 않습니다")
    
    return quote
