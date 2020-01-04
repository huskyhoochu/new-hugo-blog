---
title: "[TIL] 유용한 도커 명령어들"
description: "삭제하고, 들여다보고, 도커 작업 좀 더 빠르게 수행하기"
date: 2020-01-03T09:25:25+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["til"]
---

#### 1. 이미지와 컨테이너

이미지를 확인하는 데 여러 방법이 있다. 표 형태로 보거나 id만 확인할 수 있고, dangling 상태인 이미지까지 전부 확인할 수 있다.

{{<highlight bash>}}
// 일반 이미지 목록 보기 (표 형태)
$ docker image ls
>
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
next-loan           latest              95085428bd16        26 minutes ago      281MB
<none>              <none>              f195ee2ddcee        26 minutes ago      522MB
node                12.14.0-alpine      1cbcaddb8074        9 days ago          85.2MB

// 이미지 id만 보기
$ docker image ls -q
>
95085428bd16
f195ee2ddcee
1cbcaddb8074

// 전체 이미지 모두 보기
$ docker image ls -a
>
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
next-loan           latest              95085428bd16        34 minutes ago      281MB
<none>              <none>              873d4ea7a08c        34 minutes ago      281MB
<none>              <none>              26e8582a7f35        34 minutes ago      281MB
<none>              <none>              4d35fc3f50d2        34 minutes ago      281MB
<none>              <none>              6d14d33684b6        34 minutes ago      281MB
<none>              <none>              038e23484df4        34 minutes ago      281MB
<none>              <none>              e9150caf5067        34 minutes ago      281MB
<none>              <none>              a326446fd208        34 minutes ago      280MB
<none>              <none>              c80e11f8246c        34 minutes ago      87MB
<none>              <none>              eee04e86018b        34 minutes ago      85.2MB
<none>              <none>              84b2a517d000        34 minutes ago      85.2MB
<none>              <none>              f195ee2ddcee        34 minutes ago      522MB
<none>              <none>              4bc113c99a5d        35 minutes ago      520MB
<none>              <none>              7def05414c13        36 minutes ago      89.1MB
<none>              <none>              fa37ed8cb9e4        36 minutes ago      85.2MB
node                12.14.0-alpine      1cbcaddb8074        9 days ago          85.2MB


{{</highlight>}}

`-a` 와 `-q` 플래그는 함께 쓸 수 있다. 

컨테이너의 경우도 이미지 명령어와 동일하게 작동한다. 그런데 특이한 점이 있다.

{{<highlight bash>}}
// 컨테이너 목록 보기 (표 형태)
$ docker ps
>
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

{{</highlight>}}

ps 명령어는 '실행된' 컨테이너만 보여준다. 많은 경우 컨테이너를 실행할 때 `docker run` 만 쓰다 보니 컨테이너의 라이프사이클이 좀더 세분화되어 있다는 사실을 캐치하지 않는데, 사실 `run`은 `create`와 `start`를 동시에 실행하는 것이다. 만일 `create`단계까지만 와 있는 컨테이너가 존재한다면 `ps` 명령어만으로는 볼 수 없다.

{{<highlight bash>}}
// 컨테이너 전체 목록 보기

$ docker ps -a
>
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
08c91f5622c4        next-loan:latest    "docker-entrypoint.s…"   18 hours ago        Created                                 interesting_mestorf


// 컨테이너 id만 보기 + 전체 보기

$ docker ps -a -q
>
08c91f5622c4

{{</highlight>}}


#### 2. 제거

도커를 쓸 때 가장 가려운 부분은 이미지를 입맛대로 청소하는 일이다. 이미지, 혹은 아이디만 불러오는 명령어를 알았으니 제거를 조금 더 편하게 할 수 있다. 또, `prune`이라고 부르는 도커 자체 api도 사용하면 좋다.

{{<highlight bash>}}
// 특정 이미지 제거

$ docker rmi <이미지 아이디 or 이름:태그>

// 특정 컨테이너 제거

$ docker rm <컨테이너 아이디 or 이름>
{{</highlight>}}

