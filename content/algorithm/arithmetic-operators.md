---
title: "Day 1: Arithmetic Operators"
description: "10 Days of JavaScript"
date: 2019-03-26T11:41:04+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["tutorials"]
---

#### Day 1: Arithmetic Operators

**링크:** <a href="https://www.hackerrank.com/challenges/js10-arithmetic-operators/problem" target="_blank" rel="noopener noreferrer">Day 1: Arithmetic Operators | HackerRank</a>

###### 요약

`getArea()` 함수와 `getPerimeter()` 함수를 구성해서 직사각형의 면적과 둘레를 계산하라.

###### 구현

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=13 30">}}
/**
*   Calculate the area of a rectangle.
*
*   length: The length of the rectangle.
*   width: The width of the rectangle.
*   
*	Return a number denoting the rectangle's area.
**/
function getArea(length, width) {
    let area;
    // Write your code here

    area = length * width;
    
    return area;
}

/**
*   Calculate the perimeter of a rectangle.
*	
*	length: The length of the rectangle.
*   width: The width of the rectangle.
*   
*	Return a number denoting the perimeter of a rectangle.
**/
function getPerimeter(length, width) {
    let perimeter;
    // Write your code here

    perimeter = (length + width) * 2;
    
    return perimeter;
}
{{</highlight>}}

###### 결과

Input (stdin)

```
3
4.5
```

Expected Output

```
13.5
15
```
