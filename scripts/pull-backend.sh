#!/bin/bash
# 백엔드 소스 자동 풀 스크립트

set -e

# 백엔드 디렉토리 경로 (프론트엔드와 같은 레벨)
BACKEND_DIR="../ongi-back"

# 현재 스크립트 위치 기준으로 절대 경로 계산
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKEND_PATH="$PROJECT_ROOT/../ongi-back"

echo "📦 백엔드 소스 자동 풀 시작..."
echo "   백엔드 경로: $BACKEND_PATH"

# 백엔드 디렉토리 존재 확인
if [ ! -d "$BACKEND_PATH" ]; then
    echo "❌ 백엔드 디렉토리를 찾을 수 없습니다: $BACKEND_PATH"
    echo "   백엔드 저장소를 클론하거나 경로를 확인해주세요."
    exit 1
fi

# 백엔드 디렉토리로 이동
cd "$BACKEND_PATH"

# Git 저장소인지 확인
if [ ! -d ".git" ]; then
    echo "❌ Git 저장소가 아닙니다: $BACKEND_PATH"
    exit 1
fi

# 현재 브랜치 확인
CURRENT_BRANCH=$(git branch --show-current)
echo "   현재 브랜치: $CURRENT_BRANCH"

# 변경사항이 있는지 확인
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  백엔드 저장소에 커밋되지 않은 변경사항이 있습니다."
    echo "   변경사항을 스태시하거나 커밋한 후 다시 시도해주세요."
    read -p "   변경사항을 스태시하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git stash
        echo "✅ 변경사항을 스태시했습니다."
    else
        echo "❌ 취소되었습니다."
        exit 1
    fi
fi

# 최신 코드 풀
echo "🔄 최신 코드 가져오는 중..."
git fetch origin

# 현재 브랜치 업데이트
echo "📥 현재 브랜치 업데이트 중..."
git pull origin "$CURRENT_BRANCH"

echo "✅ 백엔드 소스 업데이트 완료!"
echo "   최신 커밋: $(git log -1 --oneline)"

