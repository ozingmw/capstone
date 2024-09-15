from datetime import datetime
from fastapi import HTTPException, status
from jose import JWTError, jwt
from core.config import Settings


settings = Settings()


def create_token(token: dict):
	token_sub = token['sub']
	token_exp = token['exp']

	payload = {
		"id": token_sub,
		"expires": token_exp
	}
	access_token = jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm="HS256")
	
	payload = {
		"id": token_sub,
		"expires": token_exp + settings.JWT_TOKEN_EXPIRE_TIME
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
