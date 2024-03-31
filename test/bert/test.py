import os
import pandas as pd
from math import ceil
from tqdm import tqdm
from matplotlib import pyplot as plt

from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split

import torch
import torch.nn as nn
from torch.optim import AdamW

from transformers import BertTokenizer, BertModel
from transformers.optimization import get_cosine_schedule_with_warmup


PATH = os.path.dirname(__file__)

train_data = pd.read_csv(f"{PATH}/../../datasets/train.csv", index_col = 0, encoding = 'utf-8')

train_data.dropna(inplace = True)
train_data.drop(['감정_소분류','시스템문장1','시스템문장2','시스템문장3', '사람문장2', '사람문장3', '신체질환'], axis=1, inplace=True)
train_data.rename({'사람문장1':'text', '감정_대분류':'label'}, axis=1, inplace=True)


label_encoder = LabelEncoder()
train_data['label'] = label_encoder.fit_transform(train_data['label'])

X_train = train_data['text']
y_train = train_data['label']


tokenizer = BertTokenizer.from_pretrained('bert-base-multilingual-uncased')
model = BertModel.from_pretrained("bert-base-multilingual-uncased")


device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f'device: {device}')

class BERTClassifier(nn.Module):
    def __init__(self, bert, hidden_size=768, num_classes=6, dr_rate=None):
        super(BERTClassifier, self).__init__()
        self.bert = bert
        self.dr_rate = dr_rate

        if dr_rate:
            self.dropout = nn.Dropout(p=dr_rate)
        self.classifier = nn.Linear(hidden_size , num_classes)

    # def gen_attention_mask(self, token_ids, valid_length):
    #     attention_mask = torch.zeros_like(token_ids)
    #     for i, v in enumerate(valid_length):
    #         attention_mask[i][:v] = 1
    #     return attention_mask.float()

    def forward(self, encoded_input):
        # attention_mask = self.gen_attention_mask(token_ids, valid_length)
        bert_output = self.bert(**encoded_input)

        # output[0] = last_hidden_states, output[1] = pooler_output
        if self.dr_rate:
            out = self.dropout(bert_output[1])
        else:
            out = bert_output[1]
        return self.classifier(out)
    
bert_clssifier_model = BERTClassifier(model, dr_rate=0.5).to(device)


batch_size = 64
warmup_ratio = 0.1
num_epochs = 3
max_grad_norm = 1
log_interval = 200
learning_rate =  5e-5

no_decay = ['bias', 'LayerNorm.weight']

# 최적화해야 할 parameter를 optimizer에게 알려야 함
optimizer_grouped_parameters = [
    {'params': [p for n, p in bert_clssifier_model.named_parameters() if not any(nd in n for nd in no_decay)], 'weight_decay': 0.01},
    {'params': [p for n, p in bert_clssifier_model.named_parameters() if any(nd in n for nd in no_decay)], 'weight_decay': 0.0}
]

optimizer = AdamW(optimizer_grouped_parameters, lr=learning_rate) # optimizer
loss_fn = nn.CrossEntropyLoss() # loss function 

t_total = ceil(len(X_train) // batch_size) * num_epochs
warmup_step = int(t_total * warmup_ratio)

scheduler = get_cosine_schedule_with_warmup(optimizer, num_warmup_steps=warmup_step, num_training_steps=t_total)


X_train, X_val, y_train, y_val = train_test_split(X_train, y_train, test_size=0.05, random_state=42, stratify=y_train, shuffle=True)

train_acc_list = []
loss_list = []

for epoch in range(num_epochs):
    train_acc = 0.0

    bert_clssifier_model.train()

    epoch_iterator = tqdm(range(ceil(len(X_train) // batch_size)), desc=f"Epoch {epoch+1}")
    for index in epoch_iterator:
        optimizer.zero_grad()
       
        X_batch = tokenizer.batch_encode_plus(list(X_train[index*batch_size:(index+1)*batch_size]), padding='max_length', return_tensors='pt').to(device)
        y_batch = torch.tensor(list(y_train[index*batch_size:(index+1)*batch_size])).to(device)
        outputs = bert_clssifier_model(X_batch)

        loss = loss_fn(outputs, y_batch)
        loss.backward()

        torch.nn.utils.clip_grad_norm_(bert_clssifier_model.parameters(), max_grad_norm)
        optimizer.step()
        scheduler.step()

        _, max_indices = torch.max(outputs, 1)
        batch_accuracy = (max_indices == y_batch).sum().data.cpu().numpy()/max_indices.size()[0]

        train_acc += batch_accuracy
        train_acc_list.append(train_acc/(index+1))
        loss_list.append(loss.item())
        epoch_iterator.set_postfix(loss=loss.item(), acc=train_acc/(index+1))
    
    torch.save(bert_clssifier_model.state_dict(), f'{PATH}/epoch_{epoch+1}.pt')


plt.figure(figsize=(12, 4))
plt.subplot(1, 2, 1)
plt.plot(train_acc_list)
plt.title('Train Accuracy')

plt.subplot(1, 2, 2)
plt.plot(loss_list)
plt.title('Loss')

plt.show()