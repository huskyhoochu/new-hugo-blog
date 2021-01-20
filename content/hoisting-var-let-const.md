---
title: "호이스팅과 var, let, const"
description: "자바스크립트 기본기이면서 매우 중요한 개념을 되짚어봅니다"
date: 2021-01-20T16:19:38+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript"]
---

참고 서적: [You don't know JS](http://aladin.kr/p/3oD3m)

#### 호이스팅 Hoisting

![hoister](/hoisting-var-let-const/hoist.jpg)
<p class="caption">건축이든 코딩이든 안전이 제일이다. (호이스트 크레인)</p>

자바스크립트 엔진(v8, 브라우저 등)이 코드를 컴파일하고 실행하는 과정을 설명한 글은 많으므로 자세한 과정(토크나이징, 추상 구문 트리, 바이트 코드...)을 밝히지는 않겠다. 다만 반드시 알아두어야 할 점은 엔진이 **선언과 실행을 구분해서 처리**한다는 점이다.

{{<highlight javascript>}}
var a = 1;
{{</highlight>}}

이 코드는 크게 `var a` 선언문과 `a = 1` 대입문으로 구분할 수 있다. 

먼저 컴파일 단계다. `var a`가 등장하면 컴파일러는 스코프 내에 변수 a가 존재하는지를 검색한다. 만일 a가 있다면 컴파일러는 이 선언문을 무시하고, a가 없다면 컴파일러는 변수 a를 스코프 컬렉션 내에 생성하도록 요청한다. 대입문은 실행 직전까지 실행되지 않고 방치된다.

코드 실행 시점이 되었을 때 엔진은 `a = 1` 대입문을 처리한다. 해당 변수가 현재 스코프 내에 있는지를 검색하여 발견하면 대입을 실행한다. 현재 스코프에 없다면 엔진은 바깥 스코프를 거슬러 올라가며 최종적으로 글로벌 스코프까지 검색하게 된다.

이렇게 컴파일 단계와 실행 단계에 선언문과 대입문이 따로 처리되다 보니, 마치 선언문이 코드 상단으로 '끌어올려지는' 듯한 효과가 발생한다. 이를 호이스팅이라 한다.

아래 코드를 보자.

{{<highlight javascript>}}
foo();

function foo() {
    console.log(a);
    var a = 2;
}
{{</highlight>}}

실행과 선언이 완전히 뒤집힌 코드다. 하지만 실행하면 에러가 발생하지 않는다. 선언과 실행이 서로 다른 단계에서 처리된다는 사실을 염두에 두면 명확하게 이해할 수 있다.

실행 시점에서 호이스팅이 일어난 코드는 다음과 같다.

{{<highlight javascript>}}
function foo() {
    var a;
    console.log(a); // undefined
    a = 2;
}

foo();
{{</highlight>}}

`function foo()`와 `var a`가 끌어올려져 각 스코프의 상단에 위치하게 된 후 코드가 실행되었다. 그래서 아무런 오류가 발생하지 않았다.

#### a = 2와 console.log(a)의 미세한 차이

엔진의 해석 과정을 보고 있자니 딴지를 걸고 싶어졌다. 서로 다른 두 코드를 각각 실행해 보자.

{{<highlight javascript>}}
// 첫 번째 코드
a = 2; // 실행됨
{{</highlight>}}

{{<highlight javascript>}}
// 두 번째 코드
console.log(a); // ReferenceError: a is not defined
{{</highlight>}}

두 코드 모두 `a` 값을 선언하지 않은 채 무작정 실행한 케이스다. 그런데도 첫 번째 코드는 실행되고, 두 번째 코드만 에러가 났다. 왜일까? 자바스크립트 엔진이 코드를 실행할 때 각 코드에 따른 검색 종류가 다르기 때문이다. 첫 번째 코드는 변수가 대입 연산자 왼쪽에 있을 때인 **LHS(Left-Handed Side) 검색**을 수행한 것이고, 두 번째 코드는 변수가 대입 연산자 오른쪽에 있을 때인 **RHS(Right-Handed Side) 검색**을 수행한 것이다.

LHS 검색은 `= 2` 대입 연산을 수행할 대상을 찾아 최상위 스코프에 도달할 때까지 검색을 거듭하고, 글로벌 스코프에 도달해서도 찾지 못하면 필요한 변수를 스스로 생성해버린다. 반면 RHS 검색은 첫 검색이 실패하면 그 자리에서 에러를 발생시킨다.

하지만 엄격 모드에서 코드를 실행하면 `a = 2` 또한 에러가 난다.

{{<highlight javascript>}}
'use strict';
a = 2; // ReferenceError: a is not defined
{{</highlight>}}


#### 함수 기반 스코프를 따르는 var 키워드

함수 기반 스코프는 스코프가 함수를 기준으로 생성된다는 뜻이다. 내포된 블록이 아무리 많이 만들어져도 그것이 하나의 함수 안에 속한다면 그 변수는 접근이 가능하다.

{{<highlight javascript>}}
function count() {
    var start = 3;
    while (start > 0) {
        console.log(start);
        var finish = start--;
    }
    console.log('---');
    console.log(finish);
}

count();
// 3
// 2
// 1
// ---
// 1
{{</highlight>}}

`finish` 변수는 while 블록 안에서 선언되었지만 그 바깥에서 접근이 가능하다. 모두가 `count` 함수 안에 있기 때문이다. 이처럼 `var` 키워드를 이용해 선언된 변수는 함수 기반 스코프를 따른다.

이 방식이 유연하고 편리해 보일 순 있지만 어떤 부분에선 불편을 일으킨다. `setTimeout`을 이용해 지연된 응답을 주는 코드를 만든다고 생각해 보자.

{{<highlight javascript>}}
function count() {
    for (var i = 0; i < 3; i++) {
        console.log(i);
        setTimeout(() => {
            console.log(i);
        }, i * 1000)
    }
}

count();
// 3
// 3
// 3
{{</highlight>}}

개발자는 `i` 값이 1초마다 하나씩 증가하면서 `console.log`가 출력될 것을 기대한다. 하지만 실제로는 마지막 출력값만이 출력된다. 타임아웃 블록 외부의 `i`는 순차적으로 실행되어 콜백 시간에 곱해지지만, 세 개의 콜백은 실행 시점에서 `i`를 봤을 떄 함수 스코프로 공유되는 최종 값 3을 다같이 넘겨받게 된다.

#### 블록 기반 스코프를 따르는 let, const

{{<highlight javascript>}}
function count() {
    for (let i = 0; i < 3; i++) {
        console.log(i);
        setTimeout(() => {
            console.log(i);
        }, i * 1000)
    }
}

count();
// 0
// 1
// 2
{{</highlight>}}

`i`를 `let` 키워드로 바꾸기만 해도 원하는 응답을 얻을 수 있다. 왜일까? 이제 `i`는 블록 단위로 공유되고 함수 단위로는 공유되지 않는다. 따라서 각 for문 블럭에 만들어진 각각의 콜백 함수가 모두 새로 증가된 값을 전달받게 되는 것이다.

처음에 만들었던 예시도 `let` 키워드를 적용하면 어떨까?

{{<highlight javascript>}}
function count() {
    let start = 3;
    while (start > 0) {
        console.log(start);
        let finish = start--;
    }
    console.log('---');
    console.log(finish);
}

count();
// 3
// 2
// 1
// ---
// ReferenceError: finish is not defined
{{</highlight>}}

while 블럭 안에서 선언된 `finish` 변수는 같은 `count` 함수 안에 있다고 해도 더 이상 바깥에서 참조할 수 없게 된다.

이것이 `var`와 `let`의 가장 큰 차이점이다.

`const`는 `let`과 동일하지만 한 가지 차이를 갖는다. 상수 키워드라서 한번 값을 할당하면 재할당이 불가능하다.



참고 서적: [You don't know JS](http://aladin.kr/p/3oD3m)
