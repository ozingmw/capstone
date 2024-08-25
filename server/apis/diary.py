from sqlalchemy import extract
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.diary_model import *
from schemas.diary_schema import *
from models.user_model import UserTable


def read_monthly_diary(read_monthly_diary_input: ReadMonthlyDiaryInput, db: Session) -> Diary:
    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == read_monthly_diary_input.token['id'],
        DiaryTable.user_id == UserTable.user_id,
        extract('month', DiaryTable.daytime) == read_monthly_diary_input.date.month,
        extract('year', DiaryTable.daytime) == read_monthly_diary_input.date.year
    ).all()

    return diary


def read_diary(read_diary_input: ReadDiaryInput, db: Session) -> Diary:
    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == read_diary_input.token['id'],
        DiaryTable.daytime == read_diary_input.date
    ).all()

    return diary


def modify_diary(modify_diary_input: ModifyDiaryInput, db: Session) -> Diary:
    diary = db.query(DiaryTable).join(UserTable).filter(
        UserTable.hashed_token == modify_diary_input.token['id'],
        DiaryTable.diary_id == modify_diary_input.diary_id
    ).first()

    if not diary:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
    
    for key, value in modify_diary_input.model_dump(exclude={'token'}).items():
        setattr(diary, key, value)

    db.add(diary)
    db.commit()
    db.refresh(diary)

    return diary


# ------ 사용 X ------


# def create_diary(create_diary_input: CreateDiaryInput, db: Session) -> Diary:
#     diary = DiaryTable(diary_content=create_diary_input.diary_content)

#     try:
#         db.add(diary)
#         db.commit()
#         db.refresh(diary)

#         return diary
    
#     except IntegrityError as e:
#         db.rollback()
#         raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 diary입니다")


# def read_diary(db: Session):
#     diary = db.query(DiaryTable).all()

#     if not diary:
#         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
    
#     return diary
    

# def update_diary(update_diary_input: UpdateDiaryInput, db: Session) -> Diary:
#     try:
#         diary = db.query(DiaryTable).filter(DiaryTable.diary_id == update_diary_input.diary_id).first()

#         if not diary:
#             raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
        
#         for key, value in update_diary_input.model_dump().items():
#             setattr(diary, key, value)

#         db.add(diary)
#         db.commit()
#         db.refresh(diary)

#         return diary

#     except IntegrityError as e:
#         db.rollback()
#         raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")


# def delete_diary(delete_diary_input: DeleteDiaryInput, db: Session) -> bool:
#     try:
#         diary = db.query(DiaryTable).filter(DiaryTable.diary_id == delete_diary_input.diary_id).first()

#         if not diary:
#             raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
        
#         db.delete(diary)
#         db.commit()

#         return True

#     except IntegrityError as e:
#         db.rollback()
#         raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")
