---
title: "2018년 상반기를 회고하며"
description: "수료증을 받았는데 왜 취업을 못하니... 괴상하게도 작년은 운수가 좋더니만..."
date: 2018-08-14T06:32:00+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["diary"]
---

#### 회고... 랄까요

2018 상반기에 한 일을 간단히 나열해보겠습니다.

###### 1월

패스트캠퍼스 웹 프로그래밍 스쿨을 수료했습니다.
1인 스타트업 회사에 잠깐 들어가 홈페이지 외주 제작을 하려고 했으나 무산되었습니다.

###### 2월, 5월
대학 친구를 위해 집단 참여형 블로그를 제작해 주었습니다. 친구가 학원 강사를 시작하면서 운영이 멈추었네요.
(<a href="https://zamsee.com" target="_blank" rel="noopener noreferrer">웹진 잠시 | 잠시, 도시를 지켜보는 사람들의 이야기</a>)

<br />

| 기술 스택 | 이름 | 배운 점 |
|---------|-----|-----|
| **Frontend** | Vue.js | Component 개념 이해 |
| **CSS** | Bootstrap 4 | Flexbox 개념 익힘 |
| **Backend** | Django | AbstractBaseUser 모델 사용 |
| **Deploy** | AWS EB | Docker를 이용해 Frontend & Backend 캡슐화하여 배포<br />ebextension을 사용하여 자동 HTTPS 리다이렉트 |

<br />

###### 3-4월
아는 분 성지순례 여행사 홈페이지를 제작해 드렸습니다. 대표님이 나이가 많으셔서 컴퓨터를 못 다루시는지 운영을 못 하고 계시네요.
(<a href="https://seoulmariacenter.net" target="_blank" rel="noopener noreferrer">서울마리아센터 | 신앙의 현장으로 순례자를 이끄는 성지순례 여행사</a>)

<br />

| 기술 스택 | 이름 | 배운 점 |
|---------|-----|-----|
| **Frontend** | Vue.js | 단방향 데이터 흐름 이해, Vuex & Vue router 익숙해짐 |
| **CSS** | Bootstrap 4 | sticky 속성을 이용한 고정 헤더, fixed 속성을 이용한 to-top 버튼 구현 |
| **Backend** | Django | auth 모델 없이 임시 번호만으로 예약 조회할 수 있는 시스템 설계 |
| **Deploy** | Cafe24 | 리눅스 클라우드 서버에 직접 배포<br />Let's Encrypt를 이용한 무료 SSL 인증서 발급 |

<br />

###### 6월
아는 형의 문학 매거진 사이트를 제작해 주었습니다. 구글 / 네이버 SEO 적용에 많은 정성을 들였습니다. 필진 섭외가 쉽지 않아 애를 먹는 중입니다.
(<a href="https://www.somethingmore.co.kr" target="_blank" rel="noopener noreferrer">Something More | 소설이 아닌, 소설 너머의 문학</a>)

<br />

| 기술 스택 | 이름 | 배운 점 |
|---------|-----|-----|
| **Frontend** | React | 순수 자바스크립트를 공부해야 한다는 생각에 갈아탔음.<br />Vue와 달리 router나 state management를 알아서 선택해야 하는 방식이 익숙지 않았음 |
| **CSS** | Bootstrap 3 | 구입한 테마 파일이 부트스트랩 3여서 어쩔 수 없이 사용 |
| **Backend** | echo | golang 에서 나온 백엔드 프레임워크<br />goroutine으로 비동기 이메일 전송 액션 등을 너무 손쉽게 구현했음 |
| **Deploy** | Cafe24 | 위와 동일 |

<br />

###### 7월
블로그를 제작했습니다. Gatsby를 사용하면서 graphQL을 다루게 되었습니다. <a href="https://zeit.co/now" target="_blank" rel="noopener noreferrer">Now</a>라는 배포 업체를 알아냈습니다.
무료 플랜에서도 커스텀 도메인을 사용할 수 있고, 자동으로 HTTP/2를 지원해줘요!
단지 배포한 코드 리소스가 공개될 뿐인데, 어차피 블로그니까 크게 상관 없었습니다.

<br />

| 기술 스택 | 이름 | 배운 점 |
|---------|-----|-----|
| **CMS** | Gatsby | Gatsby는 graphQL로 SSR을 구동하고 빌드할 때는 자체 파일 범위 안에서 XHR을 구현함 |
| **CSS** | styled-component | 그냥 css 파일을 적용하는 것보다 styled-component를 쓰는 게 퍼포먼스가 좋다는 걸 알게 됨 |
| **Deploy** | Now | 커스텀 도메인을 쓰는데도 무료! static 웹사이트뿐만 아니라 node와 Docker 배포까지 지원한다! |

<br />

#### 잘못한 점과 잘한 점

수료를 1월에 마쳤는데 어느 새 8월이군요. 다른 수료생 친구들처럼 앞뒤 안 가리고 기업들에 처들어갈 걸 후회가 밀려옵니다.
성격이 소극적이고 선뜻 위험한 도전을 못하는 편이어서 '좀 더 준비해야 돼!' 라는 생각이 앞섰던 것 같아요.
컴퓨터공학 전공 지식도 어느 정도 공부하고 프론트엔드 지식도 쌓고, 알고리즘도 배운 다음에 지원해야지 결심했는데 막상 돌아보니 이런저런 프로젝트 만들어주느라 허송세월했나... 후회가 되기도 해요.

그래도 잘한 점이라면 github 잔디밭을 잘 채웠다, 아직까지 결과가 좋은 건 없지만 실전 풀스택 프로젝트를 3건이나 해냈다, 이런 게 있네요.
어떤 한 분야를 깊이 파헤치지는 못했지만 웹 프로젝트를 기획, 개발, 배포, 홍보하는 프로세스를 전부 혼자 해 보면서 1인 개발에는 도가 튼 것 같습니다.
최근에는 <a href="http://www.yes24.com/24/Goods/30741673" target="_blank" rel="noopener noreferrer">'<팀을 위한 git>'</a> 이라는 책을 읽으면서 '이슈 기반 버전관리' 방식에 따라 개발하고 있어요.
이전까지는 스크럼이나 할 일 관리는 구글 문서나 트렐로에 관리하고 git은 git대로 따로 굴리느라 정신이 없었는데 이제는 두 가지 영역을 이슈 트래커로 한꺼번에 처리할 수 있어서 좋습니다.

#### 하반기에는?

일단 블로그 포스팅을 신나게 달릴 생각입니다. 9월에는 사회적 기업 홈페이지 한 건을 제작할 예정이고 알.고.리.즘을 진짜로 공부할 거에요! ㅜㅜ
그리고 제 목표인 금융권 핀테크 회사에 열심히 지원할 생각입니다. 올해 안에는 꼭 취업하고 싶어요!
