---
title: "[TIL] Cache-Control이란?"
description: "웹 컨텐츠 캐시 정책을 컨트롤하는 Cache-Control을 알아봅시다"
date: 2020-07-12T14:10:21+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["web", "til"]
---

#### 들어가며

웹 개발자에게 피할 수 없는 것이 있다면 (정말 많지만) 캐시가 있을 것이다. 요즘은 서비스 워커나 CDN 등 컨텐츠의 접근성과 재사용성을 높일 수 있는 방법이 많지만 여전히 브라우저에게 컨텐츠를 캐싱하게 하는 HTTP 캐시 정책은 중요하다. 최근에는 ETag와 Cache-Control로 컨텐츠 캐싱을 수행하는 추세다. 오늘은 Cache-Control의 미묘한 옵션의 차이를 알아보려고 한다.

참고: [Cache-Control - HTTP | MDN](https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Cache-Control)

Cache-Control은 HTTP/1.1에서 추가된 기능으로, 여러 캐싱 정책을 다양하고 제공하고 있다. 그중 가장 자주 쓰고, 또 헷갈리는 정책들을 소개한다.


#### max-age=0 vs no-cache vs no-store

- `max-age` = n: 초 단위로 캐시 신선도를 설정한다. 예를 들어 60 * 60 = 3600을 입력하면 한 시간, 3600 * 24 = 86400을 입력하면 하루동안 캐시가 유지된다. 그 이후엔 서버에 요청한 뒤 304 응답을 받을 때에만 캐시를 이용한다.
- `no-cache`: 캐시가 유효한지 확인하기 위해 매번 서버에 요청한다.
- `no-store`: 어떤 요청도 캐시로 저장하지 않는다.

`max-age`는 캐시의 수명을 결정하는 정책이며, `no-cache`와 `no-store`는 캐시의 행동 방식을 결정하는 정책이다. 캐시를 항상 무효화하기 위해 `max-age=0`를 설정하는 곳도 있는데, 사실 `no-cache`를 이용하면 더 깔끔하게 해결할 수 있다.

다만 `no-cache`와 `no-store`는 방식이 서로 다르다. `no-cache`는 캐시를 저장하되 캐시가 유효한지 매번 서버에 질의하는 것이고, `no-store`는 아예 캐시를 저장하지 않는 것이다. 

완벽한 캐싱 방지를 위해서는 헤더 설정을 이렇게 할 수 있다.

```
Cache-Control: no-cache, no-store, must-revalidate
```

여기서 `must-revalidate`는 `no-cache` 정책을 프록시 서버에게 요청하는 것이다. 그러면 프록시 서버는 오리진 서버에게 캐시가 유효한지 매번 질의하게 된다. 만일 어떤 컨텐츠가 공유 캐시로 설정되어 있었다면 프록시 서버 단에서 캐시를 돌려줄 수 있으므로 그것까지 방지하기 위해선 필요한 정책이다.


#### public vs private

그런데 갑자기 프록시 서버 얘기는 왜 하는 걸까? 내가 설정한 웹 서버에는 프록시가 없는데? 그렇지 않다. 이미 구글과 우리의 브라우저 사이에는 몇 단계에 걸친 프록시 서버가 설치되어 있다. 인터넷 서비스 공급자, 즉 KT나 SKT 등의 사업자들은 각 지역의 네트워크를 프록시 서버로 묶어 인터넷에 연결시키고 있다. 우리가 만든 웹 서버로 고객이 요청을 보내면, 웹 서버의 컨텐츠는 프록시 서버를 거쳐 가며 사용자에게 도달하고, 이때 각 프록시 서버에 컨텐츠가 캐시되는 것도 가능하다. 이를 공유 캐시라 한다. 하지만 만일 전달된 컨텐츠가 비공개 내용이라면, 보안에 구멍이 생기는 건 아닐까? 우선 모든 Cache-Control 정책은 기본적으로 `private`이므로 여기에 대해선 걱정하지 않아도 좋다.

- `public`: 어떤 요청에 대해서든 캐시를 저장한다.
- `private`: 타인과 공유되는 프록시 서버에는 캐시를 저장하지 않는다. 최종 사용자의 클라이언트에만 캐시를 저장한다.

그러나 캐시를 `private`를 설정한다는 것이 통신 과정을 감청할 수 없다는 뜻은 아니니 주의하는 게 좋다.

참고:

- [http - Private vs Public in Cache-Control - Stack Overflow](https://stackoverflow.com/questions/3492319/private-vs-public-in-cache-control)
  
- [HTTP caching - 다른 종류의 캐시들](https://developer.mozilla.org/ko/docs/Web/HTTP/Caching)

