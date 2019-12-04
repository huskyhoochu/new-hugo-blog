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

###### 목차 (주관적으로 정리한 것)
1. 데이터 타입
2. 실행 컨텍스트
3. this
4. 콜백 함수
5. 클로저
6. 프로토타입

이 포스트는 개인적으로 책을 보고 공부한 내용을 적어두는 것으로 하겠다.

#### 실행 컨텍스트

실행 컨텍스트는 자바스크립트 엔진이 실행할 코드에 제공하기 위해 환경 정보를 모아둔 객체이다. 환경 정보는 콜 스택에 쌓였다가 가장 나중에 쌓인 컨텍스트부터 순차적으로 실행된다. 실행 컨텍스트를 구성할 수 있는 주체는 전역 공간(window, global), 함수, 그리고 `eval()` 함수가 있다.

이 문장을 눈여겨보면 이런 사실을 짐작할 수 있다. 자바스크립트 코드는 가장 깊은 depth의 함수부터 전역을 향하여 실행된다. 내부의 코드는 자신이 곧장 접근 가능한 스코프의 환경만 알아볼 수 있다. 멀리 있는 환경은 콜 스택 밑바닥에 쌓여 있어 알지 못한다. 스코프가 닿지 않는 바깥에 값을 선언해 두고 왜 내부 함수가 읽지를 못할까 안달복달하던 이유가 바로 이것 때문이었던 모양이다.



