---
title: "[우리 웹앱이 빨라졌어요] 서비스 워커 customize 하기"
description: "workbox-cli를 이용해 precache 파일을 커스텀해봅시다"
date: 2020-03-16T18:44:16+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["frontend"]
---

#### 들어가며

서비스 워커가 PWA를 구현하기 위해 필수라는 사실은 잘 알고 있었지만 한동안 프로덕션에서 사용을 못하고 있었다. create-react-app이 오래 전부터 서비스 워커를 지원하고 있었는데도 말이다. 한 가지 너무 간단한 이유 때문이었는데, **index.html이 함께 캐시되는 바람에 새 배포가 브라우저에 적용되지 않는 문제** 때문이었다.

#### 내가 겪은 문제

최신 버전 CRA를 다운받아 실행해보자.
{{<highlight bash>}}
$ npx create-react-app service-worker-practice
...configuring...
$ yarn build # 프로덕션 빌드
$ yarn global add serve # 정적 파일 서빙해주는 툴 설치
$ serve -s build # 빌드된 디렉터리를 서빙
┌───────────────────────────────────┐
│                                                  │
│   Serving!                                       │
│                                                  │
│   - Local:            http://localhost:5000      │
│   - On Your Network:  http://192.168.0.22:5000   │
│                                                  │
│   Copied local address to clipboard!             │
│                                                  │
└───────────────────────────────────┘
{{</highlight>}}

![default-logo](/how-to-migrate-workbox/default-logo.png)

그러면 너무나 친숙한 react 로고가 출력될 것이다. 잘 나오는 걸 확인했으면 잠깐 서버를 끄고 두 가지를 바꿔보도록 하자. 하나는 기본 `unregister` 설정되어 있는 서비스 워커를 `register`로 바꾸는 것이고 다른 하나는 기본 배경화면을 초록색으로 바꿔보는 것이다. 

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=13">}}
// src/index.js
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';

