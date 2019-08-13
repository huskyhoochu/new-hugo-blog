---
title: "React Hooks와 Context를 이용한 설계 패턴"
description: "데이터 계층과 뷰 계층을 효과적으로 분리하기 위한 방법을 고민해보았습니다."
date: 2019-08-05T22:43:43+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["react"]
---

당신이 리액트를 즐겨 쓰는 사람이라면 끊임없이 변화하는 이 변덕스러운 도구를 감당하지 못했던 적도 있을 것이다. <a href="https://tech.wanted.co.kr/frontend/2018/01/07/react-fiber.html" target="_blank" rel="noopener noreferrer">Fiber(v16.0)</a>가 등장한 게 2017년 겨울이었는데 어느 새 최근 8월 8일 <a href="https://github.com/facebook/react/releases/tag/v16.9.0" target="_blank" rel="noopener noreferrer">v16.9</a> 정식 버전이 릴리즈되었다. 2년 사이에 리액트는 거의 모든 것이 바뀌었다. 렌더링 방식뿐만 아니라 패러다임 자체가 클래스형 컴포넌트에서 함수형 컴포넌트로 넘어갔다. 라이프사이클의 각 시점마다 유저가 개입하던 방식에서 Hooks를 이용해 상태 변수의 레퍼런스 변화를 추적하는 방식을 사용하게 되었다. 변화가 너무 빨랐던 탓일까? 여전히 대중들은 새 인터페이스에 적응하지 못한 듯하다. 시중에 유통되는 서적이나 튜토리얼 영상 대부분이 리덕스를 중심으로 클래스형 컴포넌트를 구축하는 예전 패턴을 벗어나지 못하고 있는 걸 보면 말이다.

코드 스플리팅, 메모이제이션도 그렇지만 상태 관리만큼은 더 이상 서드파티를 고려할 필요가 없을 정도로 리액트는 발전했다. v16.3 부터는 <a href="https://reactjs.org/blog/2018/03/29/react-v-16-3.html" target="_blank" rel="noopener noreferrer">Context API</a> 를 이용해 프로젝트 전체가 아닌 사용자가 원하는 범위 안에서 개별적으로 스토어를 구축할 수 있게 되었다. v16.8 에 정식 출시된 <a href="https://ko.reactjs.org/docs/hooks-intro.html" target="_blank" rel="noopener noreferrer">Hooks</a>를 이용하면 useState를 이용해 함수형 컴포넌트 안에서도 상태를 만들 수 있다. 심지어 기본 Hooks를 조합해 자신만의 커스텀 Hooks를 만들어 프로젝트 여기저기서 재사용이 가능하다. 내가 원하는 레시피로 구성된 상태 및 메서드 세트를 자유롭게 가져다 쓰는 것이다. 예를 들어 페이지네이션을 제공하는 커스텀 Hooks를 만든다고 생각해 보자. 아티클 목록과 페이지 단위 숫자를 인자로 제공하면 페이지네이션 Hooks는 현재 페이지, 슬라이스된 목록, 그리고 다음 페이지나 이전 페이지로 이동할 수 있게 하는 메서드를 리턴해준다. 청사진의 형태로 선언되어 있다가 컴포넌트 안에 할당되는 순간 일종의 캡슐화된 상태를 보유하게 된다.

문제는 리액트 측에서 베스트 프랙티스를 만들어주지 않는다는 것이다. 커뮤니티가 넓기에 유저들이 자기만의 방식을 만들게 내버려 두는 쪽을 택하는 것 같긴 하지만 짧은 시간 안에 수많은 새 개념이 도입된 상태에서 초심자들이 모든 도구를 자유자재로 사용하기란 쉬운 일이 아니다. 나 또한 리액트가 제공하는 도구들만 이용해서 상태 관리를 납득 가능한 방식으로 해내려고 1달 정도 삽질을 했다(...). 이제야 오늘 소개하려는 Context와 Hooks를 조합한 패턴을 자신 있게 쓸 수 있게 된 것 같다. 함수형 컴포넌트 세계에서, 메서드를 재사용하면서 지역적으로 공유 가능한 상태를 관리하는 방식이다.

