from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db
from auth.auth_bearer import JWTBearer

from apis import question
from schemas.question_schema import *


router = APIRouter(prefix="/question", tags=["QUESTION"])

@router.post("/")
async def create_question(create_question_input: CreateQuestionInput, db: Session = Depends(get_db)) -> CreateQuestionOutput:
    res = question.create_question(create_question_input=create_question_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'res': jsonable_encoder(res)})
    
@router.get("/")
def read_question(db: Session = Depends(get_db)) -> ReadQuestionOutput:
    res = question.read_question(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.put("/")
def update_question(update_question_input: UpdateQuestionInput, db: Session = Depends(get_db)) -> UpdateQuestionOutput:
    res = question.update_question(update_question_input=update_question_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.delete("/")
def delete_question(delete_question_input: DeleteQuestionInput, db: Session = Depends(get_db)) -> DeleteQuestionOutput:
    res = question.delete_question(delete_question_input=delete_question_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})