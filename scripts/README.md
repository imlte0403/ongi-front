# 스크립트 가이드

## 백엔드 소스 자동 풀

### 사용법

```bash
# 프로젝트 루트에서 실행
./scripts/pull-backend.sh
```

또는

```bash
bash scripts/pull-backend.sh
```

### 동작 방식

1. 백엔드 디렉토리 확인 (`../ongi-back`)
2. Git 저장소인지 확인
3. 커밋되지 않은 변경사항이 있으면 스태시 여부 확인
4. 최신 코드 풀 (`git pull`)

### 주의사항

- 백엔드 저장소가 `../ongi-back` 경로에 있어야 합니다
- 변경사항이 있으면 스태시하거나 커밋한 후 실행해야 합니다

### 자동화 (선택사항)

VS Code의 `tasks.json`에 추가하여 단축키로 실행할 수 있습니다:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Pull Backend",
      "type": "shell",
      "command": "${workspaceFolder}/scripts/pull-backend.sh",
      "problemMatcher": []
    }
  ]
}
```

