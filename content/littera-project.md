---
title: "9월엔 블로그 운영이 뜸해지겠습니다"
description: "새로운 외주 프로젝트, 새로운 삽질의 시작"
date: 2018-09-04T13:18:00+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["diary"]
---

#### 원래 9월의 계획

원래는 파이썬 3.7 발표 기념으로 **파이썬 표준 라이브러리 파헤치기 특집**을 기획중이었습니다. 이를테면
<a href="https://docs.python.org/ko/3.7/library/itertools.html"
target="_blank" rel="noopener noreferrer">itertools</a>나
<a href="https://docs.python.org/ko/3.7/library/functools.html"
target="_blank" rel="noopener noreferrer">functools</a>,
<a href="https://docs.python.org/ko/3.7/library/collections.html"
target="_blank" rel="noopener noreferrer">collections</a> 같은 것들이요.
오랜만에 뒤적거리다 보니까 파이썬이라는 언어 자체가
<a href="https://www.python.org/dev/peps/pep-0206/#batteries-included-philosophy"
target="_blank" rel="noopener noreferrer">"batteries included"</a>
철학을 갖고 있어서 그런지 정말 온갖 기능이 다 내장되어 있었더라구요. 자바스크립트에서는 웬만해선 다 패키지 설치해야 하는 기능들까지...
그래서
<a href="https://underscorejs.org" target="_blank" rel="noopener noreferrer">underscore.js</a>의 계보를 잇는
<a href="https://lodash.com" target="_blank" rel="noopener noreferrer">lodash</a>의
기능들과 파이썬 표준 라이브러리의 기능들을 비교해보고 싶었거든요.

하지만 얼떨결에! 자본주의의 부름을 받고 새로운 프로젝트 **"공간문학"**을 시작하게 되었답니다! 😙😙💵😘

이제 막 개발에 들어간 프로젝트라 자세한 설명은 못 드리지만, 소개란에 쓴 대로 **"고객이 아닌 주인장 취향에 맞춘 추천 도서 발송"**
이 서비스의 핵심입니다. 마치 방탈출 게임을 하듯 의도적으로 매끄럽지 못한 소통 흐름을 만드는 게 사이트의 컨셉이기도 하구요.

디자이너 분도 따로 계시고, PM 역할을 하는 분도 계셔서 저는 작업에만 집중하면 될 텐데... 인생이 그렇게만 흘러가지는 않더라구요!
(갑자기 감감무소식이던 예전 프로젝트에서 A/S 요청도 오고 말이죠! 이력서도 넣어야 하는데...)


#### 기술 스택

개발 관련해서는 모든 게 제맘대로인 상황이라! 이번엔 좀 거창하게 만들어보려고 하고 있습니다. 프론트엔드는 리액트를 가져가지만
이번에는 디자인 패턴, 테스팅, 코드 스플리팅에 중점을 두려고 하고 있구요, 백엔드는 파이썬의
<a href="https://github.com/channelcat/sanic" target="_blank" rel="noopener noreferrer">sanic</a>
프레임워크를 사용하려고 합니다. 파이썬 비동기 프로그래밍 모듈인
<a href="https://docs.python.org/ko/3/library/asyncio.html"
target="_blank" rel="noopener noreferrer">asyncio</a>
를 이용한 플라스크 느낌의 프레임워크인데요. 파이썬으로는 장고만 쓰다가 플라스크 계열의 텅 빈 프레임워크를 다뤄는 봐야겠다 싶어 선택했습니다
이미 이전 프로젝트에서 Go 언어 백엔드 프레임워크인
<a href="https://echo.labstack.com" target="_blank" rel="noopener noreferrer">echo</a>를
써본 적이 있어서 sanic의 성능에 기대를 건다기보단 **"이미 다 만들어져 있는 장고에서 벗어나 스스로 설계하는 경험을 쌓자!"**는 게 목적이에요.

덧붙여 Redis 캐싱도 넣을 거고, 메시지 push 알림 기능도 구현해 볼 생각입니다. 결제 서비스는 당연히 들어가게 되겠고...
무엇보다 이번에는 인프라 구축을 제대로 해보고 싶다는 생각이 있어요. 그래서 각각의 프로세스들을 docker 컨테이너로 만들어서 관리해보면 어떨까?
구상하고 있는데 지금으로선 너무 처음부터 완벽하게 할 수는 없겠다 싶긴 해요.

#### 그래도 일주일에 한 편은 올릴게요!

아무리 바빠도 블로그를 놓아버리면 블로그를 만든 의미가 없어지니까... 우선은 파이썬 표준 라이브러리 꿀팁 정리를 다음주 중으로 올려보려고 합니다.
그때까지 잘 지내세요 여러분! 안녕~
