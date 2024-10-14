from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from auth.auth_bearer import JWTBearer
from db.connection import get_db

from apis import quote
from schemas.quote_schema import *


router = APIRouter(prefix="/quote", tags=["QUOTE"])


@router.get("/read")
def read_quote(read_quote_input: ReadQuoteInput, db: Session = Depends(get_db), token: str = Depends(JWTBearer())) -> ReadQuoteOutput:
    res = quote.read_quote(read_quote_input=read_quote_input, db=db, token=token)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})
