---
title: "Go 언어를 이용한 백엔드 시스템 구조 설계하기"
description: "repository 패턴, 의존성 주입 패턴을 이용해 REST API 서버를 설계한 경험을 공유합니다"
date: 2021-11-15T07:18:29+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["golang"]
---

#### 들어가며

새 회사에 입사해서 지금까지 진행하고 있는 가장 큰 프로젝트는 커머스 서비스의 백엔드 시스템을 golang 기반으로 재설계하는 것이었다. 이때 가장 염두에 두었던 점은 작은 단위 기능들을 주제별로 분류해서 재사용할 수 있도록 하는 것, db 객체를 하나의 시작 포인트에서 주입받아 사용함으로서 일관된 구조를 유지하는 것이었다. 

#### 폴더 구조

폴더 구조는 크게 여섯 가지로 나뉘어 있다. DB 데이터 스키마와 응답 객체를 정리해 두는 model, 각 테이블의 단위 기능을 관장하는 최소 단위 기능 집합체인 service, 이 service들을 인터페이스로 정의해 두는 repository, 여러 repository를 조합해 비즈니스 로직을 만들어내고, 직접 http 요청을 수행하는 handler, 이들을 한데 묶는 router와 마지막으로 router를 통해 db 객체를 주입하는 db 폴더가 그것이다.

전체 구조를 간단하게 나열하자면 다음과 같다.

```md
|
- db // db 객체 저장
- handler // 비즈니스 로직, http 요청
- model // 데이터 스키마 저장
- repository // 각 service 단위기능을 interface로 정의
- router // handler 라우팅
- service // 테이블 별 단위 기능 정리
- main.go
```

#### model


#### service

#### repository

#### handler

#### router

#### db 의존성 주입

#### 마치며