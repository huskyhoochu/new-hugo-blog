---
title: "디스할 수 없는 너, this"
description: "자바스크립트에서 가장 불가사의한 키워드, 'this' 를 파헤쳐봅시다"
date: 2018-11-05T17:27:00+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["frontend", "javascript"]
---

#### 들어가며

정말 오랜만에 찾아왔네요. 여러분 모두 즐겁게 코딩하고 계신 거 맞죠?

![jihyo](./jihyo.jpg)
<p class="caption">저는 잘 지내요!</p>

한바탕 외주의 홍역을 치른 뒤에... 한시름 놓게된 채로 저는 다시 공부를 시작했습니다. 이제는 집중해서 한 가지를 깊이 파헤쳐야 할 때인 것 같습니다. 배운 것을 차곡차곡 쌓아간다는 마음가짐으로 계속해보겠습니다.

#### 혼돈의 this 키워드

오늘 다뤄 볼 주제는 자바스크립트의 `this` 키워드입니다. `this`는 함수가 주변 환경의 요소를 참조해야 할 때 유용하게 사용되는데요. 하지만 `this`는 종종 우리가 예상하는 바와 달리 엉뚱한 결과를 내놓기도 합니다. 소개글에도 말했듯 많은 개발자들이 자바스크립트를 객체 지향 언어로 받아들여서 `this` 또한 파이썬의 `self` 같은 '자기 자신' 이라고 넘겨 짚기 때문인데요. 저도 다르지 않았습니다. 하지만 `this`는 자기를 참조하라고 만들어진 게 아닙니다.

#### this != self

자동차 객체를 만들어 각각의 인스턴스에 속력을 설정하는 코드를 구성해 봅시다. `self`와 `this`가 완전히 똑같다는 전제 하에 파이썬과 자바스크립트로 각각 짜 보도록 하겠습니다.

{{<highlight python>}}
class Car:
  def __init__(self):
    self.speed = 0

  def __str__(self):
    return f'<Car speed={self.speed}>'


truck = Car()
truck.speed = 70

suv = Car()
suv.speed = 90

print(truck) # <Car speed=70>
print(suv) # <Car speed=90>
{{</highlight>}}


파이썬에서는 우리가 원하는 대로 `self`가 작동합니다. 클래스 선언부의 `__init__` 메서드에서 `self.speed`로 객체 프로퍼티를 초기화하면, 그 뒤에 인스턴스를 작성할 때 `truck.speed` 의 형식으로 프로퍼티에 접근할 수 있게 됩니다.

그렇다면 자바스크립트에서는 어떨까요?

{{<highlight javascript>}}
function car() {
  console.log(`car speed=${this.speed}`);
}

const truck = car;
truck.speed = 70;
truck(); // car speed=undefined
{{</highlight>}}


자바스크립트에는 클래스가 없기 때문에 (ES6에 클래스 문법이 소개되긴 했지만 어디까지나 모조품일 뿐입니다. 참고: <a href="https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Classes#Class_%EC%A0%95%EC%9D%98" target="_blank" rel="noopener noreferrer">MDN | Class 정의</a>) car 함수를 정의하고, 함수 객체를 생성해 속력 프로퍼티를 추가해보았습니다. 하지만 결과로 찍혀나오는 건 `undefined`로군요. 어째서일까요? `this`가 자기 참조 키워드라면 자기 자신의 속력으로 설정된 값을 출력할 만도 한데요.

사실 자바스크립트의 모든 함수는 객체이기 때문에, 함수 객체에 프로퍼티를 추가하면 기록이 남게 되어 있습니다.

{{<highlight javascript>}}
console.log(truck.speed); // 70
{{</highlight>}}


하지만 **`this.speed`는 무조건 `truck.speed`를 참조하는 게 아닙니다.** 그렇게 만드는 게 불가능한 건 아니지만 그러자면 `this`가 무엇인지, 어떻게 만들어지는지 규칙을 먼저 알아야겠죠.


#### this는 현재 실행 컨텍스트를 바인딩한 객체다

EcmaScript 2015 공식 명세서에서는 `this`를 기본 표현식의 하나로 정의하면서, 런타임 당시에 `ResolveThisBinding()`을 리턴한다고 되어 있습니다.

