---
title: "자바스크립트 리터럴과 생성자"
description: "[JavaScript Patterns] 필기 정리"
date: 2019-03-18T23:40:48+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript"]
---

<div style="clear:left;text-align:left;"><div style="float:left;margin:0 15px 5px 0;"><a href="http://www.yes24.com/Product/Goods/5871083" style="display:inline-block;overflow:hidden;border:solid 1px #ccc;" target="_blank" rel="noopener noreferrer"><img style="margin:-1px;vertical-align:top;" src="http://image.yes24.com/goods/5871083/S" border="0" alt="자바스크립트 코딩 기법과 핵심 패턴 "></a></div><div><p style="line-height:1.2em;color:#333;font-size:14px;font-weight:bold;">자바스크립트 코딩 기법과 핵심 패턴 </p><p style="margin-top:5px;line-height:1.2em;color:#666;"><a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%bd%ba%c5%e4%be%e1+%bd%ba%c5%d7%c6%c4%b3%eb%c7%c1" target="_blank" rel="noopener noreferrer">스토얀 스테파노프</a> 저 / <a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%b1%e8%c1%d8%b1%e2" target="_blank" rel="noopener noreferrer">김준기</a>, <a href="http://www.yes24.com/SearchCorner/Result?domain=ALL&author_yn=Y&query=%ba%af%c0%af%c1%f8" target="_blank" rel="noopener noreferrer">변유진</a> 공역</p><p style="margin-top:14px;line-height:1.5em;text-align:justify;color:#999;">자바스크립트 코드를 한 단계 업그레이드하는 방법! 자바스크립트로 애플리케이션을 개발하는 최상의 방법은 무엇일까? 이 질문에 대한 대답으로 이 책은 다양한 자바스크립트 코딩 기법과 핵심 패턴, 최선의 관행을 소개한다. 또한 객체, 함수, 상속 그리고 자바스크립트 고유의 문제에 대한 해결책을 찾는 숙련된 개발자들...</p></div></div>

#### 들어가며

주력 언어를 파이썬에서 자바스크립트로 옮기면서 프로그래밍 기법이나 방법론이 정말 다양하구나를 느끼고 있습니다. 역사가 오래된 만큼 수많은 사람들이 자기 입맛대로 자바스크립트를 써 보겠다고 온갖 시도를 해 놨기 때문인데요. 자바스크립트를 정적 타입 언어로 탈바꿈시킨 타입스크립트부터 ES6, 7으로 판올림되며 거듭 추가되는 새로운 문법들과 몇 초에 한 개씩 추가된다는 npm 패키지들까지. 

그런 상황에서 저는 계속 '가장 정석적인 방법은 무엇일까?' '흔들리지 않는, 가장 교과서적인 설계 원칙은 뭐가 있을까?'를 많이 고민했습니다. 물론 정답은 없겠죠. 하지만 '무엇을 모르는지 모르는 단계'에서 '무엇을 모르는 지 아는 단계'로 나아가기 위해 최대한 많은 레퍼런스를 익혀야 한다고 생각하고 있습니다.

