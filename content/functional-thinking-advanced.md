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

개발자가 관리하던 '상태'를 프로세스나 언어 자체적인 영역 안으로 숨기는 것이 함수형 사고의 목표인 만큼, 클로저, 커링, 부분 적용은 함수형 사고에서 반드시 알고 넘어가야 할 개념이다. 

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

커링(currying)이란 인수가 여러 개인 함수를 인수 하나인 함수들의 체인으로 바꿔주는 방법이다. 특정한 함수를 지칭하는 것이 아니라 이 변형 과정 자체를 가리킨다. 예를 들어 `process(x, y, z)`를 `process(x)(y)(z)` 바꾸는 과정이 커링이다. 

<a href="https://medium.com/@kevincennis/currying-in-javascript-c66080543528" target="_blank" rel="noopener noreferrer">Currying in JavaScript - Kevin Ennis - Medium</a> 에 구현된 자바스크립트 커링 코드를 보면서 원리를 확인해보자.

번역 참고: <a href="https://edykim.com/ko/post/writing-a-curling-currying-function-in-javascript/" target="_blank" rel="noopener noreferrer">JavaScript에서 커링 currying 함수 작성하기 | 매일 성장하기 - 김용균</a>

{{<highlight javascript "linenostart=1, linenos=inline">}}
// 커링을 시도할 함수
// 부피를 구하기 위해 길이, 높이, 너비를 인자로 받아 모두 곱한 값을 리턴
function volume(l, w, h) {
  return l * w * h;
}

// 주어진 함수를 커링하는 함수
function curry(fn) {
  // 주어진 함수가 필요로 하는 전체 인자 길이를 저장해 둔다
  const arity = fn.length;

  // resolver라는 이름의 IIFE를 구성
  return (function resolver() {
    // 함수가 전달받은 모든 인자를 배열로 저장한다
    const memory = Array.prototype.slice.call(arguments);
  
    // resolver 함수는 다음의 익명 함수를 리턴한다
    return function() {
      // memory는 이전 프로세스에 저장된 인자들의 배열이다
      // 이것의 복사본을 만든다
      const local = memory.slice();

      // 커링으로 하나씩 들어오는 새 인자를 local 배열에 추가한다
      // apply로 받기 때문에 어느 시점에서 나머지 인자를 한꺼번에 부여해도 실행된다
      Array.prototype.push.apply(local, arguments);

      // next에 무엇을 할당할지는 필요로 하는 모든 인자를 모았는지에 따라 결정된다
      // local의 길이가 arity의 길이와 같아지면 모든 인자를 모았다고 보고 fn을 할당
      // 그렇지 않으면 아직 모아야 할 인자가 있다는 뜻이므로 resolver를 할당
      const next = local.length >= arity ? fn : resolver;

      // next에 할당된 함수를 this를 제공하지 않고 인자들만 제공해 실행한다
      // fn이 실행되면 결과값이 출력될 것이고, resolver가 실행되면 익명함수 자체가 리턴된다
      return next.apply(null, local);
    }
  }());
}

const curried = curry(volume);

const addLength = curried(10);
const addWidth = addLength(3);
const result = addWidth(7);
console.log(result); // 210
{{</highlight>}}

커링 또한 지연 실행을 위한 강력한 무기가 된다. 함수의 최종 결과를 한 시점에 받는 것이 아니라 필요한 인자가 확보될 때마다 함수에게 인자를 넘겨줌으로써 연산을 원하는 시점까지 미룰 수 있다.

###### 부분 적용

부분 적용은 커링과 거의 똑같은 개념으로 오해를 받곤 한다. 하지만 약간의 차이가 있는데, 부분 적용은 인수가 여러 개인 함수에서 일부분의 인자를 '부분 적용'해서 나머지 인수를 받도록 하는 함수를 도출하는 것이다. 즉 `process(x, y, z)`에서 `x`만을 적용해 `process(y, z)`를 전달받는 것을 말한다.

위에서 적용한 `curry` 함수는 커링과 부분 적용이 모두 구현된다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const curried = curry(volume);

const curryResult = curried(10)(7)(3); // 커링

const partial1 = curried(10);
const partialResult = partial1(7, 3); // 부분 적용
{{</highlight>}}


#### Ramda.js로 적용하기

위에 나열한 기초 개념을 모두 받아들여서 직접 고계함수를 작성해 운영해도 좋은 경험이 될 것이다. 하지만 미리 만들어진 고성능 라이브러리를 사용하는 것도 좋다. 오늘 소개할 <a href="https://ramdajs.com/docs/" target="_blank" rel="noopener noreferrer">Ramda.js</a>는 순수 자바스크립트만으로 구현된 함수형 프로그래밍 라이브러리이다. 제공되는 모든 함수가 커링과 부분 적용을 지원한다.

자주 사용되는 함수 일부분만 소개하도록 하겠다. 

###### PropOr

###### cond

###### Project


#### 기업재무데이터 더미에서 바늘 같은 데이터 끄집어내기 (일)

수치화된 데이터가 매우많다. 친절하게 영어로 되어 있지 않음. 키는 전부 코드, 그리고 숫자뿐.

project를 이용하면 3개년치 리스트 중에 필요한 값만 간편하게 끄집어낼 수 있음.


#### 참고

<a href="https://www.youtube.com/watch?v=e-5obm1G_FY" target="_blank" rel="noopener noreferrer">JavaScript로 함수형 프로그래밍 배우기 - Anjana Vakil - JSUnconf</a>
