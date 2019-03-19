---
title: "AWS를 만드는 AWS, CloudFormation"
description: "코드를 작성해서 AWS 인프라를 구축하자! CloudFormation 기본 사용법 소개"
date: 2019-03-19T11:21:51+09:00
draft: true
authors: "Husky"
author_github: "https://github.com/huskyhoochu/"
images: ["/favicon_package/android-chrome-512x512.png"]
tags: ["AWS"]
---

#### CloudFormation 소개 영상: AWS Summit Seoul 2017

<!-- {{<youtube DpkB38n7Yv4>}} -->

#### Infrastructre as Code?

"모든 것을 가상화하라" 최근의 개발자 생태계는 모두 이 명제 아래로 헤쳐모이는 듯합니다. 어떤 실체를 개념화하고 추상화하는 것이 모든 학문과 기술의 출발점이긴 하지만... 클라우드 서비스와 Docker가 널리 쓰이면서 코드 레벨을 넘어선 인프라 레벨까지도 가상화에 열중하는 것이 지금의 추세입니다. DevOps, CI/CD 같은 개념도 인프라 영역을 손쉽게 제어할 수 있게 되면서 유명해진 셈인데요.

새롭게 나타난 문제는, 가상화된 인프라 환경이 온프레미스 환경을 다룰 때만큼이나 복잡해졌다는 것입니다. EC2 하나 띄우면서 '서버 배포가 간단해졌어!' 라고 말하는 시대는 이미 훌쩍 지났습니다.

![too-many-services](/introduce-cloudformation/too-many-services.png)

<p class="caption">AWS 전체 서비스 목록. 너무 많다</p>

요즘 AWS를 쓰다 보면 Elastic Beanstalk에 RDS, Elastic Cache를 연결하고, Lambda 함수에 API Gateway를 연결하고, 모든 리소스는 VPC 안에서 관리하는 와중에 CloudFront로 CDN 서비스를 개설하는 수준까지는 쓰게 되지요. 여기에 IAM 사용자 그룹 나눠서 권한 관리까지 하게 되면... 광활한 콘솔 환경 위에서 마우스 커서는 속절없이 헤매게 됩니다. 복잡도는 기하급수적으로 높아지죠.

**IT 인프라를 클릭 몇 번으로 만들 수 있다는 건 혁명이었습니다. 하지만 클릭을 수십, 수백 번 반복하게 된 시점부터는 새로운 전환이 필요해졌습니다.** 'Infrastructure as Code' 개념은 이런 수요를 안고 등장했습니다.

아이디어는 간단합니다. 요리 레시피를 종이 한 장에 정리하듯이, 내가 필요한 모든 리소스를 템플릿으로 작성해 실행하자는 것입니다. 이를 돕는 여러 프로비저닝 툴이 업계에는 많이 나와 있죠. 그 중에서 CloudFormation은 AWS가 만든, AWS 리소스를 템플릿으로 생성할 수 있도록 돕는 서비스입니다.


#### 집어치우고, 코드나 보여줘

{{<highlight yaml "linenostart=1, linenos=inline, hl_lines=3">}}
# ec2.yml
---
Resources:
  MyInstance:
    Type: "AWS::EC2::Instance"
    Properties:
      AvailabilityZone: "ap-northeast-2a"
      # Ubuntu 16.04 서울 리전 머신 이미지
      # https://cloud-images.ubuntu.com/locator/ec2/
      ImageId: "ami-79815217"
      InstanceType: "t2.micro"
{{</highlight>}}

가장 간단한 형태의 EC2 배포 템플릿입니다. 최상위 'Resources' 항목 아래에 'MyInstance'라는 리소스를 정의한 뒤, 내부에 구체적인 프로퍼티를 적고 있죠.

{{<highlight yaml "linenostart=1, linenos=inline">}}
# s3.yml
---
Resources:
  MyS3Bucket:
    Type: "AWS::S3::Bucket"
    Properties: {}
{{</highlight>}}

극단적으로 단순한 S3 배포 템플릿입니다. S3는 아무 프로퍼티도 필수 사항이 아닌 모양이네요.

