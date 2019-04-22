---
title: "Day 0. Hello, World!"
description: "10 Days of JavaScript"
date: 2019-03-21T16:17:28+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["hackerrank"]
---

#### Day 0. Hello, World!

**링크:** <a href="https://www.hackerrank.com/challenges/js10-hello-world/problem" target="_blank" rel="noopener noreferrer">Day 0: Hello, World! | HackerRank</a>

###### Objective

In this challenge, we review some basic concepts that will get you started with this series. Check out the tutorial to learn more about JavaScript's lexical structure.

###### Task

A greeting function is provided for you in the editor below. It has one parameter, `parameterVariable`. Perform the following tasks to complete this challenge:

Use `console.log()` to print `Hello, World!` on a new line in the console, which is also known as stdout or standard output. The code for this portion of the task is already provided in the editor.
Use `console.log()` to print the contents of `parameterVariable` (i.e., the argument passed to main).

You've got this!

###### 요약

`parameterVariable` 값을 출력하기 위해 `console.log()` 함수를 사용하시오.

###### 구현

(하이라이트 된 부분이 직접 작성한 코드)

{{<highlight javascript "linenostart=1, linenos=inline, hl_lines=14">}}
'use strict';
/**
*   A line of code that prints "Hello, World!" on a new line is provided in the editor. 
*   Write a second line of code that prints the contents of 'parameterVariable' on a new line.
*
*	Parameter:
*   parameterVariable - A string of text.
**/
function greeting(parameterVariable) {
    // This line prints 'Hello, World!' to the console:
    console.log('Hello, World!');

    // Write a line of code that prints parameterVariable to stdout using console.log:
    console.log(parameterVariable);
}
{{</highlight>}}
