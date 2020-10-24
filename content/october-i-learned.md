---
title: "10월 한 달간 배운 것들"
description: "새로 배운 내용에 대한 짧은 정리"
date: 2020-10-24T15:20:58+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["til"]
---

#### 들어가며

다른 개발자들은 사소하게 알게 된 내용을 꾸준히 정리하는데 나는 그렇게 하지 않아 많은 지식들을 날려버린다는 생각이 들었다. 그래서 이번 달에는 그간 배운 내용을 정리해보려고 한다.

#### 배운 것들

1. 우분투에서 sudo 명령어 없이 docker 사용하기
2. nginx를 이용해 호스트를 바꾸어 request 날리기

#### 우분투에서 sudo 명령어 없이 docker 사용하기

참고: [https://docs.docker.com/engine/install/linux-postinstall/](https://docs.docker.com/engine/install/linux-postinstall/)

공식 홈페이지에 나온 방법으로 매우 쉽다. 현재 유저를 docker usergroup에 참여시키기만 하면 된다.

```
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
```

이렇게 입력하고 쉘을 재시동하면 끝! 참 쉽죠?

#### nginx를 이용해 호스트를 바꾸어 request 날리기

왜 이런 걸 하게 되었는고 하니, 새로 만든 홈페이지에서 공인인증서 모듈을 실행하기 위해 레거시 시스템의 호출을 당겨받아야 할 일이 있었는데, 새 홈페이지의 호스트가 레거시의 apache에 등록되어 있지 않아 올바른 요청을 돌려주지 않았기 때문이다. 호스트를 등록해주면 해결될 일이었지만 레거시 소스코드를 뜯는다는 것이 워낙 부담스러운 일이라, 요청하는 쪽에서 기존에 등록된 호스트인 양 request를 보내기로 했다.

```
location /hello/ { // /hello/ 라는 주소로 호출하면 리버스 프록시를 작동시킨다
    proxy_pass http://legacy.com // 내가 원하는 레거시 시스템을 호출할 것이다
    proxy_set_header Host legacy.com // 호스트를 레거시 시스템이 이해하는 호스트로 잡아둔다
}
``` 

이렇게 하면 레거시 시스템은 기존에 호출 받던 시스템이 호출한 줄 알고 새 홈페이지에 정상 요청을 돌려준다!

#### 마치며

쓰기 전에는 항상 부담이 되는 게 블로그 글인데, 앞으로는 좀 더 친숙해지려고 노력해야겠다. 월간이 아니라 주간으로 새로 배운 것을 정리하자!

