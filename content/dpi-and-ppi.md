---
title: "DPI와 PPI의 차이"
description: "이미지 최적화를 위해 알아야 할 개념인 DPI와 PPI에 대해 앏아봅시다"
date: 2021-03-26T09:12:26+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["web"]
---

#### DPI와 PPI의 개념

최근 레티나 디스플레이의 시대가 오면서 두 단위의 구분이 흐려졌지만, 본래 DPI와 PPI는 다른 영역에서 쓰이던 개념이었다. DPI는 아날로그 영역에서 인쇄물의 품질을 측략할 때 쓰는 단위로 Dots Per Inch, 즉 1인치당 얼마나 많은 점을 분사할 수 있느냐를 따지는 수치이고, PPI는 디지털 영역에서 픽셀 집적도를 측량하는 단위로 Pixel Per Inch, 즉 1인치당 얼마나 많은 픽셀이 들어가 있느냐를 따지는 수치이다.

#### 뭐가 다른가?

이게 왜 구분되어야 하는지를 살펴보자. 레티나 디스플레이 이전 시대의 모니터는 72ppi의 해상도가 대부분이었다. 하지만 그 당시에도 인쇄물을 위한 포토샵 작업은 이루어지고 있었다. 이때, 인쇄물을 미리 살펴보는 모니터의 영역에서는 픽셀 집적도에 한계가 있기 때문에 일정 이상의 화질을 표현할 수 없다. 그럼에도 인쇄물은 사람의 눈으로 도트를 식별 불가능한 300dpi 이상으로 저장되어야 인쇄가 정확하게 이루어지기 때문에 두 단위는 구분되어야 했던 것이다.

레티나 디스플레이의 영역으로 들어오면 두 단위의 구분은 흐릿해지긴 한다. 최근 스마트폰은 300ppi가량의 픽셀 집적도를 표현하는 경우도 많아져서, 이때에는 인쇄물 이미지를 직접 화면에 출력했을 때 동일한 결과를 볼 수 있을 것이다. 이론상으로는 그렇다.

다만 변수가 있다면 레티나 디스플레이는 픽셀과 화면을 1:1로 표현하지 않는다는 것이다. 픽셀과 화면을 1:1로 표현한다면 기존 인터페이스가 엄청나게 작아 보이는 현상이 일어날 것이기 때문이다. 이를 방지하기 위해 운영체제에서는 픽셀보다 화면을 두 배, 혹은 세 배 크게 확대하여 보여주는 스케일링 기법을 사용한다.

4K 모니터를 컴퓨터에 물렸을 때 두 배 스케일링을 하여 FHD 화면처럼 보이게 한다고 가정하자. 이 영역에서는 2픽셀을 1픽셀로 감안하여 화면에 출력하므로 일반 FHD모니터와 같은 128x128 이미지를 출력한다고 했을 때 4K 모니터는 256x256 픽셀 영역에 이미지를 띄우게 되는 셈이다. 그러면 이미지가 보다 흐릿해질 것이다.

![dpi-ppi](/dpi-ppi/dpi-ppi.png)

#### Next.js에서 이미지 최적화를 위한 SrcSet 셋업

Next.js에서는 10.0.0 버전부터 `next/image` 컴포넌트를 제공하고 있다. 유저가 `next/image`를 통해 이미지를 등록하면 next.js에서 자동으로 webp 포맷으로 컨버팅된 여러 크기의 srcSet을 만들어주는 기능이다.

[Basic Features: Image Optimization | Next.js](https://nextjs.org/docs/basic-features/image-optimization)

{{<highlight javascript>}}
import Image from 'next/image'

function Home() {
return (
    <>
        <h1>My Homepage</h1>
        <Image
        src="/logo.png"
        alt="Picture of the author"
        width={500}
        height={500}
        />
        <p>Welcome to my homepage!</p>
    </>
    )
}

export default Home
{{</highlight>}}

이렇게 작성한 코드는 다음과 같이 구현된다.

![next-image](/dpi-ppi/next-image.png)

뷰포트에 따라 다른 크기의 이미지를 제공할 수 있도록 srcSet이 자동으로 구현된다.

![network](/dpi-ppi/network.png)

png -> webp로 변환됨에 따라 25kb였던 이미지 크기가 9.1kb로 감소한 것을 볼 수 있다.



