import random
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.quote_model import *
from models.sentiment_model import *
from models.user_model import *
from schemas.quote_schema import *
from auth import auth_handler
from core.config import Settings

from apis.gpt import Model
from apis.prompt import QUOTE_SYSTEM_PROMPT


settings = Settings()

def read_quote(db: Session, token: str) -> Quote:
    decode_token = auth_handler.verify_access_token(token)['id']

    quote_list = db.query(QuoteTable).all()
    quote = db.query(QuoteTable).filter(QuoteTable.quote_id == random.randint(1, len(quote_list))).first()

    if not quote:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 quote이 존재하지 않습니다")
    
    return quote


def read_quote_gpt(read_quote_input: ReadQuoteInput, db: Session, token: str) -> Quote:
    decode_token = auth_handler.verify_access_token(token)['id']

    system_msg = QUOTE_SYSTEM_PROMPT
    user_msg = f"'{read_quote_input.sentiment}' 내용이 포함된 감성 글귀를 하나만 말해줘"

    model = Model()
    quote = model.generate_single(system_msg, user_msg)

    quote_id = db.query(SentimentTable).filter(SentimentTable.sentiment_content == read_quote_input.sentiment).first()

    return {"sentiment_id": quote_id.sentiment_id, "quote_content": quote}
