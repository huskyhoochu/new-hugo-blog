---
title: "Day 1: Let and Const"
description: "10 Days of JavaScript"
date: 2019-03-26T12:16:41+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["tutorials"]
---

#### Day 1: Let and Const

**링크:** <a href="https://www.hackerrank.com/challenges/js10-let-and-const/problem" target="_blank" rel="noopener noreferrer">Day 1: Let and Const | HackerRank</a>

###### 요약

1. 상수 `PI` 를 `Math.PI` 속성을 이용해 정의하라. 
2. 원의 반지름을 나타내는 수 `r`을 이용해 원의 둘레와 너비를 구하라.

###### 구현

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=2 6 9">}}
// Write your code here. Read input using 'readLine()' and print output using 'console.log()'.
const PI = Math.PI;
      
// Print the area of the circle:
const r = readLine();
console.log(PI * Math.pow(r, 2));
      
// Print the perimeter of the circle:
console.log(PI * 2 * r);

{{</highlight>}}

###### 결과

Compiler Message
```
Success
```
Input (stdin)
```
2.6
```
Expected Output
```
21.237166338267002
16.336281798666924
```
