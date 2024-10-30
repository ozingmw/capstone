from datetime import date
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


def update_user_nickname(update_user_nickname_input: UpdateUserNicknameInput, db: Session, token: str) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
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
    
    
def update_user_photo(update_user_photo_input: UpdateUserPhotoInput, db: Session, token: str) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        user.photo_url = update_user_photo_input.photo_url

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")   


def update_user_age(update_user_age_input: UpdateUserAgeInput, db: Session, token: str) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        user.age = update_user_age_input.age

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")


def update_user_gender(update_user_gender_input: UpdateUserGenderInput, db: Session, token: str) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        user.gender = update_user_gender_input.gender

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패") 
    

def update_user_token(refresh_token: str, db: Session) -> User:
    try:
        decode_token = auth_handler.verify_access_token(refresh_token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        # 현재 token값을 그대로 사용하기 때문에 미사용 함수
        # user.hashed_token = refresh_token

        db.add(user)
        db.commit()
        db.refresh(user)

        return user
    
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")


def update_user_disabled(db: Session, token: str) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="일치하는 user가 존재하지 않습니다",
            )
        
        user.disabled = True
        user.disabled_at = date.today()

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")
    

def update_user_enabled(db: Session, token: str) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="일치하는 user가 존재하지 않습니다",
            )
        
        user.disabled = False
        user.disabled_at = None

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="복구 실패")


def check_token(token: str, db: Session) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="조회 실패")
    

def check_nickname(token: str, db: Session) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        return user.nickname

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="조회 실패")
    

# def delete_account(token: str, db: Session) -> User:
#     try:
        
#         decode_token = auth_handler.verify_access_token(token)
#         auth_handler.revoke_google_token(decode_token)

#         user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

#         if not user:
#             raise HTTPException(
#                 status_code=status.HTTP_404_NOT_FOUND,
#                 detail="일치하는 user가 존재하지 않습니다",
#             )

#         db.delete(user)
#         db.commit()

#         return user

#     except IntegrityError as e:
#         db.rollback()
#         raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")