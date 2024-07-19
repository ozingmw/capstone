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
        raise HTTPException(status_code=status.HTTP_409_CONFLICT,
                            detail="이미 존재하는 사용자입니다")

def get_user(user_id: int, db: Session):
    user = db.query(UserTable).filter(UserTable.user_id == user_id).first()

    if user:
        return {
            "status_code": status.HTTP_200_OK,
            "detail": "사용자 조회 성공",
            "data": user
        }
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="일치하는 사용자가 존재하지 않습니다")