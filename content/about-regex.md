---
title: "[TIL] 정규표현식에 관하여"
description: "문자열 검색을 위한 만능 맥가이버 칼, 정규표현식을 알아봅니다"
date: 2020-09-07T13:25:57+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["regex", "til"]
---

#### 들어가며

개발을 시작할 떄 막연히 두려웠던 단어들이 있었다. 대표적으로 객체지향 설계, 디자인 패턴, 각종 알고리즘 기법들, 자바스크립트의 프로토타입 같은 것들이 있었다. 그중 특히 막막했던 것중에 '정규표현식'이라는 것도 있었다. 정규표현식이란 뭘까? 원하는 문자열을 선택하기 위해 공통적으로 약속된 패턴을 사용하는 것이다. 익숙해지면 편리하겠지만, 제대로 된 지식 없이 복잡한 특수문자가 나열되어 있는 모습을 보면 머리가 어지럽기만 할 뿐이다. 하지만 언제까지 피할 수는 없는 법. 정규표현식의 모든 것을 파헤치지는 못해도 기본적인 문법 정도는 배워보는 것이 좋을 것 같아 오랜만에 정리를 하기로 했다.

#### 문자 하나 찾기

가장 간단한 정규표현식은, 그냥 내가 찾고 싶은 문자 그대로를 입력하는 것이다.

```
// 전체 문장
> "Welcome to Korea!"

// 정규표현식
> Korea

// 결과
> "Welcome to `Korea`!"
```

자바스크립트를 통해 처리하면 다음과 같다.

{{<highlight javascript>}}
const hello = 'Welcome to Korea!';

hello.match(/Korea/);

// ["Korea", index: 11, input: "Welcome to Korea!", groups: undefined]
{{</highlight>}}

만약에 여러 문자를 동시에 찾고 싶다면 어떻게 해야 할까? 이 부분은 언어마다 조금씩 다른 문법으로 구현되어 있는데, 자바스크립트를 기준으로 설명하면 정규표현식 우측에 'g' 플래그를 붙이면 된다. 그러면 정규표현식은 전체 문장에 대해 전역 검사를 수행하게 된다.

{{<highlight javascript>}}
const greeting = "Hello, my name is John and my major is computer science.";

gretting.match(/my/g);
// ["my", "my"];

{{</highlight>}}

#### 문자 집합 찾기

#### 메타 문자 사용하기

#### 반복 찾기

#### 위치 찾기

#### 하위표현식 사용하기

#### 더 어려운 것들이 남아 있다

