---
title: "구글 로그인 Input 구현하기"
description: "React와 간단한 css로 구글 로그인 창을 구현해봅시다"
date: 2020-10-30T23:54:22+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["css"]
---

#### 들어가며

![demo2](/signup-page/demo2.png)

![demo](/signup-page/demo.png)

간단하게 이메일 입력창을 만들다가 구글처럼 placeholder에 인터렉션을 줄 수 없을까? 하여 구성해보았습니다.

데모 페이지: [https://ancient-wave-21634.herokuapp.com/auth/signup](https://ancient-wave-21634.herokuapp.com/auth/signup)

#### 전체 코드

{{<gist huskyhoochu 2a54e1e4ff51658d90f6544625df7e8b>}}

#### 뜯어보기

핵심이 되는 부분은 '이메일'이라는 제목이 담긴 `<p>` 태그 부분의 css입니다.

```css
.title {
      position: absolute;
      left: 10px;
      background-color: ${colors.white};
      opacity: 0.5;
      transform: translateY(6px);
      transition: all 0.2s ease-out;
      padding: 0 4px;
    }
```

진짜 placeholder를 주는 대신 p 태그에 absolute 옵션을 주어 input 한가운데에 놓이게 합니다.

그 뒤 focus 이벤트가 발생하면 setAttirbute 함수를 이용하여 input의 머리맡에 글자가 이동하도록 세팅합니다.

```typescript jsx
const onFocus = () => {
    if (pRef.current) {
      pRef.current.setAttribute(
        'style',
        'transform: translateY(-10px); font-size: 14px; opacity: 1',
      );
    }
  };
```
focus 이벤트가 해제될 때는 onBlur 이벤트가 발동되므로 이메일 글자가 제자리로 돌아갈 수 있도록 세팅합니다.

```typescript jsx
const onBlur = () => {
    if (pRef.current) {
      pRef.current.setAttribute(
        'style',
        'transform: translateY(6px); font-size: 16px',
      );
    }
  };
```

이게 전부입니다! 참 쉽죠?

