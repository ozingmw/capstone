import uvicorn
from fastapi import FastAPI
from db.session import engine, Base

from routers import db_check
from routers.user_router import router as user_router
from routers.question_router import router as question_router
from routers.sentiment_router import router as sentiment_router
from routers.quote_routers import router as quote_router

Base.metadata.create_all(bind=engine)

app = FastAPI(title="DayClover", version="0.0.1")

app.include_router(db_check)
app.include_router(user_router)
app.include_router(question_router)
app.include_router(sentiment_router)
app.include_router(quote_router)



@app.get("/")
async def root():
    return {"message": "Hello World"}

if __name__ == "__main__":
    uvicorn.run('main:app', port=8000, reload=True)