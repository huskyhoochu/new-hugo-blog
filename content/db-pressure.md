---
title: "too many connections 에러 대응하기"
description: "사내에서 갑작스레 발생한 mysql too many connections에 대응한 방법을 기록합니다"
date: 2021-04-25T16:21:23+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["db"]
---

#### 에러 발생

최근 새로 이직한 사내에서는 실제 운영 DB와 조회용 DB를 RDS ReadReplica로 분리해두고 있었다. 그래서 어느 날 오전 ReadReplica에 접속했을 때 "too many connections" 에러가 나자 당황할 수밖에 없었다. 사내 인력들이 조회를 하기 위해서만 쓰는 DB 인스턴스가 왜 연결 최대치에 도닫환 것일까?

![connections](/db-pressure/connections.png)

#### 가설 세우기

모니터링 기록을 보니 지속적으로 여유 스토리지가 감소한 모습을 볼 수 있다. IT팀은 이런 가설을 세웠다. **"임시 테이블을 너무 많이 만드는 쿼리가 지속적으로 호출되고 있는 것은 아닐까?"**

현재 사내에서는 각종 데이터 시각화 지표를 보기 위해 [Redash](https://redash.io/) 라는 서비스를 사용하고 있었다. 이 서비스는 연결한 DB의 쿼리를 인터넷 상에 저장하여 공유할 수 있게 해 주고, 쿼리 결과는 물론 차트 시각화 결과까지 표현해주는 서비스이다. 이 서비스가 대시보드에서 지속적으로 쿼리 결과를 리프레시하는 것이 문제일까? 라고 생각했다.

하지만 실제로 리프레시 되는 쿼리는 존재하지 않았다.

#### 문제 해결

인터넷 검색을 통해 `SHOW PROCESSLIST` 라는 명령어를 찾아내었다. 이 명령어를 입력하면 현재 DB에 연결되어 있는 커넥션의 목록을 살펴볼 수 있다고 했다.

실제로 에러 발생 당시에 출력된 결과는 이랬다.

![process_list](/db-pressure/process_list.png)

전체 프로세스 리스트 중 특별히 눈에 띄는 쿼리가 하나 있었다. "with recursive parent..." 로 시작되는 쿼리 프로세스가 계속 남아 있었던 것이다.

아! 그제야 기억이 났다. 현재 사내 DB에서 구독 데이터가 자신을 호출한 구독의 id를 가지고 있을 거라는 가설을 세우고 재귀 쿼리를 작성해 실행했던 적이 있었는데 그 쿼리가 문제를 일으킨 것이 아닌가 싶었던 것이다.

당시에 작성했던 쿼리는 이랬다.

![recursive_query](/db-pressure/recursive_query.png)

어떤 row에 적인 post_parent 값을 이용해 그 다음 row를 계속 찾아 들어가는 쿼리를 구상했던 것인데, 이 쿼리가 재귀 호출을 멈추지 않아 모든 리소스를 다 점유해버렸던 것 같다.

결국 `KILL 9067` (재귀 프로세스 아이디)를 실행하자 DB 커넥션은 정상 상태로 되돌아왔다.

