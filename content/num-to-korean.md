---
title: "금액-한글 변환 프로젝트 npm 배포하기"
description: "사내에서 사용 중이던 함수를 오픈소스로 만든 과정을 소개합니다"
date: 2020-04-26T13:35:43+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript", "opensource"]
---

#### 들어가며

오픈소스를 운영하는 게 오랜 버킷리스트였다. 하지만 항상 계획 과정에서 꿈이 너무 원대해지다 보니 목표를 감당 못해 무너지곤 했는데... 이번에는 정말 작은, 기능이 단 하나뿐인 함수를 운영하기로 했다. 숫자를 입력하면, 그 숫자를 한글로 바꿔주는 기능을 갖고 있다. 타입스크립트로 작성했고 npm에 발표한 상태다.

[github 저장소](https://github.com/huskyhoochu/num-to-korean)

[npm 패키지](https://www.npmjs.com/package/num-to-korean)

Runkit 예제를 함께 첨부한다.

<script src="https://embed.runkit.com" data-element-id="my-element"></script>
<div id="my-element">
const { numToKorean } = require(&quot;num-to-korean&quot;);

numToKorean(12345678);
</div>

#### num-to-korean 원리

숫자를 한글로 바꿀 때 

#### npm publish 과정

#### 현재까지의 성과
