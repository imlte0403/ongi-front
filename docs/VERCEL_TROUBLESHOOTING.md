# Vercel 배포 문제 해결 가이드

## ❌ 문제: Build Command 실행 중 에러 (exit code 1)

```
Error: Command "chmod +x install-flutter.sh && ./install-flutter.sh" exited with 1
```

### 원인
- **Vercel 무료 플랜 빌드 타임아웃**: 45초
- Flutter SDK 다운로드 + 빌드 시간이 45초 초과
- 메모리 제한 (무료: 3GB, Pro: 8GB)

---

## ✅ 해결 방법

### 방법 1: GitHub Actions로 빌드 후 Vercel 배포 (권장) ⭐

GitHub Actions에서 빌드하고 결과물만 Vercel에 배포합니다.

#### 1. GitHub Secrets 설정

Vercel 대시보드에서 필요한 정보 가져오기:

1. **Vercel Token 생성**
   - [Vercel Dashboard](https://vercel.com/account/tokens) 이동
   - "Create Token" 클릭
   - 이름 입력 후 생성
   - 토큰 복사

2. **Project ID와 Org ID 확인**
   ```bash
   # 프로젝트 디렉토리에서
   vercel link
   cat .vercel/project.json
   ```
   또는 Vercel 프로젝트 설정에서:
   - Project Settings → General → Project ID
   - Settings → General → Organization ID

3. **GitHub Repository Secrets 추가**
   - GitHub 저장소 → Settings → Secrets and variables → Actions
   - "New repository secret" 클릭하여 추가:
     - `VERCEL_TOKEN`: Vercel 토큰
     - `VERCEL_ORG_ID`: Organization ID
     - `VERCEL_PROJECT_ID`: Project ID

#### 2. Vercel 프로젝트 설정 변경

Vercel 대시보드에서:
1. 프로젝트 Settings → Git
2. **"Ignored Build Step"** 설정:
   ```bash
   git diff HEAD^ HEAD --quiet . ':(exclude).github/workflows/*'
   ```
   이렇게 하면 Vercel에서는 빌드하지 않고 GitHub Actions만 사용합니다.

또는:

1. Settings → General → Build & Development Settings
2. **Framework Preset**: Other
3. **Build Command**: `echo "Built by GitHub Actions"`
4. **Output Directory**: `build/web`
5. **Install Command**: `echo "No install needed"`

#### 3. GitHub Actions 워크플로우

`.github/workflows/deploy.yml` 파일이 이미 생성되어 있습니다.

#### 4. 배포 테스트

```bash
git add .github/workflows/deploy.yml
git commit -m "feat: GitHub Actions를 통한 Vercel 배포 설정"
git push
```

---

### 방법 2: 로컬에서 빌드 후 배포

#### 1. 로컬에서 빌드

```bash
flutter build web --release
```

#### 2. Vercel 설정 변경

`vercel-static.json` 파일 사용:
```bash
# vercel.json을 백업하고 static 버전 사용
mv vercel.json vercel-build.json.backup
cp vercel-static.json vercel.json
```

#### 3. Vercel에서 설정

Vercel 프로젝트 Settings:
- **Build Command**: `echo "Static files only"`
- **Output Directory**: `build/web`
- **Install Command**: (비워둠)

#### 4. 배포

```bash
git add .
git commit -m "build: Flutter web build output"
git push
```

**주의**: `build/web` 디렉토리를 Git에 포함해야 합니다. `.gitignore` 수정:
```bash
# .gitignore에서 build/ 제거 또는 예외 추가
!build/web/
```

---

### 방법 3: Vercel Pro 플랜 업그레이드

Vercel Pro 플랜의 이점:
- 빌드 타임아웃: **15분**
- 메모리: **8GB**
- 함수 실행 시간: 300초

Pro 플랜이면 기존 `vercel.json` 설정 그대로 사용 가능합니다.

---

## 🔍 빌드 로그 확인 방법

상세한 에러 확인:
1. Vercel Dashboard → Deployments
2. 실패한 배포 클릭
3. Build Logs 확인
4. 정확한 에러 메시지 파악

일반적인 에러:
- `ETIMEDOUT`: 네트워크 타임아웃 (Flutter SDK 다운로드 실패)
- `ENOMEM`: 메모리 부족
- `Error: Command ... exited with 1`: 스크립트 실행 실패

---

## 📊 방법 비교

| 방법 | 장점 | 단점 | 추천도 |
|------|------|------|--------|
| **GitHub Actions** | - 무료<br>- 빌드 시간 제한 없음<br>- 캐싱 지원<br>- CI/CD 완전 자동화 | - 초기 설정 필요<br>- Secrets 관리 | ⭐⭐⭐⭐⭐ |
| **로컬 빌드** | - 설정 간단<br>- 빌드 환경 완전 제어 | - 수동 빌드 필요<br>- Git 저장소 크기 증가 | ⭐⭐⭐ |
| **Vercel Pro** | - 설정 변경 불필요<br>- 즉시 사용 가능 | - 월 $20 비용 | ⭐⭐ |

---

## 🎯 권장 워크플로우 (GitHub Actions)

```
코드 수정
    ↓
Git Push
    ↓
GitHub Actions 트리거
    ↓
Flutter 빌드 (GitHub 서버)
    ↓
build/web → Vercel 배포
    ↓
배포 완료! 🎉
```

**장점:**
- ✅ 빌드 시간 제한 없음 (GitHub Actions: 6시간)
- ✅ 무료 (GitHub Actions 무료 티어 사용)
- ✅ 완전 자동화
- ✅ 빌드 캐싱으로 빠른 빌드

---

## 🛠️ 추가 최적화

### .vercelignore 파일

불필요한 파일 업로드 방지로 배포 속도 향상:
```
lib/
test/
*.dart
docs/
```

### Flutter 빌드 최적화

```bash
# 웹 렌더러 선택
flutter build web --web-renderer canvaskit  # 더 나은 성능
flutter build web --web-renderer html       # 더 작은 크기

# Tree shaking
flutter build web --release --tree-shake-icons
```

---

## ❓ 자주 묻는 질문

**Q: GitHub Actions를 사용하면 Vercel이 필요한가요?**
A: 네, Vercel은 정적 파일 호스팅과 CDN을 제공합니다. GitHub Actions는 빌드만 담당합니다.

**Q: 빌드가 GitHub Actions에서도 실패하면?**
A: 로컬에서 `flutter build web --release` 실행해보고 에러 확인하세요.

**Q: Secrets 없이 배포할 수 있나요?**
A: 로컬 빌드 방법(방법 2)을 사용하면 Secrets 불필요합니다.

**Q: main 브랜치가 아닌 다른 브랜치도 배포하고 싶어요.**
A: `.github/workflows/deploy.yml`의 `branches` 섹션에 브랜치 추가하세요.

---

## 📚 관련 문서

- [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md) - 기본 배포 가이드
- [GitHub Actions 문서](https://docs.github.com/en/actions)
- [Vercel 문서](https://vercel.com/docs)
- [Flutter Web 배포](https://docs.flutter.dev/deployment/web)
