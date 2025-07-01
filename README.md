# Terraform + AWS 인프라 학습 로드맵

## 🏗️ 1단계: 기초 설정

- [x] AWS 계정 + IAM 사용자 생성
- [x] Terraform 설치 및 기본 명령어 (`init`, `plan`, `apply`)
- [x] AWS CLI 설정

## 🌐 2단계: 네트워킹

- [x] VPC + 서브넷 생성 (퍼블릭/프라이빗)
- [ ] 인터넷 게이트웨이 + NAT 게이트웨이 + `Chain Security Group 기초` 학습
- [ ] 보안 그룹 설정

## 🖥️ 3단계: 컴퓨팅

- [x] EC2 인스턴스 + 웹서버 배포
- [ ] 스팟 인스턴스로 배포
- [ ] Fargate로 배포
- [ ] 로드밸런서 + Auto Scaling (고가용성)

## 🗃️ 4단계: 데이터베이스 & 스토리지

- [ ] RDS 인스턴스 생성
- [ ] S3 + CloudFront + WAF (정적 웹 서비스 배포)

## 🔧 5단계: 코드 관리

- [ ] 리소스별 파일 분리 (`vpc.tf`, `ec2.tf` 등)
- [ ] Remote State 설정 (S3 + DynamoDB)
- [ ] 팀 협업용 .tfstate 공유

## 🚀 6단계: 고급 기능

- [ ] Terraform 모듈 작성
- [ ] CodeDeploy 사용해보기

## 📊 7단계: 모니터링 & 보안

- [ ] CloudWatch 알람 설정 + Lamda로 주 메신저로 전달
- [ ] IAM 역할/정책 최적화
- [ ] 비용 모니터링 + 최적화 경험

## 🎯 최종 프로젝트

- [ ] 3-Tier 웹앱 인프라 구축 (ALB + EC2 + RDS)
- [ ] AWS의 공동 책임 모델 학습
