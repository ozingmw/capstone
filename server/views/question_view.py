from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.question_model import *
from schemas.question_schema import *


def create_question(create_question_input: CreateQuestionInput, db: Session) -> Question:
    question = QuestionTable(
        question_content=create_question_input.question_content
    )

    try:
        db.add(question)
        db.commit()
        db.refresh(question)

        return question
    
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 question입니다")

def read_question(db: Session):
    question = db.query(QuestionTable).all()

    if not question:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 question이 존재하지 않습니다")
    
    return question

# def read_question_by_question_id(question_id: int, db: Session) -> question:
#     question = db.query(questionTable).filter(questionTable.question_id == question_id).first()

#     if not question:
#         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 question이 존재하지 않습니다")
    
#     return question
    
def update_question(update_question_input: UpdateQuestionInput, db: Session) -> Question:
    try:
        question = db.query(QuestionTable).filter(QuestionTable.question_id == update_question_input.question_id).first()

        if not question:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 question이 존재하지 않습니다")
        
        for key, value in update_question_input.model_dump().items():
            setattr(question, key, value)

        db.add(question)
        db.commit()
        db.refresh(question)

        return question

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")

def delete_question(delete_question_input: DeleteQuestionInput, db: Session) -> bool:
    try:
        question = db.query(QuestionTable).filter(QuestionTable.question_id == delete_question_input.question_id).first()

        if not question:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 question이 존재하지 않습니다")
        
        db.delete(question)
        db.commit()

        return True

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")