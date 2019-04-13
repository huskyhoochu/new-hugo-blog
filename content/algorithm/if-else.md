---
title: "Day 2: Conditional Statements: If-Else"
description: "10 Days of JavaScript"
date: 2019-03-26T22:51:37+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["hackerrank"]
---

#### Day 2: Conditional Statements: If-Else

**링크:** <a href="https://www.hackerrank.com/challenges/js10-if-else/problem" target="_blank" rel="noopener noreferrer">Day 2: Conditional Statements: If-Else | HackerRank</a>

###### 요약

주어진 성적 구간을 보고, 입력돤 점수값에 따라 A부터 F 등급까지 점수를 출력하라.

- 25 초과 30 이하 = A
- 20 초과 25 이하 = B
- 15 초과 20 이하 = C
- 10 초과 15 이하 = D
- 5 초과 10 이하 = E
- 0 이상 5 이하 = F

###### 구현

{{<highlight javascript "linenostart=1, linenos=inline">}}
function getGrade(score) {
    let grade;
    // Write your code here
    if (score > 25 && score <= 30) {
        grade = 'A';
    } else if (score > 20 && score <= 25) {
        grade = 'B';
    } else if (score > 15 && score <= 20) {
        grade = 'C';
    } else if (score > 10 && score <= 15) {
        grade = 'D';
    } else if (score > 5 && score <= 10) {
        grade = 'E';
    } else if (score >= 0 && score <= 5) {
        grade = 'F';
    }
    
    return grade;
}
{{</>}}

###### 결과

Compiler Message
```
Success
```
Input (stdin)
```
11
```
Expected Output
```
D
```

###### 다른 유저의 풀이

if-else를 사용하지 않고 한 줄로 구현했다고 한다.

{{<highlight javascript>}}
function getGrade(score) {
    return 'FFEDCBA'[Math.ceil(score/5.0)];
}
{{</>}}

`score` 변수를 연산해서 'FFEDCBA' 라는 문자열의 인덱스를 출력하게 한다는 게 핵심 아이디어다.
