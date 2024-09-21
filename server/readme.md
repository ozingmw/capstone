# DayClover Backend

DB: mariaDB

DB Table:
+ User
    - user 출력하는 부분에서 사용자의 고유 user_id 까지 출력하기 때문에 이를 encoding 해서 보내는게 좋은거같음
+ Diary
    - ?
    - 임시 저장은 프론트에서 로컬스토리지로 관리하는게 좋음
+ Sentiment
    - CRUD에서 감정이 7,8가지로 일정하다면 DB를 사용하는 이유가 없을거같은데? -> 근데 다른 DB하고 상호작용을 해야함 -> 일단 제작하고 변경하는걸로
    - 
+ Question
    - ?
+ Quote
    - ?

기타:
+ 행운돼지 관련 DB가 필요할수도? -> db 트리거를 이용해서 서버에서 자체적으로 관리하면 될듯?
+ user disabled 관련된 로직 구현 안함(로그인시 disabled를 확인하여 계정을 지운 사람이였는지 등등)
+ 질문을 rag 이용해서 사용자의 최근 내용을 보고 질문을 생성하면 어떨까