기본적인 삭제 명령어가 이러하다는 건 잘 알고 있을 것이다. 그런데 `rm` 및 `rmi` 명령어는 인자를 여러 개 붙이는 것이 가능하다. 따라서 전체 이미지 및 컨테이너를 삭제할 때 이런 명령어를 쓸 수 있다.

{{<highlight bash>}}
// 전체 이미지 제거

$ docker rmi $(docker images -a -q)

// 전체 컨테이너 제거

$ docker rm $(docker ps -a -q)
{{</highlight>}}

이렇게 하면 괄호 안쪽에 넣은 명령어가 컨테이너 / 이미지 id로 치환되면서 전체 요소를 삭제하게 된다.

#### prune

참고: <a href="https://docs.docker.com/config/pruning/" target="_blank" rel="noopener noreferrer">Prune unused Docker objects | Docker Documentation</a>

`prune` 은 도커 측에서 공식적으로 제공하는 제거 명령어다. 이미지, 컨테이너, 볼륨, 네트워크 등등을 세분화해서 제거할 수 있다. 안전을 위해 기본적으로는 사용되지 않는 리소스만 제거하는 가비지 컬렉터 개념으로 보면 좋다. `-a` 플래그를 이용해 전체 리소스를 제거한다 해도 여러 리소스와 관련되어 있는 것들은 보호된다. 방금 위에서 소개한 row-level 명령어보다 비교적 안전하다.

{{<highlight bash>}}
// dangling 이미지 제거
$ docker image prune

WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y

기본 이미지 제거는 dangling 이미지만을 제거해준다. 전체를 제거하려면 -a 플래그를 쓴다.

// 전체 이미지 제거
$ docker image prune -a

WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y

// 정지된 컨테이너 제거
$ docker container prune

WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y

{{</highlight>}}

경고문을 띄우지 않으려면 -f 플래그를 덧붙이면 된다.

필터링을 해서 더 정교하게 제거하는 것도 가능하다. 예를 들어 stop 상태가 된 지 24시간이 지난 컨테이너만 제거한다고 치자. 그러면 `until` 필터를 사용하면 된다.

{{<highlight bash>}}
// 멈춘 지 24시간이 지난 컨테이너 제거
$ docker container prune --filter "until=24h"
{{</highlight>}}

필터에 사용되는 키-밸류는 `LABEL`로 지정된 것이라면 뭐든지 가능하다.

```
label=<key> // 해당하는 라벨 키를 지닌 모든 컨테이너
label=<key>=<value> // 라벨 키-밸류 모두 일치하는 컨테이너
label!=<key> // 해당하는 라벨 키와 일치하지 않는 컨테이너
label!=<key>=<value> // 라벨 키-밸류 모두 일치하지 않는 컨테이너
```

볼륨과 네트워크도 마찬가지로 삭제 가능하다.

{{<highlight bash>}}
// 사용되지 않는 볼륨 제거
$ docker volume prune

WARNING! This will remove all volumes not used by at least one container.
Are you sure you want to continue? [y/N] y

// 사용되지 않는 네트워크 제거
$ docker network prune

WARNING! This will remove all networks not used by at least one container.
Are you sure you want to continue? [y/N] y
{{</highlight>}}

`system prune` 명령어를 이용해 모든 리소스를 한번에 제거할 수도 있다. 여기서는 빌드 캐시까지 함께 제거해준다. 다만 기본적으로는 안전을 위해 볼륨은 제거되지 않는다. 볼륨을 제거하기 위해서는 따로 `--volumes` 플래그를 덧붙여야 한다.

{{<highlight bash>}}
// 모든 리소스 제거
$ docker system prune

WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N] y

// 모든 리소스 제거 (볼륨 포함)
$ docker system prune --volumes

WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all volumes not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N] y
{{</highlight>}}

#### 3. 이미지 정보

대표적으로 `inspect`와 `history`가 있다. `inspect`는 생성된 이미지의 디테일한 정보를 보여주며,  `history`는 현재 이미지가 만들어지기까지 어떤 레이어들을 거쳤는지, 각 레이어의 사이즈는 어땠는지 등의 정보를 볼 수 있다.

