import uvicorn
from fastapi import Depends, FastAPI
from db.session import engine, Base

from routers import db_check
from routers.user_router import router as user_router
from routers.question_router import router as question_router
from routers.sentiment_router import router as sentiment_router
from routers.quote_routers import router as quote_router
from routers.diary_router import router as diary_router
from routers.login_router import router as login_router

from auth.auth_bearer import JWTBearer


Base.metadata.create_all(bind=engine)

app = FastAPI(title="DayClover", version="0.0.1")

app.include_router(db_check)
app.include_router(login_router)
app.include_router(user_router)
app.include_router(question_router, dependencies=[Depends(JWTBearer())])
app.include_router(sentiment_router, dependencies=[Depends(JWTBearer())])
app.include_router(quote_router, dependencies=[Depends(JWTBearer())])
app.include_router(diary_router, dependencies=[Depends(JWTBearer())])


if __name__ == "__main__":
    uvicorn.run('main:app', host='0.0.0.0', port=9977, reload=True) # 외부 접속 가능
    # uvicorn.run("main:app", port=8000, reload=True)
