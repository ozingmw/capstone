import uvicorn
from fastapi import FastAPI
from routers import db_check
from routers.user_router import user_router
from db.session import engine, Base

Base.metadata.create_all(bind=engine)

app = FastAPI(title="FastAPI TEST", description="test", version="0.0.1")

app.include_router(db_check)
app.include_router(user_router)





@app.get("/")
async def root():
    return {"message": "Hello World"}

if __name__ == "__main__":
    uvicorn.run(app, port=8000)