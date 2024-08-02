from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status

from models.diary_model import *
from schemas.diary_schema import *


def create_diary(create_diary_input: CreateDiaryInput, db: Session) -> Diary:
    diary = DiaryTable(
        diary_content=create_diary_input.diary_content
    )

    try:
        db.add(diary)
        db.commit()
        db.refresh(diary)

        return diary
    
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 존재하는 diary입니다")

def read_diary(db: Session):
    diary = db.query(DiaryTable).all()

    if not diary:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
    
    return diary

# def read_diary_by_diary_id(diary_id: int, db: Session) -> diary:
#     diary = db.query(diaryTable).filter(diaryTable.diary_id == diary_id).first()

#     if not diary:
#         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
    
#     return diary
    
def update_diary(update_diary_input: UpdateDiaryInput, db: Session) -> Diary:
    try:
        diary = db.query(DiaryTable).filter(DiaryTable.diary_id == update_diary_input.diary_id).first()

        if not diary:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
        
        for key, value in update_diary_input.model_dump().items():
            setattr(diary, key, value)

        db.add(diary)
        db.commit()
        db.refresh(diary)

        return diary

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="수정 실패")

def delete_diary(delete_diary_input: DeleteDiaryInput, db: Session) -> bool:
    try:
        diary = db.query(DiaryTable).filter(DiaryTable.diary_id == delete_diary_input.diary_id).first()

        if not diary:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="일치하는 diary이 존재하지 않습니다")
        
        db.delete(diary)
        db.commit()

        return True

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="삭제 실패")