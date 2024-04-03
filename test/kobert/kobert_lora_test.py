import os
import pandas as pd

PATH = os.path.dirname(__file__)

train_data = pd.read_csv(f"{PATH}/../../datasets/train.csv", encoding = 'utf-8')

train_data.dropna(inplace = True)
train_data.drop(['감정_소분류','시스템문장1','시스템문장2','시스템문장3', '사람문장2', '사람문장3', '신체질환'], axis=1, inplace=True)
train_data.rename({'사람문장1':'text', '감정_대분류':'labels'}, axis=1, inplace=True)

from sklearn.preprocessing import LabelEncoder

label_encoder = LabelEncoder()
train_data['labels'] = label_encoder.fit_transform(train_data['labels'])

import numpy as np
import evaluate
from datasets import Dataset
from transformers import BertForSequenceClassification
from kobert_tokenizer import KoBertTokenizer
from torch.utils.data import DataLoader

tokenizer = KoBertTokenizer.from_pretrained('monologg/kobert')
model = BertForSequenceClassification.from_pretrained('monologg/kobert', num_labels=6)

metric = evaluate.load("accuracy")

def compute_metrics(eval_pred):
    logits, labels = eval_pred
    predictions = np.argmax(logits, axis=-1)
    return metric.compute(predictions=predictions, references=labels)


datasets = Dataset.from_dict(train_data[['text', 'labels']].to_dict('list'))

def tokenize_function(dataset):
    return tokenizer(dataset["text"], padding="max_length", truncation=True)

tokenized_datasets = datasets.map(tokenize_function, batched=True, remove_columns=['text'])
tokenized_datasets = tokenized_datasets.class_encode_column("labels")
tokenized_datasets = tokenized_datasets.train_test_split(test_size=0.1, stratify_by_column='labels', shuffle=True)

import torch
from torch.optim import AdamW
from peft import PeftType, LoraConfig
from transformers import get_linear_schedule_with_warmup
from tqdm import tqdm

batch_size = 32
peft_type = PeftType.LORA
device = "cuda"
num_epochs = 3

peft_config = LoraConfig(
    task_type="SEQ_CLS",
    inference_mode=False,
    r=8,
    lora_alpha=16,
    lora_dropout=0.1
)
lr = 3e-4

# if any(k in model_name_or_path for k in ("gpt", "opt", "bloom")):
#     padding_side = "left"
# else:
#     padding_side = "right"

# tokenizer = AutoTokenizer.from_pretrained(model_name_or_path, padding_side=padding_side)
# if getattr(tokenizer, "pad_token_id") is None:
#     tokenizer.pad_token_id = tokenizer.eos_token_id

def collate_fn(examples):
    return tokenizer.pad(examples, padding="longest", return_tensors="pt")

train_dataset = DataLoader(tokenized_datasets['train'], shuffle=True, collate_fn=collate_fn, batch_size=batch_size)
val_dataset = DataLoader(tokenized_datasets['test'], shuffle=True, collate_fn=collate_fn, batch_size=batch_size)

optimizer = AdamW(params=model.parameters(), lr=lr)

# Instantiate scheduler
lr_scheduler = get_linear_schedule_with_warmup(
    optimizer=optimizer,
    num_warmup_steps=0.06 * (len(datasets) * num_epochs),
    num_training_steps=(len(datasets) * num_epochs),
)


model.to(device)
for epoch in range(num_epochs):
    model.train()
    for step, batch in enumerate(tqdm(train_dataset)):
        batch.to(device)
        outputs = model(**batch)
        loss = outputs.loss
        loss.backward()
        optimizer.step()
        lr_scheduler.step()
        optimizer.zero_grad()

    model.eval()
    for step, batch in enumerate(tqdm(val_dataset)):
        batch.to(device)
        with torch.no_grad():
            outputs = model(**batch)
        predictions = outputs.logits.argmax(dim=-1)
        predictions, references = predictions, batch["labels"]
        metric.add_batch(
            predictions=predictions,
            references=references,
        )

    eval_metric = metric.compute()
    print(f"epoch {epoch}:", eval_metric)

    torch.save(model.state_dict(), f'{PATH}/output/model_{epoch}.pt')