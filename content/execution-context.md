---
title: "[코어 자바스크립트] 실행 컨텍스트"
description: "자바스크립트의 핵심 원리인 실행 컨텍스트를 알아봅시다"
date: 2019-12-03T08:54:54+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["book", "javascript"]
---

<div style="clear:left;text-align:left;"><div style="float:left;margin:0 15px 5px 0;"><a href="http://www.yes24.com/Product/Goods/78586788" style="display:inline-block;overflow:hidden;border:solid 1px #ccc;" target="_blank" rel="noopener noreferrer"><img style="margin:-1px;vertical-align:top;" src="http://image.yes24.com/goods/78586788/S" border="0" alt="코어 자바스크립트 "></a></div><div><p style="line-height:1.2em;color:#333;font-size:14px;font-weight:bold;">코어 자바스크립트 </p><p style="margin-top:5px;line-height:1.2em;color:#666;"><a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=&auth_no=274034" target="_blank" rel="noopener noreferrer">정재남</a> 저</p><p style="margin-top:14px;line-height:1.5em;text-align:justify;color:#999;">자바스크립트의 근간을 이루는 핵심 이론들을 정확하게 이해하는 것을 목표로 합니다. 최근 웹 개발 진영은 빠르게 발전하고 있으며, 그 중심에는 자바스크립트가 있다고 해도 결코 과언이 아니다. ECMAScript2015 시대인 현재에 이르러서도 ES5에서 통용되던 자바스크립트의 핵심 이론은 여전히 유효하며 매우 중요하다...</p></div></div>

#### 들어가며

자바스크립트를 제대로 알기 위해 인터넷 강의도 찾아보고, 해외 칼럼들도 읽긴 했지만 대부분 찾을 수 있는 건 파편적인 지식들이었다. 그러다 이 책을 알게 되었는데(여러분도 익히 접해보셨겠지만) 내가 목말라하던 부분들만 콕 찝어서 정리해주셨다. 주요 목차를 보면 이 책이 초심자에서 중급자로 넘어가려는 개발자를 위해 만들어졌다는 걸 알 수 있다.

이 포스트는 개인적으로 책을 보고 공부한 내용을 적어두는 것으로 하겠다.

#### 실행 컨텍스트

실행 컨텍스트는 자바스크립트 엔진이 실행할 코드에 제공하기 위해 환경 정보를 모아둔 객체이다. 환경 정보는 콜 스택에 쌓였다가 가장 나중에 쌓인 컨텍스트부터 순차적으로 실행된다. 실행 컨텍스트를 구성할 수 있는 주체는 전역 공간(window, global), 함수, 그리고 `eval()` 함수가 있다.

이 문장을 눈여겨보면 이런 사실을 짐작할 수 있다. 자바스크립트 코드는 가장 깊은 depth의 함수부터 전역을 향하여 실행된다. 내부의 코드는 자신이 곧장 접근 가능한 스코프의 환경만 알아볼 수 있다. 멀리 있는 환경은 콜 스택 밑바닥에 쌓여 있어 알지 못한다. 스코프가 닿지 않는 바깥에 값을 선언해 두고 왜 내부 함수가 읽지를 못할까 안달복달하던 이유가 바로 이 때문인 모양이다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
var a = 1

function A() {
    function B() {
        console.log(a) // -- ?
        var a = 3
    }
    B();
    console.log(a); // -- ?
}

A();
console.log(a); // 1이 나올까, 3이 나올까?
{{</highlight>}}


책의 예제를 가져와 봤다. 바깥을 둘러싸는 A 함수와 내부함수인 B 함수가 각각 전역변수 a를 호출한다. 결과는 어떻게 될까? 콜 스택에 각 함수 환경이 어떻게 쌓이는지를 보면 이해가 쉽다. (`G`는 `global`의 앞글자다)


```
|   |    |   |    |   |    | B |
|   | -> |   | -> | A | -> | A |
|___|    |_G_|    |_G_|    |_G_|
   
   |   |    |   |    |   |
-> | A | -> |   | -> |   |
   |_G_|    |_G_|    |___|
```

