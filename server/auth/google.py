from google_auth_oauthlib.flow import Flow
from google.oauth2.id_token import verify_oauth2_token
from google.auth.transport import requests


scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid'
]

def auth():
    flow = Flow.from_client_secrets_file("./client_secret.json", scopes=scopes)
    flow.redirect_uri = 'http://localhost:8000/login/google'

    auth_url, state = flow.authorization_url()

    return auth_url

def auth_callback(code: str):
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

    token_data = verify_oauth2_token(credentials.id_token, requests.Request())
    
    # token_sub = token['sub']
    # token_exp = token['exp']
    # token_email = token['email']
    
    return token_data