<a href="https://www.ecma-international.org/ecma-262/6.0/#sec-this-keyword" target="_blank" rel="noopener noreferrer">EcmaScript 2015 | The this Keyword</a>

> `ResolveThisBinding()`
>
> "The abstract operation ResolveThisBinding determines the binding of the keyword **this** using the <a href="https://www.ecma-international.org/ecma-262/6.0/#sec-lexical-environments" target="_blank" rel="noopener noreferrer">LexicalEnvironment</a> of the <a href="https://www.ecma-international.org/ecma-262/6.0/#sec-execution-contexts" target="_blank" rel="noopener noreferrer">running execution context.</a>"
>
> "추상 연산자 ResolveThisBinding은 실행 환경 컨텍스트의 렉시컬 환경을 사용하여 **this** 키워드의 바인딩을 결정한다."
>

쉽게 말해 `this`는 `this`가 호출되는 환경에 따라 무엇을 참조할지 결정한다는 뜻입니다. 헷갈리지 말아야 할 것이, **'선언'** 되는 환경이 아니라 **'호출'** 되는 환경에 따라 결정됩니다. 이제 새로운 질문이 떠오릅니다. "`this`를 달라지게 하는 환경이 대체 뭐가 있는 거지?"

#### 다섯가지 호출 환경

###### 전역에서 호출

첫 번째는 `this`를 전역 환경에서 호출하는 경우입니다. 전역에서 직접 `this`를 호출하거나 `this`가 지정된 함수를 호출하는 경우에 해당됩니다. 이때는 실행 컨텍스트가 전역을 참조하게 되면서 `this`에도 전역 객체가 바인딩됩니다.

{{<highlight javascript>}}
// 전역에서 직접 this 호출
console.log(this === window); // true (웹 브라우저)
console.log(this === global); // true (Node)

// 전역에서 this가 지정된 함수를 호출
function hello() {
	return this;
}

console.log(hello() === window); // true (웹 브라우저)
console.log(hello() === global); // true (Node)
{{</highlight>}}


하지만 이 경우에는 예외가 있습니다. 엄격 모드를 사용하면 전역에서 호출된 함수의 `this`는 `undefined`가 됩니다.

{{<highlight javascript>}}
'use strict'; // 엄격 모드
function hello() {
	return this;
}

console.log(hello()); // undefined
{{</highlight>}}

어째서일까요? 엄격 모드는 자바스크립트 함수 객체의 `Internal Slot` 데이터 중 `this` 참조 형태를 결정짓는 `[[ThisMode]]`값을 변경시키기 때문입니다. (참조: <a href="https://www.ecma-international.org/ecma-262/6.0/#sec-ecmascript-function-objects" target="_blank" rel="noopener noreferrer">EcmaScript 2015 | Function Objects</a>)

함수가 호출될 때 함수 객체의 내부 메서드 `[[Call]]` 이 작동하는데, 이때 `this`가 무엇을 참조할지 결정짓는 `OrdinaryCallBindThis` 라는 동작이 내부에서 실행됩니다. 이 동작은 `[[ThisMode]]`의 값이 무엇인지를 파악하여 판단을 내립니다. `[[ThisMode]]`에는 세 종류의 값이 들어갈 수 있는데, `lexical`, `strict`, `global`이죠.

`[[ThisMode]] === lexical`: 해당 함수의 렉시컬 환경이 `this`가 됩니다. (화살표 함수)

`[[ThisMode]] === strict`: `this`에 바인딩하도록 명시적으로 지정된 객체만을 `this`로 참조합니다. 위의 예에서 우리는 무엇을 `this`로 바인딩할지 정해주지 않았기 때문에 `undefined`가 출력된 셈이죠.

`[[ThisMode]] === global`: `this`에 바인딩할 객체가 지정되지 않아 `undefined`가 출력될 때, `this`가 전역을 참조하도록 합니다.


###### 객체의 프로퍼티로 호출

다음 경우는 객체 프로퍼티에 함수 레퍼런스를 연결한 경우입니다. 이 때 객체의 프로퍼티를 통해 함수를 호출하면 함수 레퍼런스가 연결된 객체가 `this`로 참조됩니다.

