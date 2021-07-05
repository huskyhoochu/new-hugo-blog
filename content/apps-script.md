---
title: "AppsScript를 이용해 구글시트 우편번호 입력 기능 만들기"
description: "네이버 검색결과를 크롤링하여 주소에서 우편번호 따내기"
date: 2021-07-05T10:18:16+09:00
draft: false
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["appsscript"]
---

#### AppsScript?

[Apps Script | Google Developers](https://developers.google.com/apps-script)

AppsScript는 구글 워크스페이스에서 제공하는 여러 가지 앱에 부가 기능을 추가할 수 있도록 도와주는 프로그래밍 도구이다. 언어는 자바스크립트의 형태를 띄고 있지만 브라우저도 nodejs도 아닌 자신만의 호스팅 환경을 구축해 쓰고 있다. 그래서 파일 확장자도 `.gs`이며, 활용하는 객체나 문법도 약간 다르다.

#### 특징

![syntax](/apps-script/syntax.png)

###### 오로지 function 단위 설계

위 사진으로 보다시피 AppsScript는 함수 단위로 설계되고 함수 단위로만 실행된다. 하나의 함수가 하나의 스크립트 형태로 각종 구글 앱에서 실행되는 형태를 갖고 있다.

###### 변수 선언

let이나 const를 쓰지 않고 var를 사용해 변수를 선언한다. let이나 const를 사용한다고 해서 오류가 나는 건 아니지만 공식 문서에서는 모두 var를 쓰고 있음을 알 수 있다.

###### 로그 찍는 방법

`console.log`를 사용하지 않고 `Logger.Log` 함수를 사용한다.

#### 실행법

구글 문서나 구글 시트 창에서 '도구' > '스크립트 편집기'를 클릭하면 그 문서를 위한 편집기가 열린다.

![docs](/apps-script/docs.png)

![sheets](/apps-script/sheets.png)

편집기는 다음과 같이 생겼다.

![code](/apps-script/code.png)

좌측 메뉴 바에는 위에서부터 스크립트의 개요, 코드 편집기, 원하는 시간대에 스크립트를 실행하도록 하는 트리거, 실행 기록, 설정 메뉴로 구성되어 있다.

구글 시트와의 연동은 무척 쉽다. 위의 코드 편집기처럼 두 개의 function을 만들면, 구글 시트에는 '매크로'라는 이름으로 두 개의 function을 사용할 수 있게 된다.

![select_macro](/apps-script/select_macro.png)

![import_macro](/apps-script/import_macro.png)

이제 '함수 추가' 버튼을 누르면 그 다음부터 시트에서 함수를 사용할 수 있게 된다.

![greeting](/apps-script/greeting.png)

'greeting' 함수를 사용한 모습이다.

#### 주소 값을 크롤링하여 우편번호 리턴하는 스크립트 짜기

네이버에는 특정한 주소와 함께 '영문주소' 라는 키워드를 넣고 검색하면 그 주소의 우편번호를 함께 검색해주는 기능이 있다.

![naver_postcode](/apps-script/naver_postcode.png)

만일 이 네이버 페이지를 AppsScript를 이용해 크롤링할 수 있다면, 주소 목록이 적힌 구글 시트에 우편번호를 자동으로 덧씌울 수 있는 스크립트를 만들 수 있을 것이다.

![postcode_code1](/apps-script/postcode_code1.png)

AppsScript에는 http 요청에 대한 결과값을 받아오기 위한 fetch 객체가 따로 정의되어 있다. 이 `UrlFetchApp` 객체를 이용하면 비동기 코드를 쓰지 않고도 html 소스를 받아올 수 있다.

그 다음으로는 HTML을 파싱하는 작업이 필요한데, node에서 폭넓게 쓰이는 [cherrio](https://github.com/cheeriojs/cheerio) 가 AppsScript 용으로도 포팅되어 있다. 우리는 cherrio 라이브러리를 우리 코드 에디터에 추가할 것이다.

[https://github.com/tani/cheeriogs](https://github.com/tani/cheeriogs)

이곳은 Cherrio를 AppsScript 라이브러리로 포팅한 리포지토리 주소이다. 이곳에 들어가보면 다음과 같은 코드가 있다.

Script ID: `1ReeQ6WO8kKNxoaA_O0XEQ589cIrRvEBA9qcWpNqdOP17i47u6N9M5Xh0`

이 스크립트 아이디는 AppsScript를 퍼블릭으로 배포하게 되면 발급되는 고유 키이다. 이 고유 키만 있으면 전세계 누구의 AppsScript 코드든지 공유받을 수 있다.

![click_lib](/apps-script/click_lib.png)

'라이브러리' 추가 버튼을 클릭하자.

![search_cherrio](/apps-script/search_cherrio.png)

그 후 복사한 스크립트 아이디를 붙여넣고 '조회'를 누르면 cherrio를 알맞게 검색했음을 알 수 있다. 버전은 시기에 따라 달라질 수 있다.

![load_cherrio](/apps-script/load_cherrio.png)

불러오기가 성공적으로 끝났다면 다음과 같이 라이브러리 목록에 cherrio가 뜨고, 코드 에디터에서도 cherrio를 사용할 수 있게 된다.

그러면 cherrio의 사용 방법에 따라 우편번호 출력 위치의 css selector를 따서 검색하기만 하면 원하는 결과를 얻을 수 있을 것이다.

크롬 디버거에서 원하는 DOM을 우측 클릭하여 css selector를 가져오자.

![select_css](/apps-script/select_css.png)

이 글을 쓰고 있는 현재 시점에서 selector는 다음과 같이 검색된다.

`#ds_result > div > table > tbody > tr > td.tc`

코드를 다음과 같이 완성한 뒤, 저장해보자.

![save_postcode](/apps-script/save_postcode.png)

![load_func](/apps-script/load_func.png)

그 후 '도구' > '매크로' > '가져오기' 를 통해 함수를 가져온다.

![final_result](/apps-script/final_result.png)

그러면 최종적으로 다음과 같은 결과를 얻을 수 있다!

#### 마치며

AppsScript는 특히 구글 시트에서 강점을 발휘할 수 있는 것 같다. 스프레드시트를 직접 제어할 수 있는 수많은 방법들이 있어서 엑셀에 날개를 달아줄 수 있다고 생각된다.











