from datetime import datetime, timedelta
from fastapi import HTTPException, status
from jose import JWTError, jwt
from core.config import Settings
import random

settings = Settings()


def create_token(token: dict):
	token_sub = token['sub']

	payload = {
		"id": token_sub,
		"expires": (datetime.now().replace(microsecond=0) + timedelta(hours=1)).timestamp()
	}
	access_token = jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm="HS256")
	
	payload = {
		"id": token_sub,
		"expires": (datetime.now().replace(microsecond=0) + timedelta(days=14)).timestamp()
	}
	refresh_token = jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm="HS256")

	return access_token, refresh_token


def verify_access_token(token: str):
	try:
		data = jwt.decode(token, settings.JWT_SECRET_KEY, algorithms="HS256")
		expires = data.get("expires")

		if expires is None:
			raise HTTPException(
				status_code=status.HTTP_400_BAD_REQUEST,
				detail="No access token supplied"
			)
		if datetime.fromtimestamp(expires) < datetime.now():
			raise HTTPException(
				status_code=status.HTTP_403_FORBIDDEN,
				detail="Token expired!"
			)
		return data
	except JWTError:
		raise HTTPException(
			status_code=status.HTTP_400_BAD_REQUEST,
			detail="Invalid token"
		)


def create_guest_sub():
	seed = datetime.now().timestamp()
	seed_str = str(seed).replace('.', '')[:15]
	
	random.seed(seed)
	random_number = str(random.randint(100000, 999999))
	
	return seed_str + random_number