{{<highlight javascript>}}
function hello() {
	return this;
}

const obj = {
	a: 'greeting!',
  b: hello,
}

obj.b(); // { a: 'greeting!', b: [Function: hello] }
{{</highlight>}}


하지만 객체의 프로퍼티를 새로운 변수로 선언한 뒤 호출하면, `this`는 다시 전역을 참조하게 됩니다.

{{<highlight javascript>}}

const greeting = obj.b;

greeting(); // { window or global }
{{</highlight>}}


어째서일까요? 앞서 말했듯이 `this`는 어떻게 선언되었느냐가 아니라 어떻게 호출되었느냐에 따라 결정되기 때문인데요. `obj` 객체를 `this`로 바인딩하려면 `obj.b()` 처럼 객체 프로퍼티에 직접 접근해서 호출해야만 가능합니다. `greeting`이란 변수에 `obj.b`를 담게 되면 이 효과는 사라집니다. `obj.b`에 `hello`를 지정해도 함수의 값이 복사되는 게 아니라 레퍼런스가 담길 뿐이고, 이걸 다시 `greeting`에 지정해도 `obj.b`의 레퍼런스가 담기는 게 아니라 `hello` 함수의 레퍼런스가 담기기 때문입니다. `greeting`이 `hello` 함수와 같다면, 사실상 전역 호출과 다를 바가 없게 되죠. 이처럼 함수에 `this`를 무엇으로 바인딩할지 지정하진 않았지만, 특정 객체가 바인딩되리라 기대하는 방식을 **"암시적 바인딩implicit binding"** 이라고 합니다.


###### call, apply, bind를 이용한 호출

하지만 보다 명확히 무엇을 바인딩할지 지정하는 방법 또한 필요하겠죠. 명시적 바인딩을 도와주는 세 가지 함수가 있습니다. 먼저 `call`과 `apply`를 살펴봅시다.

{{<highlight javascript>}}
function multiple(c, d) {
	return this.a * this.b * c * d;
}

const num = { a: 2, b: 3 }

// call
// this로 사용할 객체, 그리고 함수의 파라미터를 차례로 입력
multiple.call(num, 5, 6); // 180

// apply
// this로 사용할 객체, 그리고 함수의 파라미터를 모은 배열 입력
multiple.apply(num, [7, 8]); // 336
{{</highlight>}}

두 함수의 기능은 사실상 같지만 함수의 파라미터를 받는 방식에 따라 골라서 쓸 수 있습니다. `call`을 사용하게 되면 파라미터를 단계별로 나누어 받을 수 있는 커링(currying)이 가능합니다. 이 부분은 따로 포스팅하는 게 좋겠군요.

`call`과 `apply`가 함수의 실행 결과를 리턴한다면, `bind`는 `this` 바인딩을 마친 함수 자체를 리턴합니다.

{{<highlight javascript>}}
const binded = multiple.bind(num);

binded(9, 10); // 540
{{</highlight>}}


###### new 생성자 호출

new를 이용해 함수를 호출하면, 그 함수의 `this`는 함수 객체 자신을 가리키게 됩니다.

{{<highlight javascript>}}
function pasta() {
	console.log(`pasta sauce=${this.sauce}`);
}

const menu = {
	sauce: 'cream',
    pasta: pasta,
}

menu.pasta(); // pasta sauce=cream (프로퍼티 호출)
const tomato = new pasta(); // pasta sauce=undefined (new 생성자 호출)
{{</highlight>}}


`pasta` 함수를 객체 프로퍼티로 호출한 경우, `this`는 `menu`를 참조하게 되고 소스는 크림으로 출력됩니다. new 생성자로 함수를 호출하면 `this`는 `pasta`라는 함수 객체 자신이 되므로 소스는 `undefined` 로 출력됩니다.


#### 마치며

지금까지 `this`가 만들어지는 다양한 경우를 모두 살펴봤습니다. 언뜻 보면 제멋대로인 것 같지만, 실은 자바스크립트만의 독특한 생성 원리에 따라 만들어지는 것이니만큼 자바스크립트의 내부 동작을 익히는 것이 `this`를 제대로 이해하기 위한 왕도가 아닐까 생각됩니다.

