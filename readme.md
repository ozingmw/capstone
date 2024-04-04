2024 캡스톤 디자인


+ 수정사항? - tokenize_function 함수 사용 이후 원본(text?)은 삭제해야하는듯?
+ 모델
    + transformer encoder model -> last hidden layer 이후 layer 추가하여 분류 작업 (EX: [KoBERT](./test/kobert/readme.md))
    + transformer encoder-decoder model -> prompt를 고정하여 label값만 나오도록 고정 & lora로 튜닝 (EX: [LLAMA](./test/llama/readme.md))