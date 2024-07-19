from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.connection import get_db
from views import user_view

from schemas.user_schema import *


user_router = APIRouter(prefix="/user", tags=["user"])

@user_router.post("/")
async def create_user(create_user_input: CreateUserInput, db: Session = Depends(get_db)) -> CreateUserOutput:
    user = user_view.create_user(create_user_input=create_user_input, db=db)
    print(user)
    return {'user': user}
    
@user_router.get("/{user_id}")
def read_user(user_id: int, db: Session = Depends(get_db)):
    res = user_view.get_user(user_id=user_id, db=db)
    return res