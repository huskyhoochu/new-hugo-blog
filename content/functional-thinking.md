---
title: "함수형 사고와 Ramda.js로 기업 데이터 처리하기 (1)"
description: "데이터를 함수의 연결로 처리하는 함수형 프로그래밍 관점을 공부하고 실무에 적용한 사례를 적었습니다."
date: 2020-01-17T09:11:55+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["javascript", "book"]
---

#### 들어가며: 이론과 실전의 괴리

오늘은 함수형 프로그래밍에 대해 얘기해볼까 한다. '이론과 실전의 괴리'라는 소제목을 붙인 이유는 함수형 프로그래밍이 글쓴이 같은 선량한 주니어에게 '뭐든지 가능하게 해 주는, 당신을 좀 더 스마트하게 만들어 줄' 등등의 수식어를 달고 여러 인터넷 강의로 등장하는 모습을 보며 '와 뭔가 멋있어 보여! 당장 배워야지'라는 생각을 들게 했기 때문이다. 그렇게 여러 강의를 전전했고... 새로운 개념을 배운 것 자체는 좋은 일이었지만 뭔가 광고성 멘트에 비해서는 괴리가 있다는 느낌이 들었다.

함수형 프로그래밍이냐 객체지향 프로그래밍이냐 하는 논란이 지금도 있는진 모르겠지만, 글쓴이의 경우 필요한 영역마다 섞어 쓰면 좋다는 애매모호한 대답을 할 것 같다. 객체지향 설계가 관리해야 하는 상태를 객체 안에 밀어 넣어 캡슐화시키는 전략을 쓴다면, 함수형 설계는 아예 상태를 최소화하거나 없애는 방향으로 나아간다. 두 전략의 차이로 인해 강점을 발휘하는 영역도 달라진다. **함수형 설계는 큰 규모의 데이터를 여러 단계에 걸쳐 가공하는 등 어떤 프로그램의 '재료'를 다루는 일에 강하다. 반면 객체지향 설계는 바로 그 데이터가 위치해야 할 장소를 구획해주는 일, 어디에서 어디로 흘러가야 하는지 '구조'를 세우는 일에 강하다.** 오랜 세월 쌓여 온 수많은 종류의 디자인 패턴이 검증된 구조인 셈이다.

![bone](/functional-thinking/bone.jpg)

<p class="caption">Photo by Meta Zahren on Unsplash</p>

또 다른 불만 중의 하나는(내 돈!) 대부분의 함수형 프로그래밍 강의가 특정한 툴 사용법으로 귀결된다는 것이었다. 나는 좀더 이론적인 영역을 배우고 싶었는데, 강의들은 곧장 어떤 개념을 실습하는 모습을 보여주려고 하다 보니 그랬던 모양이다. 

이런 내게 많은 도움이 된 책이 있었다. <함수형 사고>라는 책이었다.

<div class="ttbReview"><table><tbody><tr><td><a href="https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=85956851&amp;ttbkey=ttbdiavelo1719001&amp;COPYPaper=1" target="_blank"><img src="https://image.aladin.co.kr/product/8595/68/coversum/8968482969_1.jpg" alt="" border="0"/></a></td><td align="left"  style="vertical-align:top;"><a href="https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=85956851&amp;ttbkey=ttbdiavelo1719001&amp;COPYPaper=1" target="_blank" class="aladdin_title">함수형 사고</a> - <img src="//image.aladin.co.kr/img/common/star_s10.gif" border="0" alt="10점" /><br/>닐 포드 지음, 김재완 옮김/한빛미디어</td></tr></tbody></table></div>

<함수형 사고>는 함수형 프로그래밍이 무엇이며 왜 이러한 접근법이 생겨났는지, 핵심 함수는 무엇인지를 중점적으로 설명해주려고 한다. 그 점이 읽기 좋았다. 책 전반에 걸쳐 쓰는 코드는 자바로 되어 있다. 그러나 금방 알아채겠지만, 클로저 언어를 너무 좋아하는 필자가 자바 유저들에게 언어 홍보를 하려는 건가 (...) 싶은 기분이 들 정도로 클로저 예찬을 한다. 그러나 클로저를 어떻게 쓰면 되는지 가르쳐주려고 하는 것까진 아니고 함수형 사고방식이 언어적으로 구현된 예를 보여줄 때만 클로저 덕질을 하신다... 라고 생각하면 될 것 같다.

이 책을 읽던 중에 사내에서 기업 데이터를 가공하여 포트폴리오를 구성해 보여주는 페이지를 개발해야 했다. (데이터가 어떤 출처를 지녔는지 등등 자세한 내용은 보안 문제로 말할 수는 없지만) 제법 큰 규모의 데이터였고, 재무정보를 담은 필드는 JSON의 key조차 일련번호와 코드로 되어 있어 알아보기도 어려웠다. 거기다 하나의 array에 각 해당 연도에 해당하는 재무 데이터가 순서가 보장되지 않은 채로 담겨 있기도 했다. 데이터 식별 - 정렬 - 추출 및 가공까지를 빠르게 처리해야 하는 상황. 잘 해내기 위해서는 함수형 설계의 관점으로 흐름을 만들어야겠다는 생각이 들어 과감히 책을 구매했다. (책 덕후들은 이런 핑계로 책을 사기도 하지요)

