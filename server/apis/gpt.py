from core.config import Settings
from openai import OpenAI


settings = Settings()

class Model:
    def __init__(self):
        self.client = OpenAI(api_key=settings.API_KEY)

    def generate_single(self, system_msg, user_msg):
        completion = self.client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": system_msg},
                {
                    "role": "user",
                    "content": user_msg
                }
            ]
        )
    
        return completion.choices[0].message.content
