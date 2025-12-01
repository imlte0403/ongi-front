#!/bin/bash
set -e

# Flutter SDK 설치
FLUTTER_VERSION="3.24.5"
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

echo "📦 Flutter SDK 다운로드 중..."
curl -L "$FLUTTER_SDK_URL" | tar -xJ

# PATH에 Flutter 추가
export PATH="$PWD/flutter/bin:$PATH"

# Flutter 확인
echo "🔍 Flutter 설치 확인 중..."
flutter --version
flutter doctor

# 의존성 설치
echo "📚 Flutter 패키지 설치 중..."
flutter pub get

# 빌드
echo "🏗️ Flutter Web 빌드 중..."
flutter build web --release

echo "✅ 빌드 완료!"