#### Hooks만 쓰는 경우: 컴포넌트 간 상태 공유가 어려움

예시를 위해 페이지네이션 생성을 도와주는 Hooks 하나를 들고 왔다.

{{<highlight react "linenostart=1, linenos=inline">}}
// usePage.tsx

import React, { useMemo, useState } from 'react';

const usePage = (INIT_PAGE_VOLUME: number) => {
  const FIRST_PAGE = 1;
  const [currentPage, setCurrentPage] = useState<number>(FIRST_PAGE);
  const [PAGE_VOLUME, setPageVolume] = useState<number>(INIT_PAGE_VOLUME);
  const [list, setList] = useState<any[]>([]);

  // 리스트 데이터 추가
  function addListData(data: any[]): void {
    setList(data);
  }

  // 필터링 목록의 마지막 페이지
  const LAST_PAGE = useMemo(() => {
    const result = Math.ceil(list.length / PAGE_VOLUME);
    return result > 0 ? result : 1;
  }, [list]);

  // currentPage + pageVolume에 따라 페이지네이션
  function paginatedList(page: number): any[] {
    return list.slice((page - 1) * PAGE_VOLUME, page * PAGE_VOLUME);
  }

  // 페이지 변경
  function handlePage(e: React.BaseSyntheticEvent): void {
    setCurrentPage(parseInt(e.currentTarget.value, 10));
  }

  // 페이지 리셋
  function resetPage(): void {
    setCurrentPage(FIRST_PAGE);
  }

  return {
    FIRST_PAGE,
    LAST_PAGE,
    PAGE_VOLUME,
    addListData,
    currentPage,
    handlePage,
    paginatedList,
    resetPage,
    setPageVolume,
  };
};

export default usePage;
{{</highlight>}}

이 Hooks는 몇 가지 상태와 메서드를 제공한다. 


커스텀 훅 정의해서 컴포넌트에 직접 가져다 쓰면, 그 주변의 여러 컴포넌트가 상태를 받아다 써야 되는데 여기서 문제가 생긴다. 훅에서 정의된 상태는 스스로를 전파할 수 없고 반드시 자식 컴포넌트에게 props 형태로 물려주어야 한다. 자식에서 부모로 전달하는 건 불가능함. 그러다 보니 그 지역의 가장 부모인 컴포넌트가 모든 메서드와 상태를 전부 짊어지고 자식들한테 일일이 던져줘야 하는 문제 발생.

#### Context만 쓰는 경우: 지역적으로만 사용 가능

컨텍스트는 provider 이하 모든 컴포넌트가 컨텍스트 값을 공유할 수 있다. 이것은 장점이지만 컨텍스트에서 정의된 메서드는 재사용될 수 없으며 그 컨텍스트에서 정의한 형태로 유일하게 남겨진다. 이걸 극복하자고 프로젝트 전체를 감싸게 되면... 그럴거면 리덕스를 쓰지!

#### Hooks + Context => 메서드 재사용 + 상태 공유

재사용하려는 메서드는 hooks로 정의하고, 이 hook을 컨텍스트가 사용하게 함으로써 재사용과 상태 공유의 이점을 둘다 가져가는 것이 포인트.

다시 예제로 돌아오면, 커스텀 훅으로 정의된 폼 관련 상태와 메서드는 프로젝트의 어떤 지역에서도 재사용 가능함. 근데 이걸 컴포넌트가 직접 호출하는 게 아니라 지역 컴포넌트를 감싸고 있는 컨텍스트가 호출함. 그러면 컨텍스트는 커스텀 훅에 정의된 메서드와 상태를 프로바이더로 공급함. 이제 내부의 모든 컴포넌트는 자유롭게 그것들을 가져다 쓸 수 있음. 부모가 자식에게 일일이 물려 줄 필요 없음. 그러면서도 이 상태 공유는 정확하게 컨텍스트가 감싸는 범위 안에서만 이뤄짐. 캡슐화 가능. 프로젝트의 다른 영역에서 새로운 컨텍스트를 정의하고, 아까 썼던 커스텀 훅을 또 불러와도 상관이 없다.

