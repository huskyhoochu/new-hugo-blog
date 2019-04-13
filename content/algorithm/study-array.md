---
title: "[자료구조] 배열"
description: "자료구조와 함께 배우는 알고리즘 C 언어편"
date: 2019-04-13T16:34:07+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["book"]
---

#### 자료구조

자료구조란 자료를 효율적으로 이용하기 위해 컴퓨터에 저장하는 방식을 일컫는다.

#### 배열

같은 자료형인 변수 요소가 줄지어 모여 있는 형태이다. 자료형은 무엇이든 상관 없다.

#### 메모리 할당 기간과 동적 객체 생성

메모리 확보를 위해 제공되는 함수는 `calloc` 함수와 `malloc` 함수다.

- `calloc`:
  - 형식: `void *calloc(size_t nmemb, size_t size)`
  - 해설: 크기가 size인 자료가 nmemb개만큼 들어갈 메모리를 할당한다. 할당된 영역은 모든 비트가 0으로 초기화된다.
- `malloc`:
  - 형식: `void *malloc(size_t size)`
  - 해설: 크기가 size인 메모리를 할당한다. 할당된 메모리 값은 정의되지 않는다.
- `free`:
  - 형식: `void free(void *ptr)`
  - 해설: `ptr`이 가리키는 메모리를 해제한다.
  
#### C언어의 메모리 구조

프로그램의 메모리 영역은 크게 3가지로 나뉜다.

- 데이터(Data) 영역
  - 전역 변수와 정적 변수가 할당되는 영역
  - 프로그램을 시작하면 할당하고, 프로그램을 종료하면 메모리에서 해제함
- 스택(Stack) 영역
  - 함수 호출 시 생성되는 지역 변수와 매개변수가 저장되는 영역
  - 함수 호출이 완료되면 사라짐
- 힙(Heap) 영역
  - 필요에 따라 동적으로 메모리 할당

힙 영역은 동적 할당을 통해 생성된 동적 변수를 관리하기 위한 영역이다. 프로그램 실행 도중 `calloc`, `malloc` 함수가 호출되면 힙 영역에 메모리를 확보한다. 메모리를 다 사용했으면 해제해주어야 한다. 이게 제때 해제되지 않으면 메모리 성능 저하로 이어지게 되니 주의하자.

{{<highlight c "linenostart=1, linenos=inline">}}
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  // 메모리를 가리킬 포인터 변수 생성
  int *x;
  // 힙 영역에 메모리 할당하고 포인터 변수에 연결
  // int 자료형이 들어갈 만한 크기를 1개 할당함
  x = calloc(1, sizeof(int));
  if (x == NULL) {
    // 메모리 할당에 실패하면 경고
    puts("메모리 할당 실패");
  } else {
    // 성공했다면 포인터 변수에 정수 57을 입력한다
    *x = 57;
    // 힙 영역에 할당된 정수 57을 출력
    printf("*x = %d\n", *x);
    // 메모리 해제 후 종료
    free(x);
  }

  return 0;
}
{{</highlight>}}

#### 배열 요소의 최댓값 구하기

기준값을 배열 첫 요소로 잡은 뒤, 배열 전체를 순회하면서 기준값보다 큰 값이 나오면 기준값을 교체한다.

{{<highlight c>}}
// 기본 아이디어
max = a[0];
for (i = 1; i < n; i++>) {
  if (a[i] > max) max = a[i];
}
{{</highlight>}}

제대로 된 함수로 구현하면 다음과 같다.

{{<highlight c "linenostart=1, linenos=inline">}}
#include <stdio.h>
#include <stdlib.h>

// 배열의 최댓값 구하는 함수
// int a[]: 요소가 정수인 배열
// int n: 요소의 길이
int maxof(const int a[], int n) {
  int i;
  int max = a[0];
  // 배열을 순회하며 첫 기준값을 잡은 a[0]과 비교
  for (i = 1; i < n; i++) {
    // 기준값보다 큰 값이 나타나면 기준값을 교체
    if (a[i] > max) max = a[i];
  }

  return max;
}


int main(void) {
  int i;
  int *height; // 사람의 키를 나타내는 배열
  int number; // 사람 수, 곧 배열 길이를 나타내는 정수값
  printf("사람 수: ");
  scanf("%d", &number);
  // 입력받은 number 길이를 갖는 정수 배열 매모리 할당
  height = calloc(number, sizeof(int));
  printf("%d 사람의 키를 입력하세요.\n", number);
  // 배열 각 요소를 입력받음
  for (i = 0; i < number; i++) {
    printf("height[%d]", i);
    scanf("%d", &height[i]);
  }
  // maxof 함수를 이용해 최댓값 계산
  printf("최댓값은 %d입니다.\n", maxof(height, number));
  // 메모리 해제 후 종료
  free(height);

  return 0;
}
{{</highlight>}}

