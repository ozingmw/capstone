from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from auth import auth_handler
from models.user_model import *
from schemas.user_schema import *


def create_user(create_user_input: CreateUserInput, db: Session) -> User:
    user = UserTable(
        email=create_user_input.email,
        hashed_token=create_user_input.hashed_token,
        nickname=create_user_input.nickname,
        disabled=create_user_input.disabled
    )

    try:
        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 user입니다"
        )


def read_user_email(email: str, db: Session) -> bool:
    user = db.query(UserTable).filter(UserTable.email == email).first()

    return user


def update_user_nickname(update_user_nickname_input: UpdateUserNicknameInput, db: Session) -> User:
    try:
        decode_token = auth_handler.verify_access_token(update_user_nickname_input.token)
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        user.nickname = update_user_nickname_input.nickname

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")


def delete_user(delete_user_input: DeleteUserInput, db: Session) -> bool:
    try:
        user = db.query(UserTable).filter(UserTable.hashed_token == delete_user_input.token).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="일치하는 user가 존재하지 않습니다",
            )
        
        user.disabled = True

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")


def check_token(check_token_input: CheckTokenInput, db: Session) -> User:
    try:
        decode_token = auth_handler.verify_access_token(check_token_input.token)
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="조회 실패")
    