ReactDOM.render(<App />, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.register(); // 서비스 워커를 실행한다
{{</highlight>}}

서비스 워커를 설정한 뒤 css 파일을 변경해서 새 배포가 일어났음을 가정하자.

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=3">}}
// src/App.css
.App-header {
  background-color: #29a33e; // 초록색으로 변경
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
  color: white;
}
{{</highlight>}}

그 다음 똑같은 빌드 및 배포를 실행해보자. 결과는 어떻게 될까?

{{<highlight bash>}}
$ yarn build # 프로덕션 빌드
$ serve -s build # 빌드된 디렉터리를 서빙
{{</highlight>}}

그리고 기존 화면을 새로고침하면...

아무것도 변하지 않는다. 이를 어쩐다? 우리는 개발자이기 때문에 캐시 무시하고 새로고침 (ctrl + shift + R) 을 할 줄 안다. **강력 새로고침을 하고 나서야 배경은 초록색으로 변한다.**

![green-logo](/how-to-migrate-workbox/green-logo.png)

#### 새 배포가 적용되지 않는 이유

먼저 서비스 워커의 간단한 정의를 살펴보자. 서비스 워커는 한 마디로 말해 '가로채기'다. 웹 앱의 네트워크 요청이 서버로 넘어가기 전에 서비스 워커가 요청을 가로채, 자신이 보유한 캐시 파일을 제공하는 프록시 서버 역할을 한다. 궁극적으로는 오프라인 상황에서도 서비스 워커가 웹 앱을 온전하게 기능하도록 제어한다. 대부분의 상황에서 서비스 워커의 캐시 기능은 강력하게 작동한다. 웹 앱이 보유하고 있는 정적 자산을 매번 요청하지 않고 스스로 제공해주기 때문에 네트워크 속도에 구애받지 않고 쾌적한 실행 성능을 보장해 준다.

이상적인 상황에서는 그렇다. 문제는 새로운 배포가 일어날 때에 벌어진다.

{{<highlight bash>}}
# before
dist
  - index.html
  - index.js
  - index.css
{{</highlight>}}

이런 구조로 된 웹 앱이 있다고 가정해 보자. 개발자가 몇 시간 동안 고생해서 내부 전체를 리디자인하고 파일을 저장했다. 그런데 그러고 나서도 파일명과 폴더 구조가 완전히 같다면, 브라우저와 서비스 워커는 이를 구분하지 못한다. 브라우저가 캐시를 유지하는 기준이 파일명이기 때문이다.

{{<highlight bash>}}
# after
dist
  - index.html # 엄청 고침
  - index.js # 끝내주는 리팩토링
  - index.css # 예술의 경지
{{</highlight>}}

웹팩을 비롯한 번들러들이 번들링한 파일명에 난수를 추가하는 이유가 바로 그것이다. 매번 빌드할 때마다 파일명을 달라지게 해서 브라우저가 최신 파일을 실행하도록 강제하는 것이다. create-react-app은 이 작업을 모두 자동으로 실행해준다. 브라우저는 index.html을 받아보고 거기에 링크된 파일들이 자신의 캐시와 모두 불일치한다는 걸 확인하고 새로 받아온다.

![cra-bundled](/how-to-migrate-workbox/cra-bundled.png)
<p class="caption">chunk 파일마다 붙어있는 hash 넘버에 주목하자</p>

그런데 서비스 워커가 켜지면? 이제는 index.html까지 캐시가 되고 만다. index.html은 웹 앱의 모든 자산 중에 유일하게 파일명이 바뀌지 않는 파일이다. 네트워크 요청의 기본이 되는 파일이기 때문이다. 그런데 index.html이 캐시가 된다면, 아무리 나머지 정적 자산의 파일명이 업데이트 되더라도 index.html에 링크된 파일명이 바뀌지 않기 때문에 새로운 배포가 적용되지 않는 것이다. 캐시 무시하고 새로고침을 누르면 그제야 서비스 워커가 새로 날아오는 index.html을 캐싱하겠지만 대다수의 일반 사용자는 강력 새로고침의 존재도, 아니 새 배포가 이루어졌는지도 모를 것이다.

create-react-app의 `src/serviceWorker.js` 파일을 살펴보자. 서비스 워커 실행 조건을 판별하고 실행 뒤 상태를 표시하는 코드가 담겨 있다.

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=11-16">}}
// src/serviceWorker.js
function registerValidSW(swUrl, config) {
  navigator.serviceWorker
    .register(swUrl)
    .then(registration => {
      registration.onupdatefound = () => {
        const installingWorker = registration.installing;
        if (installingWorker == null) {
          return;
        }
        installingWorker.onstatechange = () => {
          if (installingWorker.state === 'installed') {
            if (navigator.serviceWorker.controller) {
              // At this point, the updated precached content has been fetched,
              // but the previous service worker will still serve the older
              // content until all client tabs are closed.
              console.log(
                'New content is available and will be used when all ' +
                  'tabs for this page are closed. See https://bit.ly/CRA-PWA.'
              );

              // Execute callback
              if (config && config.onUpdate) {
                config.onUpdate(registration);
              }
            } else {
              // At this point, everything has been precached.
              // It's the perfect time to display a
              // "Content is cached for offline use." message.
              console.log('Content is cached for offline use.');

              // Execute callback
              if (config && config.onSuccess) {
                config.onSuccess(registration);
              }
            }
          }
        };
      };
    })
    .catch(error => {
      console.error('Error during service worker registration:', error);
    });
}
{{</highlight>}}

서비스 워커 상태가 `installed`로 바뀌었는데 이미 기존 `navigator` 객체에 서비스 워커가 존재한다면 현재 탭이 종료되고 새로운 탭이 열렸을 때, 즉 실행 환경이 초기화되었을 때 새로 캐시된 컨텐츠가 제공될 거라고 설명되어 있다.

단순 새로고침으로 동일한 네트워크 요청을 반복해서 보내는 게 아니라 페이지 자체가 초기화되는 강력 새로고침이 실행되어야만 새 버전의 캐시 파일이 제공될 것이다.

이 문제를 서비스 워커를 사용하는 다른 분들은 어떻게 해결했는지 모르겠다. 내 결론은 index.html에 한해서 캐시가 일어나지 않게 막아야 한다는 것이었다. (이렇게 해도 trade-off는 발생한다. index.html 파일만큼은 반드시 서버를 통해 받아와야 하므로 완전한 오프라인 모드가 불가능하다.) 아무튼, 지금으로서는 이 방법이 최선이므로 진행해보도록 하자.

#### Workbox-cli 설치하기

[workbox](https://developers.google.com/web/tools/workbox)는 구글이 프로그레시브 웹 앱을 지원하기 위해 만든 서비스 워커 빌더 라이브러리다. 모든 파일이 캐싱된다면 오프라인 환경에서도 구동할 수 있도록 지원해준다. 정확한 상황은 모르겠지만 아직까지 Create-React-App은 [sw-precache](https://github.com/GoogleChromeLabs/sw-precache)을 통해 서비스 워커를 만들고 있는 듯한데 이제는 deprecated 되었다 하니 workbox로 갈아타는 걸 추천한다.

{{<highlight bash>}}
$ yarn add --dev workbox-cli
# 글로벌 설치를 하지 않았다면 /node_modules/에서 직접 실행파일을 찾는 것이 방법이다
$ ./node_modules/.bin/workbox-cli wizard
{{</highlight>}}

그러면 위와 같은 안내 화면이 뜬다.

![wb-01](/how-to-migrate-workbox/wb01.png)

배포용 폴더가 무엇인지 묻는 단계다. Create-React-App을 쓰고 있다면 `build`를 선택하면 된다. 혹시 본인이 다른 프로젝트에 workbox를 적용하려 한다면 그 프로젝트에 맞는 배포용 폴더를 선택하면 된다.

![wb-02](/how-to-migrate-workbox/wb02.png)

가장 중요한 부분이다. 어떤 종류의 파일을 캐싱할 건지 선택하는 단계다. **우리는 index.html을 생략할 것이므로 html 부분을 선택해 체크를 해제해준다. (방향키로 이동해서 스페이스 바를 누르면 토글 된다. 노파심에서!)**

![wb-03](/how-to-migrate-workbox/wb03.png)

서비스 워커 파일을 어디에 위치시킬지 정하는 단계다. Create-React-App의 경우 `build/service-worker.js`에 서비스 워커가 놓이므로 우리도 같은 파일명을 적어주자.

![wb-04](/how-to-migrate-workbox/wb04.png)

마지막으로 workbox의 설정 파일 파일명을 묻는 단계가 나온다. 그냥 기본값을 선택하자.

![wb-05](/how-to-migrate-workbox/wb05.png)

이제 모든 설정이 끝났다! cli는 친절하게도 앞으로 서비스 워커를 만들려면 어떤 명령어를 쳐야 하는지도 알려주고 있다.

```
$ workbox generateSW workbox-config.js
```

이제 Create-React-App 빌드 이후에 저 명령어를 실행하기만 하면 workbox 서비스 워커가 만들어지면서 `build` 폴더에 있는 모든 파일 (index.html 빼고)을 캐시할 준비를 갖출 것이다.

[npm-run-all](https://github.com/mysticatea/npm-run-all)을 사용해서 스크립트를 깔끔하게 만들자. npm-run-all은 npm script의 여러 명령어를 한번에 중첩해서 호출할 수 있게 도와주는 툴이다.

```
yarn add --dev npm-run-all
```

![npm-run-all](/how-to-migrate-workbox/npm-run-all.png)

맨 아래 줄을 보면 `prod`라는 스크립트 안에 `build`와 `workbox`라는 이름의 스크립트를 함께 호출하는 모습을 볼 수 있다. 이제 `yarn prod` 명령을 내리면 프로덕션 빌드 후 서비스 워커까지 자동으로 생성될 것이다.

![build-complete](/how-to-migrate-workbox/build-complete.png)

<p class="caption">빌드 완료 후 서비스 워커가 생성됨</p>

이제 `build` 폴더를 정적 서빙하여 실행해보도록 하자.

![sw-active](/how-to-migrate-workbox/sw-active.png)

서비스 워커가 작동되었다. 그리고 네트워크 현황을 보면...

![network](/how-to-migrate-workbox/network.png)

`localhost`라고 표시된 index.html 도큐멘트는 그대로 서버에서 전송되고, 나머지 파일들은 서비스 워커가 대신 전달해준 모습을 볼 수 있다. 이제는 자유롭게 개발해도 캐시 걱정 없이 사용자에게 새 배포가 전달될 것이다!

#### 마치며

workbox는 지금 소개한 기능 외에 훨씬 심화된 기능을 많이 가지고 있다. 런타임 중에 발생하는 http 요청도 패턴에 따라 캐시하게 만드는 옵션도 있는 듯하다. 캐시 정책도 복잡하게 제어할 수 있으니 학습해보면 좋을 것 같다.

여전한 의문은 index.html까지 캐시하여 완벽한 PWA를 만든다 했을 때 어떻게 새 배포 문제를 해결할 수 있을까? 이다. 이 부분에 대해서도 추가로 해법을 찾아 나서야 할 것 같다.
