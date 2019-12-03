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
1. 데이터 타입 - 깊은 복사, 얕은 복사
2. 실행 컨텍스트 - 스코프 체인
3. this - 실행 방법에 따라 달라지는 this 정리, `call, apply, bind`를 이용한 명시적 this 설정
4. 콜백 함수
5. 클로저
6. 프로토타입

