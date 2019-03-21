---
title: "자바스크립트 리터럴과 생성자"
description: "[JavaScript Patterns] 필기 정리"
date: 2019-03-19T23:10:48+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript"]
---

<div style="clear:left;text-align:left;"><div style="float:left;margin:0 15px 5px 0;"><a href="http://www.yes24.com/Product/Goods/5871083" style="display:inline-block;overflow:hidden;border:solid 1px #ccc;" target="_blank" rel="noopener noreferrer"><img style="margin:-1px;vertical-align:top;" src="http://image.yes24.com/goods/5871083/S" border="0" alt="자바스크립트 코딩 기법과 핵심 패턴 "></a></div><div><p style="line-height:1.2em;color:#333;font-size:14px;font-weight:bold;">자바스크립트 코딩 기법과 핵심 패턴 </p><p style="margin-top:5px;line-height:1.2em;color:#666;"><a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%bd%ba%c5%e4%be%e1+%bd%ba%c5%d7%c6%c4%b3%eb%c7%c1" target="_blank" rel="noopener noreferrer">스토얀 스테파노프</a> 저 / <a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%b1%e8%c1%d8%b1%e2" target="_blank" rel="noopener noreferrer">김준기</a>, <a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%ba%af%c0%af%c1%f8" target="_blank" rel="noopener noreferrer">변유진</a> 공역</p><p style="margin-top:14px;line-height:1.5em;text-align:justify;color:#999;">자바스크립트 코드를 한 단계 업그레이드하는 방법! 자바스크립트로 애플리케이션을 개발하는 최상의 방법은 무엇일까? 이 질문에 대한 대답으로 이 책은 다양한 자바스크립트 코딩 기법과 핵심 패턴, 최선의 관행을 소개한다. 또한 객체, 함수, 상속 그리고 자바스크립트 고유의 문제에 대한 해결책을 찾는 숙련된 개발자들...</p></div></div>

#### 들어가며

주력 언어를 파이썬에서 자바스크립트로 옮기면서 프로그래밍 기법이나 방법론이 정말 다양하구나를 느끼고 있습니다. 역사가 오래된 만큼 수많은 사람들이 자바스크립트를 잘 써먹기 위해 온갖 시도를 해 놨기 때문인데요. 객체지향형 프로그래밍 문법, 함수형 프로그래밍 문법을 거침없이 소화해내는 ES5, 6 이후의 언어 표준, 현대의 자바스크립트 개발 환경을 만들었다고 해도 과언이 아닌 Node.js, 웹팩, 바벨, 그리고 자바스크립트를 정적 타입 언어로 탈바꿈시킨 타입스크립트, 몇 초에 한 개씩 탄생한다는 npm 라이브러리들까지. 

그런 상황에서 저는 계속 '가장 정석적인 방법은 무엇일까?' '흔들리지 않는, 가장 교과서적인 설계 원칙은 뭐가 있을까?'를 많이 고민했습니다. 물론 정답은 없겠죠. 하지만 '무엇을 모르는지 모르는 단계'에서 '무엇을 모르는 지 아는 단계'로 나아가기 위해 최대한 많은 레퍼런스를 익혀야 한다고 생각하고 있습니다.

<자바스크립트 코딩 기법과 핵심 패턴>은 자바스크립트의 고유한 환경을 이용해 여러 디자인 패턴을 적용하는 법을 소개해주고 있는 책입니다. 자바스크립트에서 특히 중요하게 다뤄지는 개념인 프로토타입, 함수, 객체를 자바스크립트답게 소화하는 방법을 보여주는데 많은 지면을 할애하고 있습니다. 연식이 된 책이라 CommonJS만을 다루고 있지만, 오히려 그렇기 때문에 최신 문법에만 익숙해져 있는 좁은 시야를 넓히는데 도움이 되는 것 같습니다.

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
> **KO:** *자바스크립트는 리터럴 표기법을 이용해, 필요한 요소들을 열거하는 것만으로 객체를 만들 수 있다. 이러한 표기법은 JSON에도 영감을 주었다.*
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

반면 생성자는 함수입니다. 객체의 초기화를 담당하는 함수죠. 리터럴과 달리 구현의 과정과 결과물은 함수 안에 숨겨져 있어 확인하기 어렵습니다. 어떤 인자가 들어가냐에 따라 사이드 이펙트를 발생시키기도 하죠.

{{<highlight javascript>}}
// Constructor example
var student = new Object();
var contries = new Array();
{{</highlight>}}

이 챕터의 결론은 간단합니다. **생성자 쓰지 말고 리터럴 쓰자!** 조금 허무하죠? 이제부터 하나씩 이유를 찾아봅시다.

#### 생성자보다 리터럴이 나은 이유

1. 리터럴이 더 짧고 간결함
2. 자바스크립트 객체가 클래스 문법으로 생성된다는 오해 방지
3. 생성자 함수는 인자를 받을 수 있는데, 부작용(사이드 이펙트)의 우려가 있음
4. 생성자를 안 쓰면 유효 범위 판별 작업도 발생하지 않음



#### 참고자료

<a href="https://asfirstalways.tistory.com/21" target="_blank" rel="noopener noreferrer">[그들이 쓰는 언어] 1. 리터럴 | _Jbee</a>

###### 이 포스트와 같은 책을 리뷰한 글 목록

<a href="https://itmining.tistory.com/73#footnote_link_73_2" target="_blank" rel="noopener noreferrer">[자바스크립트 패턴] ① 리터럴을 이용한 객체 생성 패턴 | 금광캐는광부</a>

<a href="https://joshuajangblog.wordpress.com/2016/08/21/javascript-pattern-literal-constructor/" target="_blank" rel="noopener noreferrer">Javascript Pattern 리터럴 & 생성자 – Captain Pangyo</a>

<a href="http://frontend.diffthink.kr/2016/05/blog-post_42.html" target="_blank" rel="noopener noreferrer">(BOOK) 2. 자바스크립트 패턴 - 리터럴과 생성자 - Frontend Development - Different</a>
