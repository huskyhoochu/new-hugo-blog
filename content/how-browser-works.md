---
title: "브라우저의 동작 원리와 렌더링 최적화"
description: "브라우저가 어떻게 HTML을 렌더링하는지 구체적인 원리를 살펴봅시다"
date: 2021-02-16T10:45:40+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["html"]
---

#### 들어가며

모던 SPA가 어떻게 동작하는지 파악하기에 앞서 브라우저가 어떻게 html을 화면에 그리는지 원리를 파악해보는 포스팅을 남기면 좋겠다고 생각했다.

아래 주소의 내용을 요약 정리하는 글이 될 것이다.

HTML: [https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/](https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/)

CSS 렌더링 성능: [https://developers.google.com/web/fundamentals/performance/rendering?hl=ko](https://developers.google.com/web/fundamentals/performance/rendering?hl=ko)

애니메이션 최적화: [https://developers.google.com/web/fundamentals/performance/rendering/stick-to-compositor-only-properties-and-manage-layer-count?hl=ko](https://developers.google.com/web/fundamentals/performance/rendering/stick-to-compositor-only-properties-and-manage-layer-count?hl=ko)

#### 브라우저의 핵심 기능

대부분의 브라우저는 다음과 같은 인터페이스를 갖는다.

- URI를 넣는 주소창 (URI: Uniform Resources Idenrifier, URL과 거의 비슷한 개념이지만 URL이 주소(Location)에 더 중점을 둔 개념이라면 URI는 리소스의 성격(문서, 이미지, PDF 등)에 중점을 둔 개념이라 볼 수 있다.)
- 앞으로 / 뒤로 버튼
- 북마크 옵션
- 새로고침 및 정지 버튼
- 홈 버튼

HTML5 스펙이 브라우저의 UI 구조를 정의하지는 않지만, 우리가 사용하는 대부분의 브라우저는 비슷한 형태를 갖고 있다.


#### 브라우저의 계층 레벨 구조

1. 유저 인터페이스 (위에서 소개한 것)
2. 브라우저 엔진: UI와 렌더링 엔진 사이를 연결해준다.
3. 렌더링 엔진: 요청된 컨텐츠를 디스플레이한다. 예를 들면 HTML이 요청되면, 렌더링 엔진은 HTML과 CSS를 파싱하고 파싱된 컨텐츠를 스크린에 띄운다.
4. 네트워킹: HTTP 요청을 처리하는 부분이다. 플랫폼-독립적으로 구현되어 있다.
5. UI 백엔드: 운영체제와 UI를 연결해주는 뒷단 역할을 한다. 윈도우 관리를 한다든지 등등.
6. 자바스크립트 인터프리터: 자바스크립트 코드를 파싱하고 실행한다.
7. 데이터 스토리지: 쿠키, 로컬스토리지, indexedDB 등등 모든 저장 가능한 영역을 총괄한다.

![https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/layers.png](https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/layers.png)

크롬의 경우 하나의 탭에 하나의 렌더링 엔진이 붙는다. 각 탭이 분리된 프로세스로 운영된다.

#### 렌더링 엔진

렌더링은 모든 URI를 다루지만 이 챕터에서는 HTML과 CSS를 중심으로 살펴보겠다.

###### 주요 흐름

렌더링 엔진은 네트워킹 레이어에서 요청받은 문서를 받아들이면서 시작한다. 도큐먼트는 8kb씩 쪼개져서 받아온다.

그 다음의 흐름은 아래와 같다.

![https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/flow.png](https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/flow.png)

렌더링 엔진은 HTML 문서를 파싱하며 DOM 노드로 교체하는 작업을 시작한다. 엔진은 스타일 데이터도 파싱하는데, 외부 CSS 파일과 내부 스타일 엘리먼트를 함꼐 아우른다. 두 가지 시각적 구조물은 '렌더 트리' 라는 또 다른 트리를 만들어 낸다.

렌더 트리가 만들어진 뒤에는 '레이아웃' 프로세스가 수행된다. 이는 각 DOM 노드가 어느 좌표에 표현되어야 할지를 결정한다는 뜻이다. 그 다음 단계는 '페인팅'이다. 렌더 트리가 순회되며 각 노드는 UI 백엔드 레이어를 통해 화면에 그려진다.

이 모든 과정이 점진적이라는 걸 이해하는 게 중요하다. 더 나은 사용자 경험을 위해 렌더링 엔진은 가능한 빨리 컨텐츠를 표현하려고 할 것이다. 렌더링 엔진은 렌더 트리가 전부 그려질 때까지 기다리지 않는다. 문서의 일부분부터 파싱되고 표현되며, 네트워크를 통해 모든 컨텐츠를 다 가져올 때까지 이 작업은 거듭될 것이다.

![https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/webkitflow.png](https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/webkitflow.png)

![https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/image008.jpg](https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/image008.jpg)

위의 두 도식은 각각 WebKit과 Gecko 엔진의 주요 흐름을 보여준다. 대동소이하다.

---

#### 렌더링 성능

위에서 렌더링 엔진이 화면을 만들어내기까지의 과정을 다시 요약하자면 다음과 같다.

1. DOM 트리 및 CSS 트리 생성
2. 두 가지를 합친 렌더 트리 생성
3. 레이아웃 프로세스 (각 노드가 어디에 위치하는지 계산)
4. 페인팅 프로세스 (실제로 노드를 표현하는 것)
5. 이 모든 과정은 모든 문서가 로드되기까지 수시로 반복됨

이 이론적인 영역을 좀 더 현실의 영역으로 데려와 생각해 보자. 오늘날 대부분의 기기는 60프레임으로 작동하는데, 이는 1 프레임을 표현하기까지 주어진 시간이 고작 16밀리초라는 것을 뜻한다. 

이 찰나의 순간 동안 화면에 그려지는 각 픽셀의 관점에서 HTML 렌더링 과정을 보면 다시 다섯 가지로 나눌 수 있다.

![https://developers.google.com/web/fundamentals/performance/rendering/images/intro/frame-full.jpg?hl=ko](https://developers.google.com/web/fundamentals/performance/rendering/images/intro/frame-full.jpg?hl=ko)

1. 자바스크립트: 자바스크립트가 DOM에 영향을 주는 코드를 처리한다
2. 스타일: CSS 규칙에 따라 어떤 규칙을 어떤 요소에 적용할지 계산한다
3. 레이아웃: 브라우저가 화면에서 얼만큼의 공간을 어느 좌표에서 표현되어야 할지 계산
4. 페인트: 픽셀을 채우는 프로세스. 모든 시각적 부분을 실제로 그리는 작업을 포함
5. 합성: 페이지가 여러 레이어로 그려졌기 때문에 어떤 부분이 먼저 놓이고 나중에 놓이는지, 어떤 부분에서 겹침이 일어나는지 결정

이 다섯 가지 과정을 **"픽셀 파이프라인"** 이라고 부르는데, 1프레임마다 이 프로세스가 거듭된다고 보면 된다.

여기서 성능을 최적화하기 위해서는 가급적 전체 파이프라인을 다시 호출하는 일을 적게 만들어야만 한다. 가장 적은 비용을 일으키는 것은 '합성' 영역의 css 규칙을 바꾸는 것이다. 그러면 브라우저는 레이아웃과 페인트 프로세스를 건너뛰고 합성만을 호출하게 된다. 반면 '레이아웃' 영역의 css 규칙을 바꾸게 되면 브라우저는 전체 파이프라인을 모두 호출하게 된다. 따라서 각 css 규칙들이 어느 프로세스까지를 트리거하는지를 파악하여 최대한 효율적인 css를 짜야만 한다.

그 목록이 표로 나온 것이 이 페이지이다.

CSS 트리거: [https://csstriggers.com/](https://csstriggers.com/)

#### CSS 애니메이션 최적화

구글 문서에서 추천하는 애니메이션 최적화 방식은 합성(composite) 전용 속성만을 사용해 픽셀 파이프라인 재구동을 가급적 피하는 것이다. 또 기존 레이아웃을 다시 렌더링하지 않도록 애니메이션이 일어나는 요소만 레이어를 분리하는 방법도 소개하고 있다.

합성 전용 속성은 `opacity` 및 `transform`이 있다. `transform`은 다시 다섯 가지 항목으로 세분화 된다.

![https://developers.google.com/web/fundamentals/performance/rendering/images/stick-to-compositor-only-properties-and-manage-layer-count/safe-properties.jpg?hl=ko](https://developers.google.com/web/fundamentals/performance/rendering/images/stick-to-compositor-only-properties-and-manage-layer-count/safe-properties.jpg?hl=ko)

- translate: 노드의 x, y, z축 좌표 이동
- scale: 노드의 크기 조정
- rotation: 노드의 회전 각도 조정
- skew: 노드의 기울어짐 조정
- matrix: 노드의 행렬식 이동 설정

하지만 주의할 점은, 단순히 합성 전용 속성만을 사용하는 것뿐만 아니라 이 요소만이 변형되고 다른 요소들은 고정될 수 있도록 레이어를 분리해야 한다는 것이다. 이를 '자체 레이어로 승격한다'고도 표현한다.


이를 위해서는 `will-change` 속성을 사용하면 된다.
```
.moving-element {
  will-change: transform;
}
```

`will-change`가 존재하지 않는다면 다음 방법을 사용하면 된다.

```
.moving-element {
  transform: translateZ(0);
}
```

그러나 이 속성을 모든 요소에 남용해서는 안 된다. 레이어 갯수가 급증하게 되면 메모리 관리에 어려움이 빚어져 오히려 최적화를 방해할 수 있다.

