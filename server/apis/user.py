import os
import shutil
from datetime import date
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, Response, status, UploadFile, File

from auth import auth_handler
from models.diary_model import DiaryTable
from models.user_model import *
from schemas.user_schema import *
from schemas.login_schema import *


def create_user(create_user_input: CreateUserInput, db: Session) -> User:
    user = UserTable(
        email=create_user_input.email,
        hashed_token=create_user_input.hashed_token,
        nickname=create_user_input.nickname
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
    

def download_user_photo(token: str, download_user_photo_input: DownloadUserPhotoInput):
    decode_token = auth_handler.verify_access_token(token)['id']
    
    try:
        photo_path = download_user_photo_input.photo_url
        # 파일이 존재하는지 확인
        if not os.path.exists(photo_path):
            raise HTTPException(
                status_code=404,
                detail="Image not found"
            )
            
        # 파일 확장자 확인 (보안을 위해)
        allowed_extensions = ['.jpg', '.jpeg', '.png']
        file_extension = os.path.splitext(photo_path)[1].lower()
        
        if file_extension not in allowed_extensions:
            raise HTTPException(
                status_code=400,
                detail="Invalid file type"
            )
            
        # Content-Type 설정
        media_types = {
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.png': 'image/png',
        }
        
        with open(photo_path, "rb") as file:
            file_content = file.read()

        # 파일 반환
        return Response(
            media_type=media_types.get(file_extension, 'application/octet-stream'),
            content=file_content
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error occurred while downloading the image: {str(e)}"
        )
    
def upload_user_photo(db: Session, token: str, file: UploadFile = File(...)):
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")

        data_url = "./data/img"
        os.makedirs(data_url, exist_ok=True)

        file_extension = os.path.splitext(file.filename)[1]
        
        # 저장할 파일명 생성 (user_id를 사용하여 고유한 파일명 생성)
        file_name = f"{user.user_id}{file_extension}"
        file_path = f"{data_url}/{file_name}"
        
        # 파일 저장
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        user.photo_url = file_path

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")


def delete_user_photo(db: Session, token: str) -> User:
    try:
        decode_token = auth_handler.verify_access_token(token)['id']
        user = db.query(UserTable).filter(UserTable.hashed_token == decode_token).first()

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 user가 존재하지 않습니다")
        
        if os.path.exists(user.photo_url):
            os.remove(user.photo_url)
            user.photo_url = None

        db.add(user)
        db.commit()
        db.refresh(user)

        return user
    
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")


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


def sync_guest_to_user(sync_user_input: SyncUserInput, db: Session, token: str):
    # 1. 계정생성 -> 프론트에서 작업
    guest_decode_token = auth_handler.verify_access_token(sync_user_input.guest_token)['id']
    guest_user = db.query(UserTable).filter(
        UserTable.hashed_token == guest_decode_token
    ).first()

    google_decode_token = auth_handler.verify_access_token(token)['id']
    google_user = db.query(UserTable).filter(
        UserTable.hashed_token == google_decode_token
    ).first()

    # 2. 일기 이관
    guest_diaries = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == guest_decode_token
    )
    for guest_diary in guest_diaries:
        setattr(guest_diary, 'user_id', google_user.user_id)

    # 3. 유저 정보 이관
    google_user.photo_url = guest_user.photo_url
    google_user.nickname = guest_user.nickname
    google_user.gender = guest_user.gender
    google_user.age = guest_user.age

    # 4. 계스트 계정 비활성화
    update_user_disabled(db=db, token=sync_user_input.guest_token)


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
