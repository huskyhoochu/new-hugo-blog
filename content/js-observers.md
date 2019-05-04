---
title: "JS: The Observers"
description: "의존성 패키지 없이도 가뿐하게! 자바스크립트 기본 내장 옵저버를 소개합니다"
date: 2019-05-04T17:35:32+09:00
draft: false
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

intersection이라는 단어를 직역하면 '교차, 교차점'이란 뜻이 나오는데요. IntersectionObserver는 말 그대로 특정 DOM 객체가 우리가 보는 화면 영역(viewport)과 겹치는 교차 이벤트를 감시합니다. 사이트 하단에 있는 이미지를 로딩한다고 칩시다. 이때 이미지를 처음부터 불러오는 게 아니라 사용자가 스크롤을 해서 이미지 엘리먼트가 화면에 등장하는 순간 로딩을 시작한다면 어떨까요? 사이트 초기화 당시에 모든 이미지를 전부 불러올 필요가 없으니 성능을 개선하기에 매우 유용합니다.

<iframe src="https://codesandbox.io/embed/5kvyzj653l?fontsize=14" title="intersection" style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

#### ResizeObserver

ResizeObserver는 말 그대로 DOM 객체의 크기 변화를 감시하는 옵저버입니다. 

<iframe src="https://codesandbox.io/embed/j2vn2232qv?fontsize=14" title="resizeObserver" style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

기기 너비가 일정 픽셀 이하로 줄어들었을 때 콜백 함수를 활용하거나 섬세한 애니메이션을 필요로 할 때 유용하게 쓸 수 있습니다.

(참조: <a href="https://alligator.io/js/resize-observer/" target="_blank" rel="noopener noreferrer">A Look at the Resize Observer JavaScript API</a>)

문제는, 아직 ResizeObserver가 최신 크롬 환경에서만 작동한다는 겁니다. 그래서 폴리필을 다운받아 사용하시는 걸 추천드립니다.

(참조: <a href="https://github.com/que-etc/resize-observer-polyfill" target="_blank" rel="noopener noreferrer">que-etc/resize-observer-polyfill: A polyfill for the Resize Observer API</a>)

#### MutationObserver

아마 나머지 모든 옵저버 가운데 가장 활용도가 높은 녀석이 아닐까 싶습니다. 이 옵저버는 IE11까지도 지원하는 뛰어난 호환성을 자랑하기도 하고, DOM 객체의 '속성'이라는 꽤나 범용적인 영역을 감시해줍니다.

<iframe src="https://codesandbox.io/embed/lpv42q12rm?fontsize=14" title="mutation" style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

박스의 내부 문구에 옵저버를 붙였습니다. 박스 문구는 rgb 값을 담고 있는데, 클릭할수록 값이 증가합니다. 박스를 클릭해 rgb값이 바뀌면 옵저버가 박스의 배경색을 새 rgb값에 맞춰 업데이트합니다.

#### PerformanceObserver

퍼포먼스 옵저버는 FCP(First Contentful Paint), FMP(First Meaningful Paint) 등을 측정할 수 있게 도와주는 옵저버입니다. 하지만 워낙 최신 기능이고 폴리필도 완벽하게 마련되어 있지 않습니다. 예제 코드는 MDN 공식 사이트나 이 블로그를 보시면 좋겠네요.

(참조: <a href="https://jmperezperez.com/paint-timing-api/" target="_blank" rel="noopener noreferrer">PerformanceObserver and Paint Timing API - José M. Pérez</a>)

다른 퍼포먼스 측정 툴을 추천하자면 Perfume.js 가 있습니다.

(참조: <a href="https://github.com/Zizzamia/perfume.js" target="_blank" rel="noopener noreferrer">Zizzamia/perfume.js | GitHub</a>)

<iframe src="https://codesandbox.io/embed/kw1x5xj48o?fontsize=14" title="performance" style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;" sandbox="allow-modals allow-forms allow-popups allow-scripts allow-same-origin"></iframe>

#### ReportingObserver

(참조: <a href="https://developer.mozilla.org/en-US/docs/Web/API/ReportingObserver" target="_blank" rel="noopener noreferrer">ReportingObserver - Web APIs | MDN</a>)

리포팅 옵저버는 매우 실험적인 기능이라 지원하는 브라우저가 아직 거의 없다고 볼 수 있는데요. MDN 페이지를 보시면 이 옵저버가 사용자의 window 객체를 조회해서 정책적으로 너무 오래된 메서드가 쓰인다거나 하면 경고를 주는 기능을 하는 것 같습니다.

![reporting-observer](/js-observers/reporting_api_example.png)

#### 마치며

이 페이지에서 각 옵저버의 심도 깊은 사용법을 알려드렸다면 더 좋았을 텐데, 그러지 못해서 아쉽네요. '이런 기능이 있었구나!' 정도를 알아가셨다는 것만으로도 다행이라고 생각합니다. 저것들로 구글링을 하시면 훨씬 더 응용된 예시를 찾아보실 수 있을 거예요! 
