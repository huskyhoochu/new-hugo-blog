---
title: "함수형 사고와 Ramda.js로 기업 데이터 처리하기 (2)"
description: "클로저, 커링 등 함수형 사고에서 필요한 개념을 익히고 데이터 처리 과정을 살펴보겠습니다"
date: 2020-01-17T09:30:44+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript book"]
---

#### 클로저, 커링, 부분 적용

###### 클로저

클로저(closure)란 내부 함수가 참조하는 외부 환경의 인자가 계속 기억되는 현상을 말한다. 자바스크립트 환경 안에서만 한정지어서 설명하자면, 내부함수 B가 실행될 경우 내부함수 B를 감싸고 있던 외부함수 A의 실행 컨텍스트가 종료된 이후에도 외부함수 A의 환경이 계속 호출 가능한 상태로 남는 것을 말한다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
// https://developer.mozilla.org/ko/docs/Web/JavaScript/Guide/Closures
function outer() {
  const name = 'john';

  function inner() {
    console.log(`Hello, ${name}!`);
  }

  inner();
}

outer(); // Hello, john!
{{</highlight>}}

실행 순서를 보면 `outer() -> inner()`로 진행되는 것을 알 수 있는데, `inner()`가 실행될 즈음이면 실행 컨텍스트에서 `outer()`가 종료되었을 텐데도 여전히 inner 함수는 스코프 체인 안에 `name` 변수를 기억하고 있다.

![closure](/functional-thinking-advanced/closure.png)

<p class="caption">VSCode로 디버그 모드를 켜면 inner 함수의 스코프를 볼 수 있다.</p>

<br />

클로저는 지연 실행(deferred execution)을 유도할 때 요긴하게 쓰인다. 여러 조건에서 재사용되는 함수를 만들고자 할 때, 외부 함수에 인자를 저장해두고 그 인자를 참조하는 내부 함수를 리턴하도록 만들 수 있다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
function makeEmployee(name) {
  return {
    getName() {
      return name;
    },
    greeting() {
      return `Hello, ${name}!`
    }
  }
}

const john = makeEmployee('john');
const susan = makeEmployee('susan');

console.log(john.getName()); // john
console.log(john.greeting()); // Hello, john!
console.log(susan.getName()); // susan
console.log(susan.greeting()); // Hello, susan!
{{</highlight>}}

참고: <a href="https://github.com/qkraudghgh/clean-code-javascript-ko/blob/master/README.md#%EA%B0%9D%EC%B2%B4%EC%97%90-%EB%B9%84%EA%B3%B5%EA%B0%9C-%EB%A9%A4%EB%B2%84%EB%A5%BC-%EB%A7%8C%EB%93%9C%EC%84%B8%EC%9A%94" target="_blank" rel="noopener noreferrer">객체에 비공개 멤버를 만드세요 - clean-code-javascript</a>

이렇게 만들면 `john, susan` 변수는 언제든 원하는 순간에 이름과 인사말을 출력할 수 있도록 실행을 지연시킨 함수가 된다. 클로저는 각 변수가 고유하기 때문에 서로에게 영향을 미치지 않아 정보 은닉, 캡슐화 또한 가능하다.


###### 커링

커링: 다인수 함수를 일인수 함수 체인으로 바꾸는 것

부분 적용: 주어진 다인수 함수 일부분의 인자만 전달하여 나머지 인자를 받아야 하는 함수로 리턴하는 것

#### Ramda.js로 적용하기 (토)

훨씬 다양한 고계함수들이 내장되어 있다.

가장 많이 쓰는 거

compose

propsOr

project


#### 기업재무데이터 더미에서 바늘 같은 데이터 끄집어내기 (일)

수치화된 데이터가 매우많다. 친절하게 영어로 되어 있지 않음. 키는 전부 코드, 그리고 숫자뿐.

project를 이용하면 3개년치 리스트 중에 필요한 값만 간편하게 끄집어낼 수 있음.