네, 집어치우고 코드만 보면 이게 전부입니다. 마우스로 '만들기'를 누르던 걸 코드로 대신하는 게 다예요. 하지만 인프라를 템플릿으로 관리하는 것의 이점은 단순히 '편하다'에서 끝나지 않습니다.

###### 되돌아갈 수 있다

로드밸런서 리스너를 잘못 손대서 사이트 접속이 막혔는데 원래 상태가 어땠는지 기억이 안 난다면? EC2를 만들고 내부 환경 조성까지 다 끝냈는데 인스턴스 타입을 바꿔야 한다는 요청이 들어온다면? 손으로 직접 인프라를 만드는 상황이라면 눈앞이 깜깜해지겠죠. 만일 이 리소스들을 템플릿으로 생성했다면, 스택을 업데이트하는 것만으로 오류를 바로잡거나 내가 원하는 부분만 수정을 가할 수 있습니다. (그 어떤 프로퍼티를 수정해도 기존 리소스가 영향받지 않는 것은 아닙니다) 

###### 완벽하게 삭제할 수 있다

콘솔 환경에서도 거의 모든 서비스는 자유롭게 삭제가 가능합니다. 다만 기존에 설계한 인프라가 크고 복잡할수록 리소스를 생성하고 삭제하는 데 실수가 일어날 가능성이 커집니다. 하지만 템플릿으로 배포된 리소스들은 항상 템플릿을 통해 추적되므로 템플릿을 지우기만 하면 실수 없이 완벽한 삭제가 가능합니다.

###### 인프라 형상 관리

리포지토리에 템플릿을 저장해두기만 하면, 언제 어떤 환경에서든지 이전에 만든 것과 똑같은 구성의 환경을 몇 번이고 재생성할 수 있으며, 다른 유저가 만든 템플릿을 다운받아 내 환경에 적용하는 것도 얼마든지 가능합니다. 힘겹게 튜토리얼을 따라하면서 환경을 구축하는 게 아니라, 그냥 템플릿을 배포하기만 하면 끝나는 거죠.

#### 만들어 보자

위에 예시로 보여드린 가장 간단한 EC2 템플릿을 실제로 적용해보도록 하겠습니다.

![initial-page](/introduce-cloudformation/initial-page.png)
<p class="caption">리뉴얼된 페이지 환경이라 기존 페이지와 달라보일 수 있습니다</p>

CloudFormation 첫 화면에서 '스택 생성'이라는 화면을 눌러주세요.

![create-stack](/introduce-cloudformation/create-stack.png)

'템플릿 지정' 화면에서 '템플릿 파일 업로드'를 선택하시고, 위에 보여드린 EC2 템플릿을 `yaml` 파일로 만들어 업로드하시면 됩니다.

![configure-stack](/introduce-cloudformation/configure-stack.png)

이제부턴 '스택' 이라는 단어가 나타나는데요. '스택'이란 CloudFormation을 통해 배포가 완료된 템플릿 구현체를 말합니다. '스택 세부 정보 지정' 페이지에서는 스택의 이름을 설정하고 넘어갑시다.

![stack-option](/introduce-cloudformation/stack-option.png)

'스택 옵션 구성' 페이지에서는 태그나 권한, 정책, 롤백(스택 생성/업데이트가 실패했을 때 기존 상태로 복구하는 것), 알림 옵션 등등을 수정할 수 있습니다.

검토 단계에서 확인을 마치고 생성을 누르면...

![event-start](/introduce-cloudformation/event-start.png)

EC2 인스턴스가 생성되기 시작하는 걸 확인할 수 있습니다. EC2 대시보드에 가면 생성 중인 인스턴스의 모습을 볼 수 있습니다.

![pending-ec2](/introduce-cloudformation/pending-ec2.png)

#### 참고자료
  
<a href="https://www.hpe.com/kr/ko/what-is/infrastructure-as-code.html" target="_blank" rel="noopener noreferrer">Infrastructure as Code란? – HPE 용어 정의 | HPE 대한민국</a>

<a href="https://aws.amazon.com/ko/cloudformation/" target="_blank" rel="noopener noreferrer">AWS CloudFormation – 코드형 인프라 및 AWS 리소스 프로비저닝</a>


  