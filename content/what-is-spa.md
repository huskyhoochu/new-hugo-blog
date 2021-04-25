---
title: "SPA(Single Page Application) 이란?"
description: "너무 당연하게 사용해 온 SPA. 어떻게 작동하는 것일까요?"
date: 2021-02-16T14:00:23+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["web"]
---

#### 들어가며

일상생활에서 너무 당연하다는 듯이 사용하고 있어 이제는 웹 개발이 그 자체로 SPA 개발이 되어버린 기분이 든다. 하지만 'SPA가 대체 뭐니?' 하고 누군가 묻는다면 선뜻 대답할 수 있을까? 이번 포스팅은 그래서 준비했다.

참고 사이트:

[https://www.excellentwebworld.com/what-is-a-single-page-application/](https://www.excellentwebworld.com/what-is-a-single-page-application/)

[https://poiemaweb.com/js-spa](https://poiemaweb.com/js-spa)

[https://developer.mozilla.org/ko/docs/Web/API/History](https://developer.mozilla.org/ko/docs/Web/API/History)

[https://www.zerocho.com/category/HTML&DOM/post/599d2fb635814200189fe1a7](https://www.zerocho.com/category/HTML&DOM/post/599d2fb635814200189fe1a7)

#### 과거의 웹 사이트

전통적인 웹 사이트는 지금보다 문서 하나에 전달되는 파일의 용량이 적었다. 그래서 어떤 요소를 한번 클릭하면 완전히 새로운 페이지를 서버에서 전송해 주곤 했다. 그래도 상관 없었다. 그러나 현대에 이르러 점차 웹 사이트가 고도화됨에 따라 한 페이지에 해당하는 페이지 용량이 커져갔고, 매번 새로운 페이지를 전달하는 게 점점 버거워지게 되었다.

#### SPA란

이러한 문제를 해결하기 위해 등장한 것이 SPA(Single Page Application)이다. 이름에서도 파악할 수 있듯이, 어떤 웹 사이트의 전체 페이지를 하나의 페이지에 담아 동적으로 화면을 바꿔가며 표현하는 것이 SPA이다. 뭔가를 클릭하거나 스크롤하면, 상호작용하기 위한 최소한의 요소만 변경이 일어난다. 페이지 변경이 일어난다고 보여지는 것 또한 최초 로드된 자바스크립트를 통해 미리 브라우저에 올라간 템플릿만 교체되는 것이다.

#### SPA 라우팅

그렇다면 어떻게 SPA는 기존 전통적인 웹 사이트와 마찬가지로 브라우징이 가능한 것일까? 바로 HTML 5의 history api를 이용하기 때문이다. 서버로 요청을 전달하지 않고 자바스크립트 영역에서 history api를 통해 현재 페이지 내에서 화면 이동이 일어난 것처럼 작동하게 하는 것이다.

history api에는 다음과 같은 메서드가 있다.

1. `History.back()`: 세션 기록의 바로 뒤 페이지로 이동하는 비동기 메서드. 브라우저의 뒤로 가기를 누르는 것과 같은 효과를 낸다.
2. `History.forward()`: 세션 기록의 바로 앞 페이지로 이동하는 비동기 메서드. 브라우저의 앞으로 가기를 누르는 것과 같은 효과를 낸다.
3. `History.go()`: 특정한 세션 기록으로 이동하게 해 주는 비동기 메서드. 1을 넣어 호출하면 바로 앞 페이지로, -1을 넣어 호출하면 바로 뒤 페이지로 이동한다.
4. `History.pushState()`: 주어진 데이터를 세션 기록 스택에 넣는다. 직렬화 가능한 모든 JavaScript 객체를 저장하는 것이 가능하다.
5. `History.replaceState()`: 최근 세션 기록 스택의 내용을 주어진 데이터로 교체한다. 

이 api를 이용해 주소를 인위적으로 바꾸고, 서버로 페이지 전체를 요청하는 게 아니라 history.state에 담아둔 정보로 ajax 요청을 보내 화면을 갱신하는 것이다.

#### SPA 프레임워크가 하는 일

그러면 SPA 프레임워크로 유명한 Angular, React, Vue가 하는 일은 무엇일까? 세부적인 구현 개념은 다르겠지만 그 목적은 모두 SPA를 쉽고 확장성 있게 구현하는 것을 목표로 하고 있다. 이들은 Virtual DOM이라는 개념을 사용해 SPA를 구현한다. SPA의 문제점은 자바스크립트로 인한 DOM 조작이 빈번하게 일어나 브라우저의 성능을 저하시킨다는 것이다. Virtual DOM을 사용하는 프레임워크들은 실제 DOM 트리를 흉내 낸 가상의 객체 트리로 html 정보를 저장하고 있다가, 이 트리에 변경이 발생하면 모든 변화를 모아 단 한번 브라우저를 호출해 화면을 갱신하는 방법을 사용한다. 이렇게 하면 브라우저와의 불필요한 상호작용을 최소화하면서 인터렉티브한 웹 사이트를 만드는 것이 가능하다.

