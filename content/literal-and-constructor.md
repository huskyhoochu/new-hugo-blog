---
title: "자바스크립트: 리터럴과 생성자"
description: "[JavaScript Patterns] 필기 정리 1"
date: 2019-03-21T14:50:48+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript"]
---

<div style="clear:left;text-align:left;"><div style="float:left;margin:0 15px 5px 0;"><a href="http://www.yes24.com/Product/Goods/5871083" style="display:inline-block;overflow:hidden;border:solid 1px #ccc;" target="_blank" rel="noopener noreferrer"><img style="margin:-1px;vertical-align:top;" src="http://image.yes24.com/goods/5871083/S" border="0" alt="자바스크립트 코딩 기법과 핵심 패턴 "></a></div><div><p style="line-height:1.2em;color:#333;font-size:14px;font-weight:bold;">자바스크립트 코딩 기법과 핵심 패턴 </p><p style="margin-top:5px;line-height:1.2em;color:#666;"><a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%bd%ba%c5%e4%be%e1+%bd%ba%c5%d7%c6%c4%b3%eb%c7%c1" target="_blank" rel="noopener noreferrer">스토얀 스테파노프</a> 저 / <a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%b1%e8%c1%d8%b1%e2" target="_blank" rel="noopener noreferrer">김준기</a>, <a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%ba%af%c0%af%c1%f8" target="_blank" rel="noopener noreferrer">변유진</a> 공역</p><p style="margin-top:14px;line-height:1.5em;text-align:justify;color:#999;">자바스크립트 코드를 한 단계 업그레이드하는 방법! 자바스크립트로 애플리케이션을 개발하는 최상의 방법은 무엇일까? 이 질문에 대한 대답으로 이 책은 다양한 자바스크립트 코딩 기법과 핵심 패턴, 최선의 관행을 소개한다. 또한 객체, 함수, 상속 그리고 자바스크립트 고유의 문제에 대한 해결책을 찾는 숙련된 개발자들...</p></div></div>

#### 들어가며

<자바스크립트 코딩 기법과 핵심 패턴>은 자바스크립트의 고유한 환경을 이용해 여러 디자인 패턴을 적용하는 법을 소개하는 책입니다. 자바스크립트에서 특히 중요하게 다뤄지는 개념인 프로토타입, 함수, 객체를 자바스크립트답게 소화하는 방법을 보여주는데 공을 들이고 있습니다. 연식이 된 책이라 CommonJS만을 다루고 있지만, 오히려 그렇기 때문에 최신 문법에만 익숙해진 시야를 넓히는데 도움이 되는 것 같습니다.

#### 리터럴? 생성자?

MDN에서는 리터럴을 이렇게 정의하고 있습니다.

> **KO:** *JavaScript에서 값을 나타내기 위해 리터럴을 사용합니다. 이는 말 그대로 스크립트에 부여한 고정값으로, 변수가 아닙니다.*
>
> **EN:** *You use literals to represent values in JavaScript. These are fixed values, not variables, that you literally provide in your script.*
> 
> **참고:** <a href="https://developer.mozilla.org/ko/docs/Web/JavaScript/Guide/Values,_variables,_and_literals#%EB%A6%AC%ED%84%B0%EB%9F%B4" target="_blank" rel="noopener noreferrer">문법과 자료형 - JavaScript | MDN</a>

위키백과는 이렇습니다.

> **KO:** *컴퓨터 과학 분야에서 리터럴(literal)이란 소스 코드의 고정된 값을 대표하는 용어다. (중략) 다음의 예제와 같이, 리터럴은 변수 초기화에 종종 사용된다.*
>
> **EN:** *In computer science, a literal is a notation for representing a fixed value in source code. (중략)  Literals are often used to initialize variables, for example, in the following, 1 is an integer literal and the three letter string in "cat" is a string literal:*
{{<highlight c>}}
int a = 1;
string s = "cat";
{{</highlight>}}
>
> **KO:** *자바스크립트는 리터럴 표기법을 이용해, 필요한 요소들을 열거하는 것만으로 객체를 만들 수 있다.*
>
> **EN:** *In ECMAScript (as well as its implementations JavaScript or ActionScript), an object with methods can be written using the object literal like this:*
{{<highlight javascript>}}
var empty_object = {} //빈 객체
var stooge = {
    first_name : "Jerome",
    last_name : "Howard"
}
{{</highlight>}}
>
> **참고:** <a href="https://ko.wikipedia.org/wiki/%EB%A6%AC%ED%84%B0%EB%9F%B4" target="_blank" rel="noopener noreferrer">리터럴 - 위키백과, 우리 모두의 백과사전</a>


예제를 보면 아시겠지만, '리터럴'은 변수에 할당하는 고정 형태의 값입니다. `int a` 우항에 놓이는 `1` 이나, `var empty_object` 우항에 놓이는 `{}` 와 같이 표기한 문자가 있는 그대로 자신을 나타내는 값이죠. 변수가 자신의 이름과 자신이 가리키는 값이 다를 수 있고, 얼마든지 값을 편집할 수 있는 것과 대조됩니다.

반면 생성자는 일종의 함수입니다. 객체의 초기화를 담당하는 함수죠. 리터럴과 달리 구현의 과정과 결과물은 함수 안에 숨겨져 있어 확인하기 어렵습니다. 어떤 인자가 들어가냐에 따라 사이드 이펙트를 발생시키기도 하죠.

{{<highlight javascript>}}
// Constructor example
var student = new Object();
var contries = new Array();
{{</highlight>}}

