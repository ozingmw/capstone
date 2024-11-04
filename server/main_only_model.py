import enum
import uvicorn
from typing import Optional
from pydantic import BaseModel
from contextlib import asynccontextmanager
from apis.model import run_model
from fastapi import FastAPI


@asynccontextmanager
async def lifespan(app: FastAPI):
    run_model.load_model()
    yield

class GenderEnum(str, enum.Enum):
    M = 'M'
    F = 'F'

class AnalyzeDiaryInput(BaseModel):
    diary_content: str
    age: Optional[int] = None
    gender: Optional[GenderEnum] = None

app = FastAPI(lifespan=lifespan)

@app.post("/predict")
def predict(predict_input: AnalyzeDiaryInput):
    return run_model.generate(predict_input.diary_content, predict_input.age, predict_input.gender)


if __name__ == "__main__":
    uvicorn.run('main_only_model:app', reload=True, host='0.0.0.0', port=9977)
