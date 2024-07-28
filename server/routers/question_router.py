from fastapi import APIRouter, Depends
from fastapi import HTTPException, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session
from db.connection import get_db

from views import question_view as view

from schemas.question_schema import *


router = APIRouter(prefix="/question", tags=["QUESTION"])

@router.post("/")
async def create_question(create_question_input: CreateQuestionInput, db: Session = Depends(get_db)) -> CreateQuestionOutput:
    question = view.create_question(create_question_input=create_question_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'question': jsonable_encoder(question)})
    
@router.get("/")
def read_question(db: Session = Depends(get_db)) -> ReadQuestionOutput:
    question = view.read_question(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'question': jsonable_encoder(question)})

@router.put("/")
def update_question(update_question_input: UpdateQuestionInput, db: Session = Depends(get_db)) -> UpdateQuestionOutput:
    question = view.update_question(update_question_input=update_question_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'question': jsonable_encoder(question)})

@router.delete("/")
def delete_question(delete_question_input: DeleteQuestionInput, db: Session = Depends(get_db)) -> DeleteQuestionOutput:
    question = view.delete_question(delete_question_input=delete_question_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'question': jsonable_encoder(question)})