이 챕터의 결론은 간단합니다. **생성자 쓰지 말고 리터럴 쓰자!** 조금 허무하죠? 이제부터 하나씩 이유를 찾아봅시다.

#### 생성자보다 리터럴이 나은 이유

###### 리터럴이 더 짧고 간결함

여기엔 별다를 설명이 필요 없겠죠.

{{<highlight javascript>}}
// 생성자
var fruits = new Object();
var books = new Array();

// 리터럴
var animals = {};
var boats = [];
{{</highlight>}}


###### 자바스크립트 객체가 클래스 문법으로 생성된다는 오해 방지

자바스크립트는 프로토타입 기반 언어이며, 클래스가 없습니다. 하지만 `new` 생성자 함수가 클래스 기반 언어의 생성자와 문법이 같기 때문에 오해가 발생하기 쉽습니다. 본질적으로 `new`는 어떤 객체의 프로토타입을 상속받아 새 객체를 만드는 함수에 불과합니다.

추가: ES6에 추가된 자바스크립트 클래스 문법이 그저 '문법 설탕'에 불과하다는 의견은 들어보셨을 겁니다. 그런데 이 의견에 반발하는 흥미로운 포스트가 있군요. (**참고:** <a href="https://gomugom.github.io/is-class-only-a-syntactic-sugar/" target="_blank" rel="noopener noreferrer">ES6 Class는 단지 prototype 상속의 문법설탕일 뿐인가? - gomugom</a>)

###### 생성자 함수는 인자를 받을 수 있는데, 부작용(사이드 이펙트)의 우려가 있음

`Object()` 함수에 인자가 들어가면, 객체를 생성할 때 다른 내장 생성자에게 객체 생성을 위임하게 될 수 있습니다.

{{<highlight javascript>}}
// 경고: 모두 안티패턴이다

// 빈 객체
var o = new Object();
console.log(o.constructor === Object); // true

// 숫자 객체
var o = new Object(1);
console.log(o.constructor === Number); // true
console.log(o.toFixed(2)) // 1.00

// numObj.toFixed([digits])
// 어떤 숫자를 고정 소수점 표기법으로 표기해 반환한다. 매개변수는 자릿수를 뜻하며 범위는 0-20.

// 불리언 객체
var o = new Object(true);
console.log(o.constructor === Boolean); // true
{{</highlight>}}

만일 새 객체를 생성할 때 실수가 벌어진다면, 의도하지 않은 타입의 객체가 생성될 수 있겠죠.


###### 생성자를 안 쓰면 유효 범위 판별 작업도 발생하지 않음

생성자 함수로 객체를 만들면 지역 유효범위에 동일한 이름의 생성자가 있는지 `Object()`를 호출한 위치부터 전역 `Object` 생성자까지 인터프리터가 거슬러 올라가며 유효범위를 검사하게 된다고 합니다. *(솔직히 말해 이해를 못했습니다)*


#### 배열 리터럴 꿀팁

배열도 객체와 마찬가지로 `new Array` 생성자보다 `[]` 리터럴로 생성하는 게 좋습니다. 부작용을 방지하기 위해서인데요.

{{<highlight javascript>}}
var rats = [3];
console.log(rats); // [3]
var birds = new Array(3);
console.log(birds); // [<3 empty items>]
{{</highlight>}}

배열 리터럴로 배열을 만들 때 3을 넣으면 3이라는 값을 요소로 하는 배열이 만들어집니다. 반면 생성자로 배열을 만들면 3은 배열 요소의 갯수를 가리키게 되며, 3칸의 공간이 있는 빈 배열이 만들어집니다. 이때 만들어진 배열의 빈 공간은 `fill()` 함수로만 채울 수 있습니다. 비효율적이죠.

다만 배열 길이를 설정할 수 있다는 점을 이용해 트릭을 부릴 수는 있습니다. 0부터 10까지 연속되는 숫자를 담은 배열을 만들고 싶을 때, 배열 생성자를 써먹으면 편리합니다.

{{<highlight javascript>}}
var tigers = [...new Array(11).keys()];
console.log(tigers);
// [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
{{</highlight>}}

11칸짜리 빈 배열을 생성하고, 배열의 key들을 모은 배열을 선언한 뒤, 펼침 연산자로 배열의 모든 요소를 바깥 배열에 풀어놓습니다. 결국 0...11에 이르는 인덱스를 한데 모은 배열이 만들어지는 거죠.

#### 이 포스트와 같은 책을 리뷰한 글 목록

<a href="https://github.com/yoosoo-won/yoosoo-won.github.io/wiki/%EB%A6%AC%ED%84%B0%EB%9F%B4%EA%B3%BC-%EC%83%9D%EC%84%B1%EC%9E%90" target="_blank" rel="noopener noreferrer">리터럴과 생성자 · yoosoo-won/yoosoo-won.github.io Wiki</a>

<a href="https://itmining.tistory.com/73#footnote_link_73_2" target="_blank" rel="noopener noreferrer">[자바스크립트 패턴] ① 리터럴을 이용한 객체 생성 패턴 | 금광캐는광부</a>

<a href="https://joshuajangblog.wordpress.com/2016/08/21/javascript-pattern-literal-constructor/" target="_blank" rel="noopener noreferrer">Javascript Pattern 리터럴 & 생성자 – Captain Pangyo</a>

<a href="http://frontend.diffthink.kr/2016/05/blog-post_42.html" target="_blank" rel="noopener noreferrer">(BOOK) 2. 자바스크립트 패턴 - 리터럴과 생성자 - Frontend Development - Different</a>
