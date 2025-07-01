# STEP 1~3 - 마인크래프트 서버를 위한 스팟 인스턴스 시스템 만들기

1. 마인크래프트 서버는 `EC2 스팟 인스턴스` 위에서 실행되며, 게임 데이터는 인스턴스와 별도로 EBS 볼륨에 영속적으로 저장되어야 한다.

2. EC2 인스턴스는 서버 재생성 시에도 기존 `EBS 볼륨을 자동으로 마운트`하고 마인크래프트 서버를 자동으로 실행할 수 있어야 한다. 이를 위해 `User Data` 스크립트를 포함해야 한다.

3. 인프라는 하나의 VPC 내에 구성되며, EC2는 퍼블릭 서브넷에 배치되고, 외부에서의 `SSH(22)` 접속 및 `Minecraft 기본 포트(25565)` 접속을 허용해야 한다.

4. 서버 인스턴스에 문제가 발생하거나 스팟 인스턴스가 종료되는 경우를 감지하기 위해 `CloudWatch` 알람을 설정하고, 해당 이벤트 발생 시 `Lambda` 함수를 통해 `Discord Webhook`으로 알림을 전송해야 한다.

5. 마인크래프트 서버와 연동 가능한 `관계형 데이터베이스(RDS)`를 선택적으로 배포할 수 있도록 구성하라. 데이터베이스는 프라이빗 서브넷에 배치되어야 하며, 외부에서는 접근할 수 없고 EC2 인스턴스에서만 접근 가능해야 한다.

6. 데이터베이스의 `사용 여부(enable_db)`는 변수로 설정할 수 있어야 하며, false일 경우 RDS 리소스는 생성되지 않아야 한다.

7. 주요 설정 값은 `Terraform 변수`로 정의되어야 하며, 쉽게 변경 가능해야 한다.

## 변수 정리

| 변수명                        | 설명                                 | 예시값                                   |
| ----------------------------- | ------------------------------------ | ---------------------------------------- |
| `region`                      | AWS 리전                             | `"ap-northeast-2"`                       |
| `availability_zone`           | 가용 영역                            | `"ap-northeast-2a"`                      |
| `discord_webhook_url`         | Discord Webhook 주소                 | `"https://discord.com/api/webhooks/..."` |
| `instance_type`               | EC2 인스턴스 타입                    | `"t3.medium"`                            |
| `ami_id`                      | EC2에 사용할 AMI ID                  | `"ami-0a1234abcd"`                       |
| `key_name`                    | SSH 접속용 키페어 이름               | `"minecraft-key"`                        |
| `mc_port`                     | 마인크래프트 포트                    | `25565`                                  |
| `associate_public_ip_address` | 퍼블릭 IP 할당 여부                  | `true`                                   |
| `volume_size`                 | EBS 볼륨 크기 (GB)                   | `30`                                     |
| `volume_type`                 | EBS 볼륨 타입                        | `"gp3"`                                  |
| `enable_db`                   | RDS 사용 여부 (`true` / `false`)     | `true`                                   |
| `db_engine`                   | DB 엔진 종류 (`mysql` or `postgres`) | `"mysql"`                                |
| `db_identifier`               | RDS 인스턴스 식별자                  | `"minecraft-db"`                         |
| `db_instance_type`            | RDS 인스턴스 타입                    | `"db.t3.micro"`                          |
| `db_name`                     | 데이터베이스 이름                    | `"minecraft"`                            |
| `db_username`                 | DB 관리자 계정 이름                  | `"mcadmin"`                              |
| `db_password`                 | DB 관리자 비밀번호                   | `"securePW123"`                          |
| `db_allocated_storage`        | RDS 스토리지 크기 (GB)               | `20`                                     |
| `db_port`                     | RDS 포트                             | `3306` (MySQL)                           |
