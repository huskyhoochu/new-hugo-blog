---
title: "Go 언어를 이용한 백엔드 시스템 구조 설계하기"
description: "repository 패턴, 의존성 주입 패턴을 이용해 REST API 서버를 설계한 경험을 공유합니다"
date: 2021-11-04T07:18:29+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["golang"]
---

#### 들어가며

새 회사에 입사해서 지금까지 진행하고 있는 가장 큰 프로젝트는 커머스 서비스의 백엔드 시스템을 golang 기반으로 재설계하는 것이었다. 이때 가장 염두에 두었던 점은 작은 단위 기능들을 주제별로 분류해서 재사용할 수 있도록 하는 것, db 객체를 하나의 시작 포인트에서 주입받아 사용함으로서 일관된 구조를 유지하는 것이었다. 

#### 폴더 구조

#### repository

#### service

#### handler

#### db 의존성 주입

#### 마치며