`maxof` 함수를 자세히 보자.

{{<highlight c>}}
int maxof(const int a[], int n)
{{</highlight>}}

함수 매개변수에 배열을 표기하면 (`a[]`) 배열 자체가 아니라 포인터를 선언하는 것과 같다. 포인터 `a`는 `height[0]`의 주소만 가리키게 되고, 함수는 배열의 길이를 알지 못한다. 그러므로 배열의 갯수를 알려주는 인수를 따로 받아야 한다. 이것이 `int n`이다.

매개변수에 붙이는 `const` 키워드는 함수가 주어진 배열에 새로운 값을 쓰지 못하게 막는다. '읽기 전용'이 되는 것이다.

#### 배열 요소를 역순으로 정렬하기

'1,2,3,4,5,6,7'로 된 배열을 '7,6,5,4,3,2,1'로 정렬하고자 한다. 첫번째 값과 마지막 값을 바꾸고, 이 작업을 배열의 중심부로 거듭하면 된다. 요소 갯수가 n인 배열을 역순 정렬하려면 n/2번 연산하면 된다. 간단한 아이디어는 다음과 같다.

{{<highlight c>}}
int i;
for (i = 0; i < n / 2; i++) {
  // 변수 t에 첫째 요소 대입
  int t = a[i];
  // 첫째 요소 자리에 마지막 요소 대입
  a[i] = a[n - i - 1];
  // 마지막 요소 자리에 변수 t 값(아까 복사해 둔 첫째 요소 값) 대입 
  a[n - i = 1] = t;
}
{{</highlight>}}

이것을 완성된 함수로 구현해보자. 반복되는 계산식은 함수 형식 매크로(function-like-macro)를 이용해 치환하자. 함수 형식 매크로는 따로 함수를 정의하는 것보다 성능 면에서 유리한데, 함수를 정의하면 매개 변수 값이 스택에 쌓이고 지워지는 작업이 거듭 발생하기 때문이다.

{{<highlight c "linenostart=1, linenos=inline">}}
#include <stdio.h>
#include <stdlib.h>

// 함수 형식 매크로 정의
// type 형 x와 y 교환
#define swap(type, x, y) do { type t = x; x = y; y = t; } while(0)

void ary_reverse(int a[], int n) {
  int i;
  for (i = 0; i < n / 2; i++) {
    // 이 부분이 컴파일 시에 매크로로 치환된다
    swap(int, a[i], a[n - i - 1]);
  }
}

int main(void) {
  int i;
  int *x; // 배열이 될 포인트 변수
  int nx; // 요소 갯수를 나타내는 정수

  printf("요소 갯수 : ");
  scanf("%d", &nx);
  // int 크기의 메모리를 nx 갯수만큼 동적 할당
  x = calloc(nx, sizeof(int));
  printf("%d개의 정수를 입력하세요.\n", nx);
  // 배열 값 입력
  for(i = 0; i < nx; i++) {
    printf("x[%d] : ", i);
    scanf("%d", &x[i]);
  }

  // 배열 역순 정렬
  ary_reverse(x, nx);
  printf("역순 정렬 완료\n");
  for (i = 0; i < nx; i++) {
    printf("x[%d] = %d\n", i, x[i]);
  }

  // 메모리 해제 후 종료
  free(x);
  return 0;
}
{{</highlight>}}

함수 형식 매크로를 do...while 구문으로 감싸는 이유는, 실제 코드에서 사용되는 세미콜론 때문이다. 함수 형식 매크로는 텍스트 단위로 단순 치환하는 것일 뿐이므로, do...while 구문 없이 계산식만 정의하게 되면 런타임 시에 세미콜론이 이중으로 들어갈 수 있다. 이게 부작용을 일으킬 수 있다.

{{<highlight c>}}
// do...while X
if (조건식) {
  // 세미콜론이 두번 들어가면서 if-else 구문 체인이 끊어진다
  { type t = x; x = y; y = t; };
} else {
  { type t = x; x = z; z = t; };
}

// do...while O
if (조건식) {
  // do...while 구문이 세미콜론을 필요로 하므로 if-else 체인이 유지된다
  do { type t = x; x = y; y = t; } while(0);
} else {
  do { type t = x; x = z; z = t; } while(0);
}
{{</highlight>}}


