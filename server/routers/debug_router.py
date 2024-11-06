from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from db.connection import get_db
from models.diary_model import DiaryTable
from models.question_model import QuestionTable
from models.quote_model import QuoteTable
from models.sentiment_model import SentimentTable
from models.user_model import UserTable


router = APIRouter(prefix="/debug", tags=["DEBUG"])


@router.get("/user")
def get_user(db: Session = Depends(get_db)):
    user = db.query(UserTable).all()
    return user

@router.get("/diary")
def get_diary(db: Session = Depends(get_db)):
    diary = db.query(DiaryTable).all()
    return diary

@router.get("/question")
def get_question(db: Session = Depends(get_db)):
    question = db.query(QuestionTable).all()
    return question

@router.get("/sentiment")
def get_sentiment(db: Session = Depends(get_db)):
    sentiment = db.query(SentimentTable).all()
    return sentiment

@router.get("/quote")
def get_quote(db: Session = Depends(get_db)):
    quote = db.query(QuoteTable).all()
    return quote