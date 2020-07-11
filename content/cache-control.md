---
title: "[TIL] Cache-Control이란?"
description: "웹 컨텐츠 캐시 정책을 컨트롤하는 Cache-Control을 알아봅시다"
date: 2020-07-09T12:15:21+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["web", "til"]
---

#### 들어가며

웹 개발자에게 피할 수 없는 것이 있다면 (정말 많지만) 캐시가 있을 것이다. 요즘은 서비스 워커나 CDN 등 컨텐츠의 접근성과 재사용성을 높일 수 있는 방법이 많지만 여전히 브라우저에게 컨텐츠를 캐싱하게 하는 HTTP 캐시 정책은 중요하다. 최근에는 ETag와 Cache-Control로 컨텐츠 캐싱을 수행하는 추세다. 오늘은 Cache-Control의 미묘한 옵션의 차이를 알아보려고 한다.

#### 정책 종류

참고: [Cache-Control - HTTP | MDN](https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Cache-Control)

Cache-Control은 HTTP/1.1에서 추가된 기능으로, 여러 캐싱 정책을 다양하고 제공하고 있다. 그중 가장 자주 쓰고, 또 헷갈리는 정책들을 소개한다.


#### max-age=0 vs no-cache vs no-store

- `max-age` = n: 초 단위로 캐시 신선도를 설정한다. 예를 들어 60 * 60 = 3600을 입력하면 한 시간, 3600 * 24 = 86400을 입력하면 하루동안 캐시가 유지된다. 그 이후엔 서버에 요청한 뒤 304 응답을 받을 때에만 캐시를 이용한다.
- `no-cache`: 캐시가 유효한지 확인하기 위해 매번 서버에 요청한다.
- `no-store`: 어떤 요청도 캐시로 저장하지 않는다.

`max-age`는 캐시의 수명을 결정하는 정책이며, `no-cache`와 `no-store`는 캐시의 행동 방식을 결정하는 정책이다. 



#### public vs private

- `public`: 어떤 요청에 대해서든 캐시를 저장한다.
- `private`: 타인과 공유되는 프록시 서버에는 캐시를 저장하지 않는다. 최종 사용자의 클라이언트에만 캐시를 저장한다.





#### 직접 해보자




#### CloudFront로 공급되는 S3 컨텐츠의 Cache-Control 설정하기
