---
title: "JS: The Observers"
description: "의존성 패키지 없이도 가뿐하게! 자바스크립트 기본 내장 옵저버를 소개합니다"
date: 2019-04-22T21:50:32+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript"]
---

![observer-lens](/js-observers/observer-lens.jpg)
<p class="caption">by <a href="https://unsplash.com/photos/VBBs_SWsdwU" target="_blank" rel="noopener noreferrer">Unsplash</a></p>

#### 들어가며 - 옵저버 패턴이란?

옵저버 패턴은 데이터 종속적인 인터페이스가 데이터의 변화를 감시하는 구조를 말합니다. 엑셀 표를 생각해봅시다. 사용자가 스프레드시트의 값을 바꿀 때마다 표는 물론 그래프와 차트에도 변화가 전달되어야 합니다. 이때 중요한 건 모든 요소들이 동시에, 즉각적으로 변해야 한다는 것입니다. 모든 객체들의 신속한 동기화를 위해서는 데이터를 보유한 주체(Subject)를 여러 객체들이 감시(Observe)하는 방식이 가장 효과적입니다.

이 프로그래밍 패턴을 발전시킨 것이 리액티브 프로그래밍 패러다임이죠. 2009년 마이크로소프트에서 발표한 <a href="http://reactivex.io/" target="_blank" rel="noopener noreferrer">ReactiveX</a> 프레임워크는 RxJS, Rx.NET 등 여러 언어를 지원하는 버전으로 발표되었습니다. RxJS는 자바스크립트의 비동기 액션을 하나의 데이터 흐름으로 제어하기 위해 주로 사용됩니다. 저 또한 사내 서비스에 RxJS 도입을 고려하고 있는 중입니다만, RxJS는 커다란 규모의 프레임워크인 만큼 설계가 안정된 뒤에 도입할 예정입니다.

보다 간단하게 옵저버 패턴을 사용할 수 있는 방법은 없을까요? 강력한 기능이 탑재된 것은 아니지만 이미 자바스크립트가 자체적으로 보유하고 있는 쏠쏠한 옵저버들이 여럿 있습니다.

#### JS Observers

MDN 페이지에서 소개하고 있는 자바스크립트 전체 API 중 옵저버는 총 다섯가지입니다. 간략하게 소개하자면 다음과 같습니다.

- IntersectionObserver: 루트 영역(뷰포트)와 대상 객체의 겹침을 감시
- MutationObserver: 객체의 속성 변경을 감시
- PerformanceObserver: 프로세스 성능 모니터링
- ReportingObserver: 웹 사이트의 표준 및 정책 준수 현황을 감시
- ResizeObserver: 객체의 너비, 높이의 변화를 감시

(참고: <a href="https://developer.mozilla.org/en-US/docs/Web/API" target="_blank" rel="noopener noreferrer">Web APIs | MDN</a>)

ReportingObserver를 제외하면 지금 당장 실제 프로젝트에 적용해도 매우 유용할 것 같습니다. 하나씩 간단한 예제를 직접 만들어서 보여드리도록 하겠습니다.

#### IntersectionObserver

IntersectionObserver를 매우 심도 있게 분석한 번역 글이 있어서 먼저 이것부터 소개해드리겠습니다.

(참고: <a href="https://github.com/codepink/codepink.github.com/wiki/%EB%84%88%EB%8A%94-%EB%82%98%EB%A5%BC-%EB%B3%B8%EB%8B%A4:-%EC%A7%80%EC%97%B0-%EB%B0%A9%EB%B2%95,-%EB%A0%88%EC%9D%B4%EC%A7%80-%EB%A1%9C%EB%93%9C%EC%99%80-IntersectionObserver%EC%9D%98-%EB%8F%99%EC%9E%91" target="_blank" rel="noopener noreferrer">너는 나를 본다: 지연 방법, 레이지 로드와 IntersectionObserver의 동작</a>)

또한 레진 기술 블로그에서 IntersectionObserver를 이용해 이미지 로드 방식을 개선한 사례도 공유합니다.

(참고: <a href="https://tech.lezhin.com/2017/07/13/intersectionobserver-overview" target="_blank" rel="noopener noreferrer">레진 기술 블로그 - IntersectionObserver를 이용한 이미지 동적 로딩 기능 개선</a>)

