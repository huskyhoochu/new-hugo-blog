---
title: "Day 1: Functions"
description: "10 Days of JavaScript"
date: 2019-03-26T11:51:49+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["tutorials"]
---

#### Day 1: Functions

**링크:** <a href="https://www.hackerrank.com/challenges/js10-function/problem" target="_blank" rel="noopener noreferrer">Day 1: Functions | HackerRank</a>

###### 요약

주어진 정수 `n`으로 이루어진 `n!`(factorial)을 구성하라.

###### 구현

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=14-17">}}
/*
 * Create the function factorial here
 */
function factorial(n) {
    // 탈출 조건: n이 2 이하면 자기 자신을 리턴
    if (n <= 2) {
        return n;
    }

    let count = n;
    let result = n;

    // while문: result에 count에서 1 뺀 값을 계속 곱한다. count가 2 이하일 때까지 반복.
    while (count >= 2) {
        count = count - 1;
        result = result * count;
    }

    return result;
}
{{</highlight>}}

###### 결과
Compiler Message
```
Success
```
Input (stdin)
```
4
```
Expected Output
```
24
```

###### 다른 유저의 해답

{{<highlight javascript>}}
const factorial = n => (n === 0 ? 1 : n * factorial(n - 1));
{{</highlight>}}

삼항연산자 + 재귀식을 사용. `n`이 0이면 1 리턴, 그렇지 않으면 `n`과 factorial 함수를 재귀적으로 곱함.
