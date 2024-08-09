from sqlalchemy.orm import Session
from google_auth_oauthlib.flow import Flow

from models.user_model import *
from schemas.auth_schema import *
from auth.jwt import *


scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid'
]

def auth_google():
    flow = Flow.from_client_secrets_file("./client_secret.json", scopes=scopes)
    flow.redirect_uri = 'http://localhost:8000/login/google'

    auth_url, state = flow.authorization_url()

    return auth_url

def auth_google_callback(code: str, db: Session):
    flow = Flow.from_client_secrets_file("./client_secret.json", scopes=scopes)
    flow.redirect_uri = 'http://localhost:8000/login/google'

    flow.fetch_token(code=code)

    credentials = flow.credentials

    # print(credentials.id_token)
    # 'token': credentials.token, -> flow.oauth2session의 access_token하고 일치
    # 'refresh_token': credentials.refresh_token,
    # 'token_uri': credentials.token_uri,
    # 'client_id': credentials.client_id,
    # 'client_secret': credentials.client_secret,
    # 'scopes': credentials.scopes

    from google.oauth2.id_token import verify_oauth2_token
    from google.auth.transport import requests

    id_info = verify_oauth2_token(credentials.id_token, requests.Request())
    id_token = id_info['sub']
    id_exp = id_info['exp']

    user = db.query(UserTable).filter(UserTable.id_token == id_token).first()

    if user:
        token = create_access_token(id=id_token, exp=id_exp)
    else:
        from views.user_view import create_user
        create_user_input = UserTable(
            nickname='',
            sex='',
            age='',
            id_token=id_token,
        )
        user = create_user(create_user_input, db=db)

        token = create_access_token(id=id_token, exp=id_exp)

    print(token)

    return token