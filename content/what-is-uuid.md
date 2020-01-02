---
title: "[TIL] UUID란?"
description: "범용고유식별자 UUID에 대해 알아봅시다"
date: 2020-01-02T17:07:49+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["til"]
---

#### UUID란?

1줄 요약: 네트워크 상에서 고유성이 보장되는 id를 만들기 위한 표준 규약.

#### 조금 더 길게

###### 개요

주로 분산 컴퓨팅 환경에서 사용되는 식별자이다. 중앙관리시스템이 있는 환경이라면 각 세션에 일련번호를 부여해줌으로써 유일성을 보장할 수 있겠지만 중앙에서 관리되지 않는 분산 환경이라면 개별 시스템이 id를 발급하더라도 유일성이 보장되어야만 할 것이다. 이를 위해 탄생한 것이 범용고유식별자 UUID (Universally Unique IDentifier) 이다. 


###### 정의

UUID는 128비트의 숫자이며, 32자리의 16진수로 표현된다. 여기에 8-4-4-4-12 글자마다 하이픈을 집어넣어 5개의 그룹으로 구분한다.

```
예: 550e8400-e29b-41d4-a716-446655440000
```

###### 종류

UUID 버전은 1, 3, 4 및 5가 있다. 이 중 많이 쓰이는 것은 버전 1과 4이다. 버전 1은 타임스탬프를 기준으로 생성되며, 버전 4는 랜덤 생성이다. 버전 3, 5는 각각 MD5, SHA-1 해쉬를 이용해 생성하는 방식이다.


###### 쓰임새

다음 패키지를 이용하면 Node 환경에서 손쉽게 UUID를 사용할 수 있다.

<a href="https://github.com/kelektiv/node-uuid" target="_blank" rel="noopener noreferrer">kelektiv/node-uuid: Generate RFC-compliant UUIDs in JavaScript</a>

세션 ID를 발급해야 할 때, `uuid` 함수를 제공하면 된다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
  const session = require('express-session');
  const connectRedis = require('connect-redis');
  const redis = require('redis');
  const uuidv4 = require('uuid/v4');
  const next = require('next');

  let RedisStore = connectRedis(session);
  let redisClient = redis.createClient(6379, process.env.REDIS_CLIENT);

  // 기타 express 관련 설정 생략...

  app.use(
    session({
      store: new RedisStore({ client: redisClient }),
      secret: process.env.SESSION_SECRET,
      resave: true, // 수정된 적 없는 세션이라도 한번 발급된 세션은 저장 허용. 경쟁조건을 일으킬 수 있음
      rolling: true, // 새로고침이 발생할 때마다 세션 refresh
      saveUninitialized: true, // 초기화되지 않은 세션, 생성되었으나 한번도 수정되지 않은 세션을 저장할 것인지
      cookie: {
        maxAge: 60 * 60 * 1000,
      },
      genid: uuidv4, // UUIDv4를 이용해 session id 생성
    }),
  );
{{</highlight>}}


#### 참고

- <a href="https://ko.wikipedia.org/wiki/%EB%B2%94%EC%9A%A9_%EA%B3%A0%EC%9C%A0_%EC%8B%9D%EB%B3%84%EC%9E%90" target="_blank" rel="noopener noreferrer">범용 고유 식별자 - 위키백과, 우리 모두의 백과사전</a>
- <a href="https://docs.python.org/ko/3/library/uuid.html" target="_blank" rel="noopener noreferrer">uuid — RFC 4122 에 따른 UUID 객체 — Python 3.8.1 문서</a>
- <a href="https://medium.com/@jang.wangsu/ios-swift-uuid%EB%8A%94-%EC%96%B4%EB%96%A4-%EC%9B%90%EB%A6%AC%EB%A1%9C-%EB%A7%8C%EB%93%A4%EC%96%B4%EC%A7%80%EB%8A%94-%EA%B2%83%EC%9D%BC%EA%B9%8C-22ec9ff4e792" target="_blank" rel="noopener noreferrer">[iOS, Swift] UUID는 어떤 원리로 만들어지는 것일까.. - Clint Jang - Medium</a>