콜 스택에는 전역 컨텍스트부터 차례로 외부함수 A, 내부함수 B가 쌓인다. 이렇게 "B.A.G"이 완성된 후 자바스크립트 엔진은 가장 위에 쌓인 B부터 순차적으로 실행하기 시작한다. 

B가 실행될 때 B가 참조할 수 있는 환경은 자기 자신과 자기 바깥의 스코프, 즉 A 함수 블록까지다. A 바깥에 있는 `var a = 1`을 곧장 참조할 수는 없다. 따라서 참조 에러가 발생해야 한다. 하지만 6번째 줄에 a를 선언한 부분이 자신의 실행 컨텍스트에 기록되어 있기 때문에 에러 대신 `undefined`를 출력한다. 그럼 왜 3을 출력하지 않는가? `var a = 1`이라는 명령문은 엔진의 입장에서 `var a`와 `a = 1`, 즉 선언문과 할당문으로 나뉘어 보게 되는데, 자바스크립트는 **호이스팅(hoisting)**이라는 특이한 성질을 갖고 있어서 하나의 스코프 내에 있는 변수와 함수 정보를 실행 전에 미리 수집해 둔다. 학생이 시험 시간에 답안지를 훔쳐보는 것처럼 말이다. 그래서 B 함수는 a 변수의 존재를 실행 전에 미리 알아챈 것이다. 다만 할당문은  `console.log` 이후에 등장하므로 결과는 `undefined`가 된다.

B 함수가 실행된 후 호출되는 9번째 줄 출력문은 어떨까? A 함수는 자신의 바깥 스코프, 즉 전역 환경을 내다볼 수 있다. 따라서 여기서는 1이 출력된다. 마지막 13번째 줄 또한 1이 출력되고 끝난다. `a = 3` 이라는 할당문은 의미 없이 사라지고 말았다. B의 실행 컨텍스트에만 담긴 채로 가장 먼저 콜 스택에서 빠져나갔기 때문에, 전역 환경에는 영향을 주지 못한 것이다.

예에서 보듯 실행 컨텍스트는 코드 실행에 필요한 복잡한 정보를 담고 있다. 대표적으로는 세 가지가 있다.

1. `Variable Environment` (이하 V.E): 현재 컨텍스트 내의 식별자(함수, 변수)들에 대한 정보 및 외부 환경 정보. 선언 시점의 스냅샷이므로 **변경 사항은 반영되지 않음**

2. `Lexical Environment` (이하 L.E): 처음엔 V.E와 같지만 **변경 사항이 실시간으로 반영된다.**

3. `ThisBinding`: 식별자가 바라보는 대상 객체.

이 중 V.E와 L.E는 각각 내부에 `environmentRecord`와 `outer environment reference`를 지니고 있다. 제목 그대로 자기 환경의 식별자 정보와 바깥 환경의 식별자 정보를 말한다. "B.A.G" 예시처럼 함수가 중첩되어 있는 경우에는 이 기록들이 어떤 관계를 갖게 될까? 마치 연결 리스트처럼, 내부 함수의 `outer`는 외부 함수의 `record`가 되고, 다시 외부 함수의 `outer`는 전역 컨텍스트와 연결되는 하나의 체인을 형성하게 되는데 이를 스코프 체인이라고 부른다.


#### 참고

<a href="https://engineering.huiseoul.com/%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8%EB%8A%94-%EC%96%B4%EB%96%BB%EA%B2%8C-%EC%9E%91%EB%8F%99%ED%95%98%EB%8A%94%EA%B0%80-%EC%97%94%EC%A7%84-%EB%9F%B0%ED%83%80%EC%9E%84-%EC%BD%9C%EC%8A%A4%ED%83%9D-%EA%B0%9C%EA%B4%80-ea47917c8442?gi=fb08c135cf39" target="__blank" rel="noopener noreferrer">자바스크립트는 어떻게 작동하는가: 엔진, 런타임, 콜스택 개관 - Huiseoul Engineering</a>