#### 명령형 프로그래밍과 함수형 프로그래밍

> "함수형 코드를 작성하기 위해서는, 함수형 언어인 스칼라나 클로저로의 전환이 필요한 것이 아니라 문제에 접근하는 방식의 전환이 필요하다."
>
> <함수형 사고> 27p.

이 책에서 말하고자 하는 가장 핵심적인 문장이다. 함수형 사고는 특정한 문법이나 툴을 활용해서 코드를 예쁘게 만드는 것이 아니라, 주어진 문제를 해결하는 관점을 '함수'의 방식으로 생각해보자는 것에 가깝다.

명령형 프로그래밍과 함수형 프로그래밍의 차이를 살펴보는 간단한 예제를 만들어보겠다. 은행 시스템에서 자주 쓰이는, 숫자 표기 금액을 한글 표기로 변환하는 코드다.

{{<highlight typescript "linenostart=1, linenos=inline">}}
// 명령형 프로그래밍
function numToKorean(num: number): string {
  // 한글로 바꿀 숫자 배열
  const textSymbol = ['', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];
  // 4자리마다 반복되는 자릿수 배열
  const powerSymbol = ['', '십', '백', '천'];
  // 4자리마다 커지는 단위수 배열
  const dotSymbol = ['', '만', '억', '조', '경'];

  // 숫자로 들어온 값을 문자열로 변환
  const strNum = String(num);

  let result = '';
  for (let i = 0; i < strNum.length; i++) {
    // 순회하면서 숫자를 한글로 변환해 삽입
    result += textSymbol[parseInt(strNum[i], 10)];

    // 숫자가 0이 아닐 때 자릿수 추가
    if (parseInt(strNum[i], 10) !== 0) {
      result += powerSymbol[(strNum.length - i - 1) % 4];
    }

    // 4자리가 반복될 때마다 단위수 추가
    if ((strNum.length - i - 1) % 4 === 0) {
      result += dotSymbol[Math.ceil((strNum.length - i - 1) / 4)];
    }
  }

  return result;
}

numToKorean(12345); // 일만이천삼백사십오
numToKorean(22020000); // 이천이백이만
numToKorean(7830000); // 칠백팔심삼만
numToKorean(3451274700); // 삼십사억오천일백이십칠만사천칠백
numToKorean(13710000); // 일천삼백칠십일만
{{</highlight>}}

명령형 프로그래밍은 개발자가 직접 저수준의 매커니즘을 사용해 데이터를 변경해야 하고, 임시 상태를 보관할 장소도 마련해야만 한다. 이런 식의 코드 설계는 빠른 개발을 해야 할 때 편리하지만 잠재적으로 위험할 수 있는데, 코드가 길고 장황해져서 가독성을 해칠 확률도 높은 데다가 코드 흐름에 접근해서 일부를 변경하기 쉽다 보니 얼마든지 코드가 깨질 수도 있다. 

{{<highlight typescript "linenostart=1, linenos=inline">}}
// 함수형 프로그래밍
function numToKorean(num: number): string {
  // 한글로 바꿀 숫자 배열
  const textSymbol = ['', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];
  // 4자리마다 반복되는 자릿수 배열
  const powerSymbol = ['', '십', '백', '천'];
  // 4자리마다 커지는 단위수 배열
  const dotSymbol = ['', '만', '억', '조', '경'];

  return num
    .toString() // 문자열 변환
    .split('') // 배열 분할
    .map(x => parseInt(x, 10)) // 배열 내 요소 숫자 변환
    .map((y, i, arr) => { // 자바스크립트 맵은 요소, 인덱스, 배열 자체를 파라미터로 갖는다
    // 숫자를 한글로 변환
    const text = textSymbol[y];

    // 숫자가 0이 아닐 때 자릿수 추가
    const power = y === 0 
      ? ''
      : powerSymbol[(arr.length - i - 1) % 4];
  
    // 4자리가 반복될 때마다 단위수 추가
    const dot = (arr.length - i - 1) % 4 === 0 
      ? dotSymbol[Math.ceil((arr.length - i - 1) / 4)] 
      : '';
  
    // 세가지 문자를 하나로 합쳐 리턴
    return `${text}${power}${dot}`;
  }).join(''); // 배열을 문자열로 합침
}


numToKorean(12345); // 일만이천삼백사십오
numToKorean(22020000); // 이천이백이만
numToKorean(7830000); // 칠백팔심삼만
numToKorean(3451274700); // 삼십사억오천일백이십칠만사천칠백
numToKorean(13710000); // 일천삼백칠십일만

{{</highlight>}}

