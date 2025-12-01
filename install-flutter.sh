#!/bin/bash
set -e

# Flutter SDK 설치
FLUTTER_VERSION="3.38.3"
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

# 임시 디렉토리에 Flutter SDK 설치 (프로젝트 루트 오염 방지)
FLUTTER_TMP_DIR="/tmp/flutter-sdk-$$"
mkdir -p "$FLUTTER_TMP_DIR"
cd "$FLUTTER_TMP_DIR"

echo "📦 Flutter SDK 다운로드 중..."
curl -L "$FLUTTER_SDK_URL" | tar -xJ

# Git 소유권 오류 방지 설정 (Vercel 환경 대응)
echo "🔧 Git safe directory 설정 중..."
FLUTTER_DIR="$FLUTTER_TMP_DIR/flutter"
git config --global --add safe.directory "$FLUTTER_DIR"

# 프로젝트 디렉토리로 돌아가기
cd - > /dev/null

# PATH에 Flutter 추가
export PATH="$FLUTTER_DIR/bin:$PATH"

# Flutter 확인
echo "🔍 Flutter 설치 확인 중..."
flutter --version

# flutter doctor는 Git을 사용하므로 건너뛰기 (빌드에는 필수 아님)
# flutter doctor

# 의존성 설치
echo "📚 Flutter 패키지 설치 중..."
flutter pub get

# 빌드
echo "🏗️ Flutter Web 빌드 중..."
flutter build web --release

echo "✅ 빌드 완료!"

