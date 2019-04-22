---
title: "[자료구조] 구조체"
description: "자료구조와 함께 배우는 알고리즘 C 언어편"
date: 2019-04-21T13:32:25+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["book"]
---

#### 구조체

구조체는 임의의 자료형 요소를 조합해 다시 만든 자료구조이다.

{{<highlight c>}}
#include <stdio.h>
#define VMAX 21 // 시력의 최댓값 2.1 * 10

/*--- 신체검사 데이터형 ---*/

typedef struct {
  char name[20];
  int height;
  double vision;
} PhysCheck;

/*--- 키의 평균값을 구합니다 ---*/

double ave_height(const PhysCheck dat[], int n) {
  int i;
  double sum = 0;
  for(i = 0; i < n; i++) {
    sum += dat[i].height;
  }
  return sum / n;
}

/*--- 시력 분포를 구합니다 ---*/

void dist_vision(const PhysCheck dat[], int n, int dist[]) {
  int i;
  for(i = 0; i <VMAX; i++) {
    dist[i] = 0;
  }
  for(i = 0; i < n; i++) {
    if (dat[i].vision > 0.0 && dat[i].vision <= VMAX/10.0) {
      dist[(int)(dat[i].vision * 10)]++;
    }
  }
}

int main(void) {
  int i;
  // 자료형 정의
  PhysCheck x[] = {
    {"승형수", 176, 0.1},
    {"황진아", 173, 0.7},
    {"최윤미", 175, 2.0},
    {"홍현의", 171, 1.5},
    {"이수진", 168, 0.4},
    {"김영준", 174, 1.2},
    {"박용규", 169, 0.8},
  };

  int nx = sizeof(x) / sizeof(x[0]); // 총 인원 수
  int vdist [VMAX]; // 시력 분포
  puts("신체검사표");
  puts("이름 키 시력");
  puts("---------");
  for(i = 0; i < nx; i++) {
    printf("%-18.18s%4d%5.1f\n", x[i].name, x[i].height, x[i].vision);
  }
  printf("평균 키: %5.1f cm\n", ave_height(x, nx));
  dist_vision(x, nx, vdist);
  printf("\n시력 분포\n");
  for(i = 0; i < VMAX; i++) {
    printf("%3.1f ~ : %2d명\n", i/10.0, vdist[i]);
  }

  return 0;
}
{{</highlight>}}