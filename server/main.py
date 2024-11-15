import uvicorn
from fastapi import Depends, FastAPI
from db.session import engine, Base
from logging.config import dictConfig

from core import log
from auth.auth_bearer import JWTBearer

from routers import db_check
from routers.user_router import router as user_router
from routers.question_router import router as question_router
from routers.sentiment_router import router as sentiment_router
from routers.quote_routers import router as quote_router
from routers.diary_router import router as diary_router
from routers.login_router import router as login_router
from routers.debug_router import router as debug_router


Base.metadata.create_all(bind=engine)

app = FastAPI(title="DayClover", version="0.9.9")

app.include_router(db_check)
app.include_router(login_router)
app.include_router(user_router)
app.include_router(question_router, dependencies=[Depends(JWTBearer())])
app.include_router(sentiment_router, dependencies=[Depends(JWTBearer())])
app.include_router(quote_router, dependencies=[Depends(JWTBearer())])
app.include_router(diary_router, dependencies=[Depends(JWTBearer())])

app.include_router(debug_router)

dictConfig(log.logger)

if __name__ == "__main__":
    uvicorn.run('main:app', host='0.0.0.0', port=9977, reload=True)
