---
title: "금액-한글 변환 프로젝트 npm 배포하기"
description: "사내에서 사용 중이던 함수를 오픈소스로 만든 과정을 소개합니다"
date: 2020-04-26T13:35:43+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript", "opensource"]
---

#### 들어가며

오픈소스를 운영하는 게 오랜 버킷리스트였다. 하지만 항상 계획 과정에서 꿈이 너무 원대해지다 보니 목표를 감당 못해 무너지곤 했는데... 이번에는 정말 작은, 기능이 단 하나뿐인 함수를 운영하기로 했다. 숫자를 입력하면, 그 숫자를 한글로 바꿔주는 기능을 갖고 있다. 타입스크립트로 작성했고 npm에 발표한 상태다.

[github 저장소](https://github.com/huskyhoochu/num-to-korean)

[npm 패키지](https://www.npmjs.com/package/num-to-korean)

Runkit 예제를 함께 첨부한다.

<script src="https://embed.runkit.com" data-element-id="my-element"></script>
<div id="my-element">
const { numToKorean } = require(&quot;num-to-korean&quot;);

numToKorean(12345678);
</div>

#### num-to-korean 원리

이 함수에서 벌어진 전체 변환 과정을 요약하면 다음과 같다.

![process](/num-to-korean/process.png)

전체 과정 중에서 특이한 지점은 '역정렬'부분이다. 왜 한글 변환을 할 때 원본 숫자를 역방향으로 정렬하는가? 왜냐면 십, 백, 천으로 반복되는 자릿수와 만, 억, 조 등으로 증가하는 단위수가 일의자리부터 4자리마다 반복되기 때문이다.

![reverse](/num-to-korean/reverse.png)


이러한 원리를 적용해보기 위해 가장 먼저 0~9 와 대응할 숫자 배열, 4자리마다 반복되는 자릿수 배열, 4자리마다 커지는 단위수 배열을 정의하자.

{{<gist huskyhoochu d52ce0d37ba499c48d6570dfa6c6adce>}}

숫자 배열(`textSymbol`)의 각 숫자의 위치가 배열 인덱스 값과 일치하기 때문에, 변환하고 싶은 숫자를 인덱스로 대입하면 곧장 원하는 숫자를 얻을 수 있다.

```
1 -> textSymbol[1] -> "일"
7 -> textSymbol[7] -> "칠"
9 -> textSymbol[9] -> "구"
```
자릿수는 4자리마다 반복 적용되어야 한다. 그러자면 `["", "십", "백", "천"]` 으로 정의된 자릿수 배열에서 각 위치의 값을 반복해서 받아와야 한다. 이를 위해선 0,1,2,3,4...로 증가하는 원본 인덱스에 어떤 식을 넣었을 때 0,1,2,3, 0,1,2,3...으로 반복되도록 만들어야 한다. 답은 간단하다. **원본 인덱스를 4로 나눈 나머지를 자릿수 인덱스로 사용하면 된다.**

![calc-power](/num-to-korean/calc-power.png)

마지막으로 단위수가 남는다. 단위수는 4자리가 거듭될 때마다, 즉 첫번째, 5번째, 9번째 자리가 될 때마다 인덱스가 증가해야한다. 이번에는 **원본 인덱스를 4로 나눈 값을 올림하는 것으로 구할 수 있다.** 원본 인덱스가 0, 1, 2, 3인 구간까지는 0이 나오고, 4, 5, 6, 7인 구간에서는 1이, 8, 9, 10, 11인 구간에서는 2가 나오면서 4자리마다 1단위씩 증가하게 되는 것이다.

![calc-dot](/num-to-korean/calc-dot.png)


{{<gist huskyhoochu 02fdc34dab398a147b0cd09660eb0e50>}}


#### npm publish 과정

#### 현재까지의 성과
