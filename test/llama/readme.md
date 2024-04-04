# distilkobert 모델

총 학습 시간<br>
32G ram, 4090<br>
2시간

```파일 형식
├─capstone
│  │  
│  ├─ datasets
│  │    train.csv
│  └─ test
│     └─ llama
│          test.ipynb  
```

    run test.ipynb

Accuracy, Loss 결과<br>
0.456, 1.00

---
기타 내용
+ batch 크기 늘려서 학습 가능하지만 학습 도중 멈춤(온도 -> 쓰로틀링 문제?)