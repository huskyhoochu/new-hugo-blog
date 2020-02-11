---
title: "함수형 사고와 Ramda.js로 기업 데이터 처리하기 (2)"
description: "클로저, 커링 등 함수형 사고에서 필요한 개념을 익히고 데이터 처리 과정을 살펴보겠습니다"
date: 2020-02-11T09:30:44+09:00
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

고객 정보가 담긴 객체가 있고, 거기서 특정 정보를 꺼내 사용한다고 가정해보자.

{{<highlight javascript "linenostart=1, linenos=inline">}}
import * as R from 'ramda';

const profile = {
  name: '홍길동',
  amount: 100000,
};

const profileName = R.propOr('이름 없음', 'name');
const profileBank = R.propOr('은행 없음', 'bank');

profileName(profile); // '홍길동'
profileBank(profile); // '은행 없음'
{{</highlight>}}

`propOr` 함수는 매개변수로 주어지는 객체에서 지정한 프로퍼티에 해당하는 값을 리턴한다. 만일 원하는 프로퍼티를 찾는데 실패하면 미리 지정해 둔 기본값을 출력한다. 이것은 사이드 이펙트를 관리하기 위한 함수형 프로그래밍의 주요 전략이다. 로직을 기획할 때 데이터의 불완전성에 대비해 유효성 체크를 일일이 설정하는 것이 아니라 입력값의 형태에 따라 출력을 담당하는 함수를 변경하는 것이다. 여기에 '카테고리'와 '펑터(Functor)' 개념이 등장하는데 다음의 블로그에 훌륭한 설명이 담겨 있다.

(참고: [어떻게 하면 안전하게 함수를 합성할 수 있을까? - Evan's Tech Blog](https://evan-moon.github.io/2020/01/27/safety-function-composition/))

###### cond

여러 if문이 중첩될 수 있는 상황을 가정해보자. 기업의 신용 등급에 따라 출력하는 메시지가 달라져야 하는 상황이다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
import * as R from 'ramda';

const getCreditMessage = R.cond([
  [R.equals('A'), R.always('상환 능력이 매우 우수함')],
  [R.equals('B'), R.always('상환 능력이 보통임')],
  [R.equals('C'), R.always('상환 능력이 떨어짐')],
  [R.T, R.always('신용 등급 산출되지 않음')],
]);

const companyA = {
  grade: 'A',
};

const companyB = {
  grade: 'B',
};

const companyC = {
  grade: '',
};

getCreditMessage(companyA.grade) // input 값이 A와 일치하면 조건문 배열 두 번째로 넣은 함수의 리턴 값을 반환한다: '상환 능력이 매우 우수함'
getCreditMessage(companyB.grade) // 상환 능력이 보통임
getCreditMessage(companyC.grade)
// 상위 조건문 배열에서 일치하는 값을 찾지 못하면
// default 성격으로 마지막에 배치해 둔 값을 반환한다: '신용 등급 산출되지 않음'
{{</highlight>}}

`cond` 함수는 중첩되는 조건과 원하는 결과값을 배열 구조로 전달받아 데이터를 처리하는 함수다. 개발자가 직접 상태를 다루며 분기 처리를 하는 게 아니라 조건과 결과까지 인자로 넘겨 로직을 원자화하고 결과 처리를 고계함수로 양도하는 것이다.


#### 기업재무데이터 더미에서 바늘 같은 데이터 끄집어내기

실제 재무데이터 구조를 모두 밝힐 수는 없지만, 규모가 매우 방대하며 데이터의 key-value가 가독성 있는 문자로 설정되어 있지도 않다. 예를 들면 '영업 이익'이라는 항목이라고 해서 'profit' 이라는 키를 갖는 게 아니라 'A003020310' 같은, 키마저 코드화된 채로 담겨 있는 모습을 볼 수 있다. 거기다 재무 데이터는 최신 년도 값만 추출하지 않고 3년 내지 5년 간의 변화를 모두 쿼리한 뒤 그래프로 표현하는 경우가 많다. 먼저 자료 구조부터 체크해보도록 하자.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const data = [
  {
    date: '2018',
    A12435322: 2400000,
    B49334893: 13440000,
    C34294929: 5500000,
  },
  {
    date: '2017',
    A12435322: 1200000,
    B49334893: 10040000,
    C34294929: 3300000,
  },
  {
    date: '2016',
    A12435322: 900000,
    B49334893: 9040000,
    C34294929: 1300000,
  },
]
{{</highlight>}}


수치화된 데이터가 매우많다. 친절하게 영어로 되어 있지 않음. 키는 전부 코드, 그리고 숫자뿐.

project를 이용하면 3개년치 리스트 중에 필요한 값만 간편하게 끄집어낼 수 있음.


#### 참고

<a href="https://www.youtube.com/watch?v=e-5obm1G_FY" target="_blank" rel="noopener noreferrer">JavaScript로 함수형 프로그래밍 배우기 - Anjana Vakil - JSUnconf</a>
