---
title: "자바스크립트 undefined와 typeof"
description: "값이 없는 변수와 선언되지 않은 변수의 차이점을 살펴봅시다"
date: 2021-01-20T12:00:43+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript"]
---

참고: [You don't know JS](http://aladin.kr/p/3oD3m)


#### 값이 없는 변수 VS 선언되지 않은 변수

값이 없는 변수는 스코프 안에 변수가 선언은 되었으나 값이 할당되지 않은 경우를 말하며, 선언되지 않은 변수는 아예 스코프 내에 존재하지 않는 경우를 말한다.

{{<highlight javascript>}}

var a;

a; // 값이 없는 변수, 'undefined'
b; // 선언되지 않은 변수, ReferenceError 'b is not defined'

{{</highlight>}}

값이 없는 변수는 `undefined`를 출력하지만, 선언되지 않은 변수는 레퍼런스 에러를 출력한다.

반면 이들의 타입을 체크하는 `typeof` 연산을 수행하면 결과는 달라진다.

{{<highlight javascript>}}

var a;

typeof a; // undefined
typeof b; // undefined

{{</highlight>}}

선언되지 않은 변수도 `typeof` 연산을 수행하면 에러가 발생하지 않고 `undefined`를 출력한다. 이는 `typeof`만의 safety guard라고 부른다.

이 guard 덕분에 우리는 전역변수의 존재 여부를 체크하는 안전한 코드를 작성할 수 있다.


{{<highlight javascript>}}
// Bad
if (GLOBAL_DEBUG) {
  console.log('start debug');
}

// Good
if (typeof GLOBAL_DEBUG !== 'undefined') {
  console.log('start debug');
}

{{</highlight>}}