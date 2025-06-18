# simple-deploy-practice

도커 배포 연습을 위한 초간단 모노레포 저장소

# Simple Deploy Practice

GitHub Actions를 사용하여 EC2 Ubuntu 인스턴스에 접속해서 명령을 실행하고 결과를 확인하는 프로젝트입니다.

## 📋 목차

- [설정 방법](#설정-방법)
- [워크플로우 설명](#워크플로우-설명)
- [사용 방법](#사용-방법)
- [보안 고려사항](#보안-고려사항)

## 🔧 설정 방법

### 1. GitHub Secrets 설정

GitHub 저장소의 Settings > Secrets and variables > Actions에서 다음 시크릿을 추가하세요:

#### SSH 방식 사용 시:

```
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=ap-northeast-2
EC2_HOST=your_ec2_public_ip_or_domain
EC2_USER=ubuntu
```

#### SSM 방식 사용 시:

```
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=ap-northeast-2
EC2_INSTANCE_ID=i-1234567890abcdef0
```

### 2. EC2 인스턴스 설정

#### SSH 방식:

1. EC2 인스턴스에 SSH 키 페어 설정
2. 보안 그룹에서 GitHub Actions IP 허용 (또는 0.0.0.0/0 임시 허용)
3. SSH 서비스 활성화 확인

#### SSM 방식 (권장):

1. EC2 인스턴스에 SSM Agent 설치
2. IAM 역할에 `AmazonSSMManagedInstanceCore` 정책 연결
3. VPC에 SSM 엔드포인트 설정 (선택사항)

### 3. IAM 권한 설정

GitHub Actions에서 사용할 IAM 사용자에게 다음 권한을 부여하세요:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ssm:SendCommand",
        "ssm:GetCommandInvocation",
        "ssm:ListCommandInvocations"
      ],
      "Resource": "*"
    }
  ]
}
```

## 🔄 워크플로우 설명

### 1. SSH 방식 (`ec2-command.yml`)

- SSH 키를 동적으로 생성하여 EC2에 접속
- 직접적인 SSH 연결을 통한 명령 실행
- 간단하지만 보안 키 관리가 필요

### 2. SSM 방식 (`ec2-ssm-command.yml`) - 권장

- AWS Systems Manager를 통한 안전한 명령 실행
- SSH 키 관리 불필요
- AWS IAM을 통한 세밀한 권한 제어
- 명령 실행 결과를 구조화된 형태로 반환

## 🚀 사용 방법

### 1. 수동 실행

1. GitHub 저장소의 Actions 탭으로 이동
2. 원하는 워크플로우 선택
3. "Run workflow" 클릭
4. 실행할 명령어 입력 (선택사항)
5. "Run workflow" 클릭

### 2. 자동 실행

- `main` 브랜치에 푸시하거나
- Pull Request를 생성하면 자동으로 실행됩니다

### 3. 실행 예시

```bash
# 시스템 정보 확인
uname -a && cat /etc/os-release

# 프로세스 확인
ps aux | head -10

# 네트워크 연결 확인
netstat -tuln | head -10

# 로그 확인
tail -20 /var/log/syslog
```

## 🔒 보안 고려사항

### SSH 방식:

- ✅ SSH 키를 동적으로 생성하여 보안 강화
- ⚠️ EC2 보안 그룹에서 GitHub Actions IP 허용 필요
- ⚠️ SSH 키 관리 주의 필요

### SSM 방식:

- ✅ AWS IAM을 통한 세밀한 권한 제어
- ✅ SSH 키 관리 불필요
- ✅ AWS CloudTrail을 통한 감사 로그
- ✅ VPC 엔드포인트를 통한 프라이빗 통신 가능

## 📝 주의사항

1. **비용**: SSM 사용 시 추가 비용이 발생할 수 있습니다
2. **권한**: 최소 권한 원칙에 따라 필요한 권한만 부여하세요
3. **로그**: 민감한 정보가 로그에 노출되지 않도록 주의하세요
4. **네트워크**: 프로덕션 환경에서는 VPC 엔드포인트 사용을 권장합니다

## 🛠️ 문제 해결

### 일반적인 문제들:

1. **권한 오류**: IAM 권한 확인
2. **연결 실패**: 보안 그룹 및 네트워크 설정 확인
3. **명령 실행 실패**: EC2 인스턴스 상태 및 사용자 권한 확인

### 로그 확인:

- GitHub Actions 로그에서 상세한 오류 정보 확인
- AWS CloudWatch 로그에서 SSM 명령 실행 로그 확인
