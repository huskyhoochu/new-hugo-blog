---
title: "[알고리즘 퍼즐 68] 03. 카드를 뒤집어라!"
description: "n장의 카드를 n-1 간격으로 뒤집을 때 마지막까지 뒤집히지 않는 카드의 갯수는?"
date: 2019-11-25T07:58:49+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["book"]
---

#### 들어가며

1에서 100까지 적힌 카드가 순서대로 놓여 있다. 첫 번째 사람이 2부터 1장 간격으로 카드를 뒤집는다. 그러면 2, 4, 6... 100번까지 뒤집힐 것이다. 그 다음 사람은 3부터 2장 간격으로 카드를 뒤집는다. 3, 6, 9... 가 될 것이다. 이때 이미 뒤집힌 카드는 다시 뒤집힌다.

이렇게 n번째 카드부터 n - 1 장 간격으로 더 이상 뒤집을 게 없을 때까지 카드를 뒤집으면, 끝까지 뒤집히지 않은 카드는 모두 몇 장일까?

#### 혼자 생각해보기

0이 100개가 있는 배열을 만들고, 계속 뒤집기 순회를 돌리다가 reverse_count가 0이 나올 때까지 거듭하면 어떨까?

{{<highlight js>}}
// 갯수가 100인 0 배열 만들기
const nums = (() => {
    const result = [];
    for (i = 1; i < 101; i++) {
        result.push(0);
    }
    return result;
})();

// 어떻게 순회해야 할지 모르고 헤맴
for (i = 0; i < nums.length; i++) {
    for (k = i; k < nums.length; k += i - 1) {
        console.log(k);
    }
}
{{</highlight>}}

#### 정답

더 이상 아무것도 안 떠올라서 정답을 금세 봤다. 파이썬 코드로만 되어 있어서 자바스크립트 코드로 번안했다.

{{<highlight js>}}
const N = 100;
// 모든 요소가 false인 배열
const cards = Array.from([...Array(N)], () => false);

// 2 ~ N까지 뒤집음
for (let i = 2; i < N + 1; i++) {
    // n - 1장 간격
    let j = i - 1; 
    while (j < cards.length) {
        // 뒤집기 = true로 만들기
        cards[i] = !cards[i];
        j += i;
    }
}

for (let k = 0; k < N; k++) {
    if (!cards[k]) {
        console.log(k + 1);
    }
}
{{</highlight>}}