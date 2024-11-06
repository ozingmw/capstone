from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db
from auth.auth_bearer import JWTBearer

from apis import question
from schemas.question_schema import *


router = APIRouter(prefix="/question", tags=["QUESTION"])


@router.get("/read_random")
def read_random_question(db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> ReadQuestionOutput:
    res = question.read_random_question(db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.post("/read")
def read_question(read_question_input: ReadQuestionInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> ReadQuestionOutput:
    res = question.read_question(db=db, token=token, read_question_input=read_question_input)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})