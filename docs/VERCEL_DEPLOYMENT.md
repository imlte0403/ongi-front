# Vercel 배포 가이드

이 문서는 Flutter 웹 프로젝트를 Vercel에 배포하는 방법을 안내합니다.

## 🚀 방법 1: Vercel 웹사이트에서 GitHub 연동 배포 (권장)

### 장점
- 자동 배포(CI/CD) 설정
- 브랜치별 프리뷰 배포
- 간편한 도메인 관리
- 무료 SSL 인증서

### 배포 단계

#### 1. Vercel 계정 생성 및 로그인
1. [Vercel 웹사이트](https://vercel.com) 방문
2. GitHub 계정으로 로그인/가입

#### 2. 새 프로젝트 생성
1. Vercel 대시보드에서 **"Add New Project"** 클릭
2. GitHub에서 `ongi-front` 저장소 선택
3. **"Import"** 클릭

#### 3. 프로젝트 설정
프로젝트 설정 페이지에서 다음과 같이 구성:

**Framework Preset:** Other

**Build and Output Settings:**
- **Build Command:** `chmod +x install-flutter.sh && ./install-flutter.sh`
- **Output Directory:** `build/web`
- **Install Command:** (비워둠 - Flutter가 자체 설치됨)

**Root Directory:** `./` (기본값)

#### 4. 배포
1. **"Deploy"** 버튼 클릭
2. 빌드 로그 확인
3. 배포 완료 후 제공되는 URL 확인 (예: `https://ongi-front.vercel.app`)

#### 5. 자동 배포 설정 확인
- 이제 GitHub에 푸시할 때마다 자동으로 배포됩니다
- `main` 브랜치: Production 배포
- 다른 브랜치: Preview 배포

---

## 🛠️ 방법 2: Vercel CLI로 직접 배포

### 사전 준비
Node.js와 npm이 설치되어 있어야 합니다.

### 1. Vercel CLI 설치

```bash
npm install -g vercel
```

### 2. Vercel 로그인

```bash
vercel login
```

이메일 또는 GitHub 계정으로 로그인합니다.

### 3. 프로젝트 초기 배포

프로젝트 루트 디렉토리에서:

```bash
vercel
```

질문에 다음과 같이 답변:
- **Set up and deploy "~/ongi-front"?** `Y`
- **Which scope do you want to deploy to?** (본인 계정 선택)
- **Link to existing project?** `N`
- **What's your project's name?** `ongi-front` (또는 원하는 이름)
- **In which directory is your code located?** `./ `
- **Want to override the settings?** `Y`
  - **Build Command:** `chmod +x install-flutter.sh && ./install-flutter.sh`
  - **Output Directory:** `build/web`
  - **Development Command:** (Enter로 스킵)

### 4. Production 배포

```bash
vercel --prod
```

### 5. 로컬 빌드 후 배포 (선택사항)

Flutter가 로컬에 설치되어 있다면:

```bash
chmod +x deploy-local.sh
./deploy-local.sh
```

---

## 📋 현재 프로젝트 설정 정보

### vercel.json 설정
```json
{
  "buildCommand": "chmod +x install-flutter.sh && ./install-flutter.sh",
  "outputDirectory": "build/web",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ],
  "headers": [...]
}
```

### 빌드 프로세스
1. `install-flutter.sh` 스크립트 실행
   - Flutter SDK 3.24.5 다운로드
   - Git safe directory 설정
   - Flutter 패키지 설치 (`flutter pub get`)
   - Flutter 웹 빌드 (`flutter build web --release`)
2. `build/web` 디렉토리에 빌드 결과 생성
3. Vercel이 정적 파일 호스팅

---

## 🔧 빌드 문제 해결

### Flutter SDK 다운로드 오류
- Vercel의 빌드 타임아웃 확인 (무료 플랜: 45초)
- 필요시 Pro 플랜 고려 (빌드 타임아웃: 15분)

### Git safe directory 오류
- `install-flutter.sh`에 이미 설정되어 있음
- 오류 발생 시 스크립트 확인

### 빌드 메모리 부족
- Vercel Pro 플랜으로 업그레이드 (더 많은 메모리 제공)

### 패키지 설치 오류
```bash
# 로컬에서 확인
flutter pub get
flutter build web --release
```

---

## 🌐 배포 후 확인사항

### URL 확인
- Production: `https://<project-name>.vercel.app`
- Custom domain 설정 가능 (Vercel 대시보드에서)

### 환경 변수 설정 (필요시)
Vercel 대시보드 > Project Settings > Environment Variables

### 빌드 로그 확인
Vercel 대시보드 > Deployments > 특정 배포 클릭

---

## 📌 추천사항

1. **GitHub 연동 방식 사용** (방법 1)
   - 자동 배포로 개발 효율성 향상
   - 브랜치별 프리뷰로 변경사항 미리 확인

2. **Custom Domain 설정**
   - Vercel 대시보드에서 도메인 추가
   - DNS 설정 자동 안내

3. **환경별 배포 전략**
   - `main` 브랜치: Production
   - `develop` 브랜치: Staging
   - Feature 브랜치: Preview

4. **모니터링 설정**
   - Vercel Analytics 활성화
   - 빌드 실패 알림 설정

---

## 🆘 도움말

### Vercel 공식 문서
- [Vercel 문서](https://vercel.com/docs)
- [Flutter 배포 가이드](https://vercel.com/guides/deploying-flutter-with-vercel)

### 문제 발생 시
1. Vercel 대시보드에서 빌드 로그 확인
2. `install-flutter.sh` 스크립트 검토
3. 로컬에서 `flutter build web --release` 테스트

---

## ✅ 다음 단계

배포 완료 후:
1. 배포된 URL 테스트
2. 모바일/데스크톱 반응형 확인
3. 성능 최적화 검토
4. Custom domain 설정 (선택사항)