명령형 코드와 비교했을 때 함수형 프로그래밍은 이런 점에서 도움이 된다. 먼저 데이터와 로직을 분리해서 관리할 수 있게 해 준다. 명령형 프로그래밍에선 루프 내부에 실제 데이터와 코드 로직이 뒤섞여 있어 '상태'를 직접 관리해야 하는 개발자에게 코드 개선의 부담을 안겨준다. 하지만 함수형 프로그래밍의 경우, 미리 정의된 고계함수(함수를 인자로 받는 함수) 혹은 언어가 제공하는 메서드 뒤편으로 '상태'의 운용을 위임하고, 개발자는 콜백함수를 통해 제공된 파라미터를 가공하면서 로직을 설계하게 된다. 이렇게 되면 공통으로 자주 쓰이는 주요 함수에 맞게 문제 해결 방식을 맞추어나가게 되고, 안전하면서도 여러 사람이 빠르게 이해할 수 있는 코드를 작성할 수 있게 된다.


#### 필터, 맵, 폴드(리듀스)

고계함수 중에는 삼대장이라 불릴 만큼 대표적인 함수가 세 가지 있다. 필터, 맵, 리듀스인데 하나씩 살펴보기로 하자.

###### 1. 필터

필터는 주어진 목록을 사용자가 정한 조건에 따라 더 작은 목록으로 만드는 작업이다. 예를 들어 주어진 숫자의 약수를 배열로 리턴하는 함수를 만든다고 하자.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const factorsOf = (number) => 
  Array.from(new Array(number).keys()) // 0에서 number - 1 까지 연속되는 배열 생성
    .map(x => x + 1) // 각 요소에 1씩 더하여 1 - number까지 연속되는 배열로 변경
    .filter(x => number % x === 0); // number로 나누어 나머지가 0인 숫자 필터

factorsOf(6); // [1, 2, 3, 6];
{{</highlight>}}

1에서 number까지 연속되는 배열을 생성한 뒤, number와 나누어 떨어지면 true를 반환하는 콜백 함수를 filter에 제공해 원하는 결과를 얻는다.

###### 2. 맵

필터가 조건에 맞는 요소만 골라내 더 작은 목록을 만드는 일이라면, 맵은 요소에 변화를 적용한 새로운 목록을 만드는 작업이다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const greeting = (users) =>
  users.map(user => `Hello, ${user}!`)

gretting(['John', 'Mary', 'Tom', 'Susan']);
// ['Hello, John!', 'Hello, Mary!', 'Hello, Tom!', 'Hello, Susan!'];
{{</highlight>}}


###### 3. 폴드 

폴드는 함수 연산으로 목록의 첫째 요소와 누산기 초기값을 결합하는 작업이다. 리듀스라고 부르기도 한다.

{{<highlight javascript "linenostart=1, linenos=inline">}}
const addAll = (nums) =>
  nums.reduce((acc, cur) => acc + cur);

addAll([1, 2, 3, 4]); // 10
/*
*        +   => 10
*       / \
*      +   4
*     / \ 
*    +   3
*   / \
*  1   2
*  // 초기값을 따로 지정하는 경우도 있고, 처음 더하는 값을 초기값으로 지정하는 경우도 있다.
*/
{{</highlight>}}


위의 세 가지 고계함수들은 거의 모든 프로그래밍 언어에서 발견할 수 있다. 공통적으로 구현되어 있는 표준적인 함수를 이용해 문제를 해결하다 보면, 개발자는 자신이 해결해야 할 문제를 정량적으로 생각할 수 있게 되고 다른 개발자들과 쉽게 공유할 수 있는 형태로 문제를 재정의하게 된다.

#### 쉬어가기

정리하다 보니 포스트가 길어져서 진도가 안 나가기 시작했다. 일단 이번 포스트는 개괄하는 정도에서 끝내고, 다음 파트에서는 커링, 부분함수 등의 개념을 익힌 뒤 방대한 기업 데이터에서 빠르게 원하는 데이터를 끄집어내는 방법을 소개하고자 한다.


#### 참고

<a href="https://evan-moon.github.io/2019/12/15/about-functional-thinking/" target="_blank" rel="noopener noreferrer">기존의 사고 방식을 깨부수는 함수형 사고 - Evan's Tech Blog</a>

<a href="https://velog.io/@kyusung/%ED%95%A8%EC%88%98%ED%98%95-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D-%EC%9A%94%EC%95%BD" target="_blank" rel="noopener noreferrer">함수형 프로그래밍 요약 - velog</a>

<a href="https://github.com/FEDevelopers/tech.description/wiki/%ED%95%A8%EC%88%98%ED%98%95-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EA%B0%80-%EB%90%98%EA%B3%A0-%EC%8B%B6%EB%8B%A4%EA%B3%A0%3F-(Part-1)" target="_blank" rel="noopener noreferrer">함수형 프로그래머가 되고 싶다고? (Part 1) · FEDevelopers/tech.description Wiki</a>