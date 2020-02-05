---
title: "Nodejs EventEmitter 뜯어보기"
description: "Node.js 소스 코드를 살펴보면서 EventEmitter가 어떻게 돌아가는지 확인합니다"
date: 2020-02-05T09:50:39+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript"]
---

#### 들어가며

Udemy의 [Learn and Understand NodeJS](https://www.udemy.com/course/understand-nodejs/) 강의를 정리하는 포스팅이다.


#### 동기와 비동기

순수 자바스크립트는 동기적으로 작동한다. 한 번에 하나의 프로세스만 실행시킬 수 있다. 자바스크립트를 비동기적으로 작동시키는 것은 자바스크립트 엔진 바깥을 감싸고 있는 호스팅 환경이다. 전통적으로는 브라우저가 유일한 호스팅 환경이었지만 자바스크립트 세계관이 확장되면서 이제는 Node.js 또한 호스팅 환경 중의 하나가 되었다.

Node.js가 비동기적으로 작동하는 것은 그 내부에 비동기 이벤트를 소화하기 위한 라이브러리(libuv)를 지니고 있기 때문이다. Node.js의 이벤트 루프는 libuv를 이용해 구현되었으며, 크게 여섯 단계의 페이즈를 순환하고 있다. 각 페이즈는 libuv를 통해 커널 혹은 쓰레드 풀에 인계했던 콜백 작업을 실행한다.

setTimeout, setInterval 등 타이머 작업 혹은 DB 연결, 파일 읽기/쓰기, HTTP 요청 등 모든 비동기 작업들은 libuv를 통해 스케줄링 되었다가 이벤트 루프의 순환 주기에 따라 호출된다.

#### 이벤트 컨셉

이벤트란 '어플리케이션 내에서 발생한 응답 가능한 사건' 이라고 표현할 수 있다. 이벤트는 Node.js에서만 사용되는 개념은 아니지만 Node에서는 특히 아키텍쳐의 근간을 이루는 개념이기에 중요하게 다뤄야 한다.

Node.js에서 발생하는 이벤트는 두 종류로 나눌 수 있다. 먼저 시스템 이벤트가 있는데, 이것은 libuv 라이브러리가 적용된 C++ 코어에서 처리하게 된다. 파일을 열고 닫거나 인터넷이 연결되거나 하는 영역이다. 자바스크립트 코어에서 처리되는 보다 상위 단계의 이벤트는 Node.js의 Event Emitter에서 관리된다.

자바스크립트 자체는 이벤트와 관련된 객체가 없다. Node.js가 그와 관련된 컨셉을 구현한 것이다.

#### 간단 구현

EventEmitter가 실제로 어떻게 작동하는지 간단한 형태로 구현해보자.

{{<highlight javascript "linenostart=1, linenos=inline">}}
function Emitter() {
  this.events = {};
}

Emitter.prototype.on = function(type, listener) {
  this.events[type] = this.events[type] || [];
  this.events[type].push(listener);
}
{{</highlight>}}

`Emitter` 함수 생성자는 `this.events`라는 객체를 초기화한다. 그리고 프로토타입에 `on`이라는 함수를 추가하는데 이 함수는 이벤트의 타입과 리스너를 인자로 받아 `Emitter` 객체에 추가하는 역할을 한다. 함수가 실행되면 객체 안에는 타입을 키로 받고 리스너의 배열을 값으로 받는 페어가 저장될 것이다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const emitter = new Emitter();

emitter.on('greeting', function() {
  console.log('Hello, Node!');
});

/*
* this.events = {
*   greeting: [
      function() { console.log('Hello, Node!') }
    ];
* }
*/
{{</highlight>}}

이렇듯 `on` 함수는 특정 상황에 실행시킬 리스너 함수를 `Emitter` 안에 등록한다는 의미를 갖고 있다. 그러면 이제 등록한 리스너를 호출할 `emit` 함수를 작성해보자.

{{<highlight javascript "linenostart=1, linenos=inline">}}
Emitter.prototype.emit = function(type) {
  if (this.events[type]) {
    this.events[type],forEach(function(listener) {
      listener();
    })
  }
}
{{</highlight>}}

`Emitter` 객체 안에 담겨 있는 타입-리스너 배열을 순회하며 리스너를 실행힌다. 위에서 작성한 실행 예제를 다시 가져오자.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const emitter = new Emitter();

emitter.on('greeting', function() {
  console.log('Hello, Node!');
}); // 이벤트 등록

emitter.emit('greeting'); // 이벤트 실행: 'Hello, Node!'
{{</highlight>}}

#### 실제 코드

최신 LTS 버전 기준 (v12.14.1) 저장소 주소를 링크해두겠다.

[node/events.js at v12.14.1](https://github.com/nodejs/node/blob/v12.14.1/lib/events.js)

핵심 원리는 거의 같지만 에러 핸들링, 메모리 릭 방지를 위한 장치들이 좀더 담겨있는 것을 볼 수 있다. 기본적인 최대 리스너 갯수를 10개로 제한하고 있으며, 리스너 갯수가 이를 초과하면 경고를 출력하는 것을 볼 수 있다.

[on](https://github.com/nodejs/node/blob/9622fed3fb2cffcea9efff6c8cb4cc2def99d75d/lib/events.js#L234) 함수는 `_addListener` 함수를 둘러싸고 있다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
EventEmitter.prototype.addListener = function addListener(type, listener) {
  return _addListener(this, type, listener, false);
};

EventEmitter.prototype.on = EventEmitter.prototype.addListener;

...

function _addListener(target, type, listener, prepend) {
  let m;
  let events;
  let existing;

  checkListener(listener);

  // 리스너를 등록하는 코드
  events = target._events;
  // 첫 번째 등록이라 events 변수가 undefined라면
  // 빈 객체를 생성해 할당한다
  if (events === undefined) {
    events = target._events = ObjectCreate(null);
    target._eventsCount = 0;
  } else {
    // To avoid recursion in the case that type === "newListener"! Before
    // adding it to the listeners, first emit "newListener".
    if (events.newListener !== undefined) {
      target.emit('newListener', type,
                  listener.listener ? listener.listener : listener);

      // Re-assign `events` because a newListener handler could have caused the
      // this._events to be assigned to a new object
      events = target._events;
    }
    existing = events[type];
  }

  // 최적화를 위해 리스너가 단 한 개일 때는 배열 구조를 사용하지 않고, 리스너가 한 개 이상이 되어야 배열 구조를 사용한다
  if (existing === undefined) {
    // Optimize the case of one listener. Don't need the extra array object.
    events[type] = listener;
    ++target._eventsCount;
  } else {
    if (typeof existing === 'function') {
      // Adding the second element, need to change to array.
      existing = events[type] =
        prepend ? [listener, existing] : [existing, listener];
      // If we've already got an array, just append.
    } else if (prepend) {
      existing.unshift(listener);
    } else {
      existing.push(listener);
    }
    
    // 메모리 릭 방지를 위해 기본 설정된 최대 리스너 갯수를 초과하게 되면 경고를 출력한다
    // Check for listener leak
    m = _getMaxListeners(target);
    if (m > 0 && existing.length > m && !existing.warned) {
      existing.warned = true;
      // No error code for this since it is a Warning
      // eslint-disable-next-line no-restricted-syntax
      const w = new Error('Possible EventEmitter memory leak detected. ' +
                          `${existing.length} ${String(type)} listeners ` +
                          `added to ${inspect(target, { depth: -1 })}. Use ` +
                          'emitter.setMaxListeners() to increase limit');
      w.name = 'MaxListenersExceededWarning';
      w.emitter = target;
      w.type = type;
      w.count = existing.length;
      process.emitWarning(w);
    }
  }

  return target;
}
{{</highlight>}}

[emit](https://github.com/nodejs/node/blob/9622fed3fb2cffcea9efff6c8cb4cc2def99d75d/lib/events.js#L173) 함수도 살펴보자.
{{<highlight javascript "linenostart=1, linenos=inline">}}
EventEmitter.prototype.emit = function emit(type, ...args) {
 const handler = events[type];

 // 상단에는 'error' 이벤트가 실행되었을 경우 stackTrace를 출력하는 코드 등이 담겨 있다
 ...

  // handler가 전혀 없는 경우 false 리턴
  if (handler === undefined)
    return false;

  // handler가 단 한 개인 경우, 배열 형태가 아니므로 즉시 출력
  if (typeof handler === 'function') {
    ReflectApply(handler, this, args);
  } else {
    // handler가 배열 형태인 경우, 전체를 순회하며 리스너들을 출력
    const len = handler.length;
    const listeners = arrayClone(handler, len);
    for (let i = 0; i < len; ++i)
      ReflectApply(listeners[i], this, args);
  }

  return true; // 정상 출력 후 true 리턴
}
{{</highlight>}}

#### 실행해보기

코드를 실행해보고 어떤 결과를 보여주는지 확인해보자.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const EventEmitter = require('events');

const emitter = new EventEmitter();

emitter.on('greet', function() {
  console.log('Node와의 첫 만남, 반갑습니다!')
})

console.log(emitter);
console.log(emitter.emit('greet'));

/*
* EventEmitter {
*  _events: [Object: null prototype] { greet: [Function] },
*  _eventsCount: 1,
*  _maxListeners: undefined
* }
* Node와의 첫 만남, 반갑습니다!
* true
*/
{{</highlight>}}

단 하나의 리스너가 등록된 경우, `_events` 객체는 하나의 greet 함수를 담고 있는 객체의 형태로 저장된다. 정상적으로 `emit` 함수가 실행되자 리스너 함수가 작동하고, `true`를 리턴한다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const EventEmitter = require('events');

const emitter = new EventEmitter();

// 동일한 리스너 함수를 12개 등록한다
emitter.on('greet', function() {
  console.log('Node와의 첫 만남, 반갑습니다!')
})

emitter.on('greet', function() {
  console.log('Node와의 첫 만남, 반갑습니다!')
})

...

console.log(emitter);
console.log(emitter.emit('greet'));

/*
* EventEmitter {
*   _events: [Object: null prototype] {
*     greet: [
*       [Function],   [Function],
*       [Function],   [Function],
*       [Function],   [Function],
*       [Function],   [Function],
*       [Function],   [Function],
*       [Function],   [Function],
*       warned: true
*     ]
*   },
*   _eventsCount: 1,
*   _maxListeners: undefined
* }
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* Node와의 첫 만남, 반갑습니다!
* true
* (node:43779) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 greet listeners added to [EventEmitter]. Use emitter.setMaxListeners() to increase limit
*/
{{</highlight>}}

너무 많은 리스너를 등록하면 경고 메시지를 출력하고, `_events` 객체에도 `warned`라는 플래그가 등록된 걸 볼 수 있다. greet 항목은 배열로 형태가 변경된 걸 볼 수 있다. 두 개 이상의 리스너가 등록되었기 때문이다.

#### 이벤트 상속

과거에는 `util.inherits` 함수로 상속을 수행했다. 자바스크립트에는 클래스 개념이 없으므로 부모 함수의 prototype 속성을 자식 함수의 prototype에 복사하는 식으로 상속을 구현했다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const EventEmitter = require('events');
const util = require('util');

// 인사를 출력하는 함수 선언
function Greetr() {
  this.greeting = 'Hello World';
}

// Greetr 함수는 EventEmitter를 상속받는다
// 곧 EventEmitter의 prototype 속성을 Greetr의 prototype에 복사한다
util.inherits(Greetr, EventEmitter);

// Greetr 함수의 prototype에 event emit 일으키는 함수 할당
Greetr.prototype.greet = function() {
  console.log(this.greeting);
  this.emit('greet');
}

// 함수 객체 선언
const greeter1 = new Greetr();

// greet 이벤트 등록
greeter1.on('greet', function() {
  console.log('Someone greeted!');
})

// greet 함수 호출
greeter1.greet();

// Hello World
// Someone greeted!

{{</highlight>}}

이렇게 하면 Greetr 함수 객체의 prototype이 EventEmitter가 되어 이벤트 메서드 호출이 가능해진다.

Greetr 함수 객체를 완전히 eventEmitter 객체와 동일하게 만들려면 this까지 복사하면 된다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
function Greetr() {
  EventEmitter.call(this);
  this.greeting = 'Hello World';
}
{{</highlight>}}

저 코드를 삽입하면 EventEmitter 함수를 Greetr의 this 환경에서 실행하는 셈이 되어 prototype뿐만 아니라 객체 상태 복사까지 이루어진다.


#### ES6 클래스

ES6 문법이 발표되면서 자바스크립트에서도 클래스 문법을 사용할 수 있게 되었다. 그래서 위에서 함수 형태의 상속 패턴을 클래스형 패턴으로 구현할 수 있다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
class Greetr extends EventEmitter {
  constructor {
    super();
    this.greeting = 'Hello World';
  }
}
{{</highlight>}}

`extends` 키워드가 prototype 복사를 수행하고 constructor(생성자 함수)의 `super` 함수가 인스턴스 복사를 수행한다.

#### 정리하며

Node.js가 어떻게 구성되어 있는지, 자바스크립트를 어떻게 실행시키고 있는 것인지 공부하고 있는 중이다. 더 나아가서는 비동기 프로그래밍, 에러를 올바로 처리하는 방법을 배우고 싶다. React, Vue 등 특정 라이브러리나 프레임워크가 지원해주는 방식만 사용해서는 비즈니스 로직이 UI와 단단히 커플링되는 결과만 낳게 되는 것 같다. 궁극적으로는 데이터 영역과 뷰 영역을 느슨하게만 결합시켜 하나의 웹 어플리케이션을 유지한 채로 다른 UI 라이브러리를 교체할 수 있는 수준에 이르고 싶다. 
