import os
from dotenv import load_dotenv
load_dotenv()


class Settings:
    DB_USERNAME: str = os.getenv("DB_USERNAME")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_HOST: str = os.getenv("DB_HOST")
    DB_PORT: str = os.getenv("DB_PORT")
    DB_DATABASE: str = os.getenv("DB_DATABASE")
    SSL_CA_PATH: str = os.getenv("SSL_CA_PATH")

    DATABASE_URL = f"mysql+pymysql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_DATABASE}?ssl_ca=" + SSL_CA_PATH

    JWT_SECRET_KEY: str = os.getenv("JWT_SECRET_KEY")
    JWT_ALGORITHM: str = os.getenv("JWT_ALGORITHM")

    IOS_GOOGLE_CLIENT_ID: str = os.getenv("IOS_GOOGLE_CLIENT_ID")
    ANDROID_GOOGLE_CLIENT_ID: str = os.getenv("ANDROID_GOOGLE_CLIENT_ID")

    MODEL_HOST: str = os.getenv("MODEL_HOST")
    API_KEY: str = os.getenv("API_KEY")
    