import random
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from auth import auth_handler
from models.question_model import *
from schemas.question_schema import *


def read_random_question(db: Session, token: str) -> ReadQuestionOutput:
    decode_token = auth_handler.verify_access_token(token)['id']
    
    question = db.query(QuestionTable).all()
    question = question[random.randint(0, len(question) - 1)]
    
    return question


def read_question(read_question_input: ReadQuestionInput, db: Session, token: str) -> ReadQuestionOutput:
    decode_token = auth_handler.verify_access_token(token)['id']
    
    question = db.query(QuestionTable).filter(QuestionTable.question_id == read_question_input.question_id).first()
    
    if question is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Question not found")
    
    return question