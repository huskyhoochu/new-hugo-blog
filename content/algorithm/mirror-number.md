---
title: "[알고리즘 퍼즐 68] 대칭수 구하기"
description: "이게 입문이라는데... 어려운 건 얼마나 어려운데?"
date: 2019-11-23T08:04:55+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["book"]
---

#### 들어가며

왜 이렇게 글쓰기가 싫을까... 매번 더 열심히 해야지 다짐하면서도 글쓰기는 좀처럼 습관이 붙질 않는다. 하지만 알고리즘 공부를 더 이상 게을리해서는 답이 없다. 그래서 산 책. <a href="http://aladin.kr/p/tMLus" target="_blank" rel="noopener noreferrer"><코딩의 수학적 기초를 다지는 알고리즘 퍼즐 68></a> 이라는 책이다.

![mirror-book](/algorithm/mirror-number/book.jpg)

<p class="caption">왜 우주비행사인지는 모르겠다</p>

일단 자바스크립트 코드가 담겨 있고 꽤 얇다는 거, 마지막으로 <기초편> 이라는 표시 때문에 사게 됐다. 그런데 스윽 훑어보니 이게 뭐지... 그들이 생각하는 기초와 내 기초는 이렇게나 차이가 큰 것인가. 마음이 아팠다.

#### 어쨌든, 알고리즘을 보자: 대칭수 구하기

앞뒤가 똑같아서 거꾸로 읽어도 같은 수를 '대칭수', '회문수'라고 부른다. (예: 12321, 4567654 등) 그런데 이 개념을 확장해서, 10진수, 2진수, 8진수로 바꾸어도 모두 대칭수가 되는 숫자 중 10의 자리 이상 최소값을 찾아보자.

예를 들어 9가 있다. 9는 2진수에서 1001, 8진수에서 11로 대칭수가 되는 가장 작은 값이다. 그러나 이 예제에서는 10의 자리 이상 숫자에서 대칭수를 찾으라고 되어 있다. 어떻게 풀까?

#### 생각하는 과정

대칭수는 첫째 자릿수와 마지막 자릿수가 같다. 그런데 첫째 자릿수가 0일 리는 없으므로, 모든 대칭수는 홀수일 수밖에 없다. 2진수에서는 0과 1밖에 없기 때문이다. 결국 뒤집어도 똑같은 숫자면서 홀수인 숫자를 찾기만 하면 된다.

#### 구현

자바스크립트 코드를 보자.

{{<highlight js "linenostart=1, linenos=inline">}}
/* 문자열 형식을 역순으로 반환하는 메서드 추가 */
String.prototype.reverse = function() {
    return this.split("").reverse("").join("");
}

let num = 11; // 문제 조건: 10의 자리 이상 숫자. 우리는 홀수를 찾으니까 11부터

while (true) {
    if ((num.toString() === num.toString().reverse()) && // 10진수 대칭 비교
        (num.toString(2) === num.toString(2).reverse()) && // 2진수 대칭 비교
        (num.toString(8) === num.toString(8).reverse())) { // 8진수 대칭 비교
        console.log(num.toString());
        console.log(num.toString(2));
        console.log(num.toString(8));
        break; // 조건을 만족하면 이터레이션 종료
    }

    num += 2; // 홀수만 추적함
}
{{</highlight>}}

정답은 무엇일까? 이건 여러분이 직접 해결하기 바란다. 그냥 코드를 따라 치는 것만으로 충분히 가능할 것이다.

내가 개인적으로 배운 건 프로토타입을 이용해 메서드를 상속했다는 것이다. 자바스크립트는 그냥 함수를 선언하는 것보다 프로토타입 안에 메서드를 선언하는 것이 메모리 절약에 도움이 되는 걸로 알고 있다. 하지만 전역을 오염시킬 우려가 있으므로 이름이 겹치지 않도록 잘 선언하는 것이 중요하다.