글쓴이에게 생소했던 `history`를 살펴보도록 하겠다.

{{<highlight bash>}}
// 이미지 히스토리
$ docker history 95085428bd16
>
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
95085428bd16        20 hours ago        /bin/sh -c #(nop)  CMD ["yarn" "start"]         0B
873d4ea7a08c        20 hours ago        /bin/sh -c #(nop)  EXPOSE 80                    0B
26e8582a7f35        20 hours ago        /bin/sh -c #(nop)  ENV PORT=80                  0B
6d14d33684b6        20 hours ago        /bin/sh -c #(nop) COPY file:32050055ead2e7d1…   2.96kB
4d35fc3f50d2        20 hours ago        /bin/sh -c #(nop) COPY file:3ad2562de512bbfa…   2.12kB
e9150caf5067        20 hours ago        /bin/sh -c #(nop) COPY file:bcef6b1a3142d000…   118B
038e23484df4        20 hours ago        /bin/sh -c #(nop) COPY dir:d80e92d2c8ec24f4f…   317kB
a326446fd208        20 hours ago        /bin/sh -c #(nop) COPY dir:5cc5a1e707fabf5dd…   193MB
c80e11f8246c        20 hours ago        /bin/sh -c #(nop) COPY dir:158d31e0621260ad4…   1.81MB
eee04e86018b        20 hours ago        /bin/sh -c #(nop) WORKDIR /usr/src/app          0B
84b2a517d000        20 hours ago        /bin/sh -c #(nop)  LABEL maintainer=huskyhoo…   0B
1cbcaddb8074        10 days ago         /bin/sh -c #(nop)  CMD ["node"]                 0B
<missing>           10 days ago         /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B
<missing>           10 days ago         /bin/sh -c #(nop) COPY file:238737301d473041…   116B
<missing>           10 days ago         /bin/sh -c apk add --no-cache --virtual .bui…   5.35MB
<missing>           10 days ago         /bin/sh -c #(nop)  ENV YARN_VERSION=1.21.1      0B
<missing>           10 days ago         /bin/sh -c addgroup -g 1000 node     && addu…   74.2MB
<missing>           10 days ago         /bin/sh -c #(nop)  ENV NODE_VERSION=12.14.0     0B
<missing>           10 days ago         /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
<missing>           10 days ago         /bin/sh -c #(nop) ADD file:36fdc8cb08228a870…   5.59MB
{{</highlight>}}

이 이미지의 경우 두 가지 스테이지를 사용해, 첫 스테이지에서는 빌드만 수행하고 두 번째 스테이지에서 빌드된 파일만 복사해오는 식으로 구성된 탓에 빌드 스테이지 레이어가 모두 'missing' 처리된 것을 알 수 있다.

#### 4. 실행

실행 단계에서는 여러 플래그를 덧붙이는 경우가 많아 헷갈리곤 한다. 하나씩 정리해보려고 한다.

이미지를 실행할 땐 `start`혹은 `run`을 사용하며, 컨테이너에 따로 실행 명령을 줄 때는 `exec`를 사용한다. 앞선 챕터에서도 `run`은 `create`와 `start`를 동시에 실행하는 것이라고 말한 바 있는데, 여기서는 `run` 에서 가장 자주 쓰이는 플래그를 확인해보자.

```
-i: 인터렉티브 모드. 컨테이너 실행 시 표준 입력을 유지한다. 
-t: tty 쉘 활성화 여부. -i 옵션을 켜더라도 -t를 켜지 않으면 쉘 커서가 등장하지 않는다.
--rm: 컨테이너 종료 시 자동 삭제 옵션.
-p: 포트 노출. 컨테이너 포트와 호스트 포트를 연결할 때 사용한다. 
  - <호스트 포트>:<컨테이너 포트>, -p 80:80
  - <컨테이너 포트>, 단독으로 작성하면 호스트 포트는 랜덤으로 연결된다. 0.0.0.0:32768->80/tcp

-v: 볼륨 연결. 이 부분은 간단하게 설명하긴 어렵다. 다음 포스트에서...
--name: 컨테이너 이름을 설정한다.
```
