from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.user_model import *
from schemas.user_schema import *


def create_user(create_user_input: CreateUserInput, db: Session) -> User:
    user = UserTable(
        nickname=create_user_input.nickname,
        sex=create_user_input.sex,
        age=create_user_input.age,
    )

    try:
        db.add(user)
        db.commit()
        db.refresh(user)

        return user
    
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 user입니다")

def read_user(db: Session):
    user = db.query(UserTable).all()

    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")
    
    return user

def update_user(update_user_input: UpdateUserInput, db: Session) -> User:
    try:
        user = db.query(UserTable).filter(UserTable.user_id == update_user_input.user_id).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")
        
        for key, value in update_user_input.model_dump().items():
            setattr(user, key, value)

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")

def delete_user(delete_user_input: DeleteUserInput, db: Session) -> bool:
    try:
        user = db.query(UserTable).filter(UserTable.user_id == delete_user_input.user_id).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")
        
        db.delete(user)
        db.commit()

        return True

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")