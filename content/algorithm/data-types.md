---
title: "Day 0: Data Types"
description: "10 Days of JavaScript"
date: 2019-03-21T16:24:27+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["tutorials"]
---

#### Day 0: Data Types

**링크:** <a href="https://www.hackerrank.com/challenges/js10-data-types/problem" target="_blank" rel="noopener noreferrer">Day 0: Data Types | HackerRank</a>

###### Objective

Today, we're discussing data types. Check out the attached tutorial for more details.

###### Task

Variables named `firstInteger`, `firstDecimal`, and `firstString` are declared for you in the editor below. You must use the  operator to perform the following sequence of operations:

1. Convert `secondInteger` to an integer (Number type), then sum it with `firstInteger` and print the result on a new line using `console.log`.

2. Convert `secondDecimal` to a floating-point number (Number type), then sum it with `firstDecimal` and print the result on a new line using `console.log`.

3. Print the concatenation of `firstString` and `secondString` on a new line using `console.log`. Note that `firstString` must be printed first.

###### 요약

정수, 실수, 문자열 타입인 세 변수에 대응하는 세 가지 input 값을 각각 더해서 출력하라. 이때 input 값이 모두 문자열이므로 정수, 실수에 해당하는 값은 type을 변경해야 한다.

###### 구현

(하이라이트 된 부분이 직접 작성한 코드)

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=24 27 30">}}
/**
*   The variables 'firstInteger', 'firstDecimal', and 'firstString' are declared for you -- do not modify them.
*   Print three lines:
*   1. The sum of 'firstInteger' and the Number representation of 'secondInteger'.
*   2. The sum of 'firstDecimal' and the Number representation of 'secondDecimal'.
*   3. The concatenation of 'firstString' and 'secondString' ('firstString' must be first).
*
*	Parameter(s):
*   secondInteger - The string representation of an integer.
*   secondDecimal - The string representation of a floating-point number.
*   secondString - A string consisting of one or more space-separated words.
**/
function performOperation(secondInteger, secondDecimal, secondString) {
    // Declare a variable named 'firstInteger' and initialize with integer value 4.
    const firstInteger = 4;
    
    // Declare a variable named 'firstDecimal' and initialize with floating-point value 4.0.
    const firstDecimal = 4.0;
    
    // Declare a variable named 'firstString' and initialize with the string "HackerRank".
    const firstString = 'HackerRank ';
    
    // Write code that uses console.log to print the sum of the 'firstInteger' and 'secondInteger' (converted to a Number type) on a new line.
    console.log(firstInteger + parseInt(secondInteger));
    
    // Write code that uses console.log to print the sum of 'firstDecimal' and 'secondDecimal' (converted to a Number type) on a new line.
    console.log(firstDecimal + parseFloat(secondDecimal));
    
    // Write code that uses console.log to print the concatenation of 'firstString' and 'secondString' on a new line. The variable 'firstString' must be printed first.
    console.log(firstString + secondString);
}
{{</highlight>}}

###### 결과

Input (stdin)

```
12
4.32
is the best place to learn and practice coding!
```
Expected Output

```
16
8.32
HackerRank is the best place to learn and practice coding!
```