---
title: "[알고리즘 퍼즐 68] 02. 수열의 사칙연산"
description: "숫자 사이에 사칙연산을 넣어 계산한 결과가 대칭수가 되는 수"
date: 2019-11-24T10:13:36+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["book"]
---

#### 들어가며

에피소드 1과 비슷하다. 조건이 조금 더 추가된 형태다. 주어진 숫자 x를 하나하나 쪼개서 그 안에 사칙연산을 넣고 계산한 값이 대칭수가 되어야 한다. 1000에서 9999 사이에 있는 숫자 중에 구해야 한다. 예시는 이렇다.

- 351 -> 3 * 51 = 153
- 621 -> 6 * 21 = 126
- 886 -> 8 * 86 = 688

#### 혼자 생각해보기

이번엔 정답을 보기 전에 한번 생각을 해 보기로 했다. 제일 까다로운 건 예시에서처럼 숫자를 전부 쪼개는 게 아니라 일부분만 쪼개는 경우도 있다는 것이다. 천의 자리 숫자라면 세 가지 경우가 나올 것이다.

- 일의 자리 - 백의 자리
- 십의 자리 - 십의 자리
- 백의 자리 - 일의 자리

세 번의 루프를 돌면서 체크를 해야 할 것이다. 그리고 곱셈만 가능한 게 아니고 덧셈, 뺄셈, 나눗셈도 가능할 것이다. 나눗셈의 경우 정수로 떨어져야만 하겠으나 연산 횟수를 생각하면 그냥 단순 루프가 더 깔끔할 것이다.

{{<highlight js>}}
// 일의 자리 - 백의 자리
for (let i = 1000; i < 10000; ++i) {
    const numList = i.toString().split('');
    const head = parseInt(numList[0], 10);
    const tail = parseInt(numList.slice(1).join(''), 10); 

    if ((head + tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head - tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head * tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head / tail === i)) {
        console.log(i);
        console.log('--')
    }
}

// 십의 자리 - 십의 자리
for (let i = 1000; i < 10000; ++i) {
    const numList = i.toString().split('');
    const head = parseInt(numList.slice(0, 2).join(''), 10);
    const tail = parseInt(numList.slice(2).join(''), 10); 

    if ((head + tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head - tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head * tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head / tail === i)) {
        console.log(i);
        console.log('--')
    }
}

// 백의 자리 - 일의 자리
for (let i = 1000; i < 10000; ++i) {
    const numList = i.toString().split('');
    const head = parseInt(numList.slice(0, 3).join(''), 10);
    const tail = parseInt(numList.slice(3).join(''), 10); 

    if ((head + tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head - tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head * tail === i)) {
        console.log(i);
        console.log('--')
    }

    if ((head / tail === i)) {
        console.log(i);
        console.log('--')
    }
}
{{</highlight>}}

내 구현. 그런데 하나도 안 나옴...

#### 정답

여기서는 자바스크립트의 `eval()` 을 사용했다고 한다. 그리고 반복문 깊이를 깊게 해서 내가 생각 못한 경우의 수까지 구현했다. '일의 자리 - 일의 자리 - 십의 자리'...


{{<highlight js>}}
const op = ['+', '-', '*', '/', ''];
for (i = 1000; i < 10000; ++i) {
    var c = String(i);
    for (j = 0; j < op.length; ++j) {
        for (k = 0; k < op.length; ++k) {
            for (l = 0; l < op.length; ++l) {
                let val = c.charAt(3) + op[j] + c.charAt(2) + op[k] + 
                c.charAt(1) + op[l] + c.charAt(0);
                if (val.length > 4) {
                    if (i === eval(val)) {
                        console.log(val);
                        console.log(i);
                    }
                }
            }
        }
    }
}
{{</highlight>}}

설명하자면, 천의 자리의 각 자릿수 순회를 하나의 depth로 구성해서 총 4단계의 depth 순회를 하는 것이다. 그래서 각 자릿수마다 사칙연산 + 아무 연산 없음까지 5가지 경우의 수를 모두 순회한다. 결과는 다음과 같다.

```
5931 = 5 * 9 * 31 = 1395
```

혹시나 다른 경우가 있을까? 싶어 100,000까지 돌려봤지만 없었다. 엄청나게 희귀한 수로구나...
