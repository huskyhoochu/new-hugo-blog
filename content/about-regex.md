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

만약에 여러 문자를 동시에 찾고 싶다면 어떻게 해야 할까? 이 부분은 언어마다 조금씩 다른 문법으로 구현되어 있는데, 자바스크립트를 기준으로 설명하면 정규표현식 우측에 `g` 플래그를 붙이면 된다. 그러면 정규표현식은 전체 문장에 대해 전역 검사를 수행하게 된다.

{{<highlight javascript>}}
const greeting = "Hello, my name is John and my major is computer science.";

gretting.match(/my/g);
// ["my", "my"];

{{</highlight>}}

찾고자 하는 문자열을 그대로 입력하기만 한다면 정규표현식을 쓰는 의미가 없을 것이다. 이제부터는 조금씩 '패턴'을 이용한 검색을 수행해보도록 하자.

###### 일치하는 모든 문자 찾기

`.` 플래그는 치트키 같은 존재다. 찾고자 하는 문자열 중 어느 위치에나 `.`을 붙이면 일치하게 만들 수 있다.

버전 별로 잔뜩 나눠진 파일 목록이 있다고 가정하자. 자잘한 버전명에 상관 없이 원하는 파일을 모두 선택하도록 만들려면 어떻게 해야 할까?

```
// 전체 문장
design0.txt, docs.txt, design1.txt, design2.txt ...

// 정규표현식
design.
```

이제 `design0`.txt, docs.txt, `design1`.txt, `design2`.txt ... 가 모두 선택된다.

진짜 마침표를 찾아야 할 때는 어떡할까? 그때는 역슬래시 `\`를 붙여서 패턴이 아닌 진짜 마침표를 찾는다는 걸 알려주면 된다.

```
design.\.
```

그러면 `design0.`txt, docs.txt, `design1.`txt, `design2.`txt ... 까지가 선택된다.


#### 문자 집합 찾기

파일명 목록에는 단순히 숫자 말고도 이상한 문자가 섞여있을 수 있다. 파일명 목록 중에서 숫자로만 순서가 매겨진 파일명 전체를 선택하려면 어떻게 해야 할까?

이제 집합을 사용할 때가 됐다. 대괄호 `[]`로 특정 문자 범위를 묶으면 그 범위에 해당하는 글자를 선택할 수 있다.

```
// 전체 문장
design_수정.txt, design1.txt, design_진짜최종.txt, design2.txt, design3.txt ...

// 정규표현식
design[0-9]\.txt

```

선택되는 범위는 design_수정.txt, `design1.txt`, design_진짜최종.txt, `design2.txt`, `design3.txt` ... 가 된다.

`[0-9]`는 0에서 9에 해당하는 숫자 범위를 선택 가능하다. 이 범위는 문자로도 설정 가능한데, `[a-z]`는 소문자 영어, `[A-Z]`는 대문자 영어를 뜻한다.


#### 반복 찾기

#### 위치 찾기

#### 더 어려운 것들이 남아 있다

