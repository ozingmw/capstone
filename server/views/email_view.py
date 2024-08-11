import random
import datetime
from sqlalchemy.orm import Session
from uuid import uuid4

from models.user_model import *

def check_email(email: str, db: Session):
    user = db.query(UserTable).filter(UserTable.email == email).first()
    return True if user else False

def generate_session_id():
    return str(uuid4())

def generate_otp(email_address, session_data):
    otp = str(random.randint(100000, 999999))
    session_id = generate_session_id()

    session_data[session_id] = {
        'otp': otp,
        'otp_exp': datetime.datetime.now() + datetime.timedelta(minutes=5),
        'email_address': email_address
    }
    
    return otp

def send_otp_code(email: str):
   pass

def login_social(token: str, db: Session):
    user = db.query(UserTable).filter(UserTable.hashed_token == token).first()
    return user