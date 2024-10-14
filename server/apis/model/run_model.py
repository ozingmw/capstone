import re
import torch
from transformers import AutoTokenizer
from peft import AutoPeftModelForCausalLM


device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
path = './apis/model/checkpoint-10000'

tokenizer = AutoTokenizer.from_pretrained(path)
model = AutoPeftModelForCausalLM.from_pretrained(
    path,
    attn_implementation="flash_attention_2",
    torch_dtype=torch.float16,
    device_map=device,
)
model.eval()

def generate(text):
    inputs = text.split('<|assistant|>')[0] + '<|assistant|>'
    inputs = tokenizer(inputs, return_tensors="pt").to(device)

    with torch.no_grad():
        outputs = model.generate(**inputs, max_new_tokens=11, pad_token_id=tokenizer.pad_token_id)
        decoded_output = tokenizer.decode(outputs[0])

        try:
            pred = decoded_output.split("<|assistant|>")[1]
            pred = re.search(r'<emotion>(.*?)</emotion>', pred).group(1)
        except:
            pred = 'error'
            
    return pred