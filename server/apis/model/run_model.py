import re
import torch
from transformers import AutoTokenizer
from peft import AutoPeftModelForCausalLM

model = None
tokenizer = None
device = None

PROMPT="""<|prompt|>You are an AI assistant tasked with analyzing the emotional content of a diary entry. Your goal is to determine the most closely matching emotion from a predefined list.

Here is the diary entry you need to analyze:

<diary_entry>
age: {age} | gender: {gender} | diary: {sentence}
</diary_entry>

Please carefully read and analyze the content of this diary entry. Consider the overall tone, the events described, and the language used by the writer.

Based on your analysis, choose the emotion that best matches the overall sentiment of the diary entry from the following list:

['분노', '불안', '상처', '슬픔', '당황', '기쁨']

Translate these emotions to English for your understanding:
['분노(anger)', '불안(anxiety)', '상처(hurt)', '슬픔(sadness)', '당황(embarrassment)', '기쁨(happiness)']

After you've made your decision, respond with only the chosen emotion in Korean. Do not provide any explanation or additional text.

Your response should be formatted as follows:
<emotion>[chosen emotion in korean]</emotion>

Once you've provided the emotion, end the conversation. Do not engage in any further dialogue or provide any additional information.
<|assistant|>"""

def load_model():
    global model, tokenizer, device

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    path = './apis/model/llama-3.2-3B-sentiment_only_018_v2'
    
    tokenizer = AutoTokenizer.from_pretrained(path)
    model = AutoPeftModelForCausalLM.from_pretrained(
        path,
        attn_implementation="flash_attention_2",
        torch_dtype=torch.float16,
        device_map=device,
    )
    model.eval()

def generate(text, age, gender):
    global model, tokenizer, device
    text = PROMPT.format(age=age, gender=gender, sentence=text)
    inputs = tokenizer(text, return_tensors="pt").to(device)

    with torch.no_grad():
        outputs = model.generate(**inputs, max_new_tokens=11, pad_token_id=tokenizer.pad_token_id)
        decoded_output = tokenizer.decode(outputs[0])

        try:
            pred = decoded_output.split("<|assistant|>")[1]
            pred = re.search(r'<emotion>(.*?)</emotion>', pred).group(1)
        except:
            pred = 'error'
            
    return pred