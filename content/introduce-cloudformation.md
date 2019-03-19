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

새롭게 나타난 문제는, 가상화된 인프라 환경이 온프레미스 환경을 다룰 때만큼이나 복잡해졌다는 것입니다. EC2 하나 열면서 '서버 배포가 간단해졌어!' 라고 말하는 시대는 이미 훌쩍 지났습니다.

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
      # CentOS-7 1901_01 서울 리전 머신 이미지
      # https://wiki.centos.org/Cloud/AWS
      ImageId: "ami-06cf2a72dadf92410"
      InstanceType: "t2.micro"
{{</highlight>}}

가장 간단한 형태의 EC2 배포 템플릿입니다. 최상위 'Resources' 항목 아래에 'MyInstance'라는 리소스를 정의한 뒤, 그 내부에 구체적인 주문사항을 적고 있죠.

{{<highlight yaml "linenostart=1, linenos=inline">}}
# s3.yml
---
Resources:
  MyS3Bucket:
    Type: "AWS::S3::Bucket"
    Properties: {}
{{</highlight>}}

극단적으로 단순한 S3 배포 템플릿입니다. S3는 아무 프로퍼티도 필수 사항이 아닌 모양이네요.

네, 집어치우고 코드만 보면 이게 전부입니다. 마우스로 '만들기'를 누르던 걸 코드로 대신하는 게 다예요. 하지만 

#### 참고자료
  
<a href="https://www.hpe.com/kr/ko/what-is/infrastructure-as-code.html" target="_blank" rel="noopener noreferrer">Infrastructure as Code란? – HPE 용어 정의 | HPE 대한민국</a>
  