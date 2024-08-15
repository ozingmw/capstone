from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db
from auth.auth_bearer import JWTBearer

from apis import quote
from schemas.quote_schema import *


router = APIRouter(prefix="/quote", tags=["QUOTE"])

@router.post("/")
async def create_quote(create_quote_input: CreateQuoteInput, db: Session = Depends(get_db)) -> CreateQuoteOutput:
    res = quote.create_quote(create_quote_input=create_quote_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'res': jsonable_encoder(res)})
    
@router.get("/")
def read_quote(db: Session = Depends(get_db)) -> ReadQuoteOutput:
    res = quote.read_quote(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.put("/")
def update_quote(update_quote_input: UpdateQuoteInput, db: Session = Depends(get_db)) -> UpdateQuoteOutput:
    res = quote.update_quote(update_quote_input=update_quote_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})

@router.delete("/")
def delete_quote(delete_quote_input: DeleteQuoteInput, db: Session = Depends(get_db)) -> DeleteQuoteOutput:
    res = quote.delete_quote(delete_quote_input=delete_quote_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'res': jsonable_encoder(res)})