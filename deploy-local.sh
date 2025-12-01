#!/bin/bash
# 로컬에서 빌드 후 Vercel에 배포하는 스크립트

set -e

echo "🏗️ Flutter Web 빌드 중..."
flutter build web --release

echo "📦 Vercel에 배포 중..."
vercel --prod

echo "✅ 배포 완료!"

