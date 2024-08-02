from fastapi import APIRouter, Depends, status
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from db.connection import get_db

from views import quote_view as view
from schemas.quote_schema import *


router = APIRouter(prefix="/quote", tags=["QUOTE"])

@router.post("/")
async def create_quote(create_quote_input: CreateQuoteInput, db: Session = Depends(get_db)) -> CreateQuoteOutput:
    quote = view.create_quote(create_quote_input=create_quote_input, db=db)

    return JSONResponse(status_code=status.HTTP_201_CREATED, content={'quote': jsonable_encoder(quote)})
    
@router.get("/")
def read_quote(db: Session = Depends(get_db)) -> ReadQuoteOutput:
    quote = view.read_quote(db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'quote': jsonable_encoder(quote)})

@router.put("/")
def update_quote(update_quote_input: UpdateQuoteInput, db: Session = Depends(get_db)) -> UpdateQuoteOutput:
    quote = view.update_quote(update_quote_input=update_quote_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'quote': jsonable_encoder(quote)})

@router.delete("/")
def delete_quote(delete_quote_input: DeleteQuoteInput, db: Session = Depends(get_db)) -> DeleteQuoteOutput:
    quote = view.delete_quote(delete_quote_input=delete_quote_input, db=db)
    
    return JSONResponse(status_code=status.HTTP_200_OK, content={'quote': jsonable_encoder(quote)})