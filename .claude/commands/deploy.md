Solare를 배포합니다.

$ARGUMENTS 형식: `[커밋 메시지]` (선택 — 비어있으면 변경 내용 기반으로 자동 생성)
태그 배포: `v1.0.0 [커밋 메시지]` 형식이면 Windows exe 릴리즈도 함께 진행

## 실행 순서

1. `git status`로 변경된 파일 확인
2. 변경사항이 없으면 "배포할 변경사항이 없습니다" 출력 후 중단
3. 커밋 메시지 결정:
   - $ARGUMENTS에 메시지가 있으면 그대로 사용
   - 없으면 변경된 파일 목록 보고 한 줄 요약 자동 생성
4. 아래 명령어 순서대로 실행:
   ```
   git add .
   git commit -m "[커밋 메시지]"
   git push origin main
   ```
5. $ARGUMENTS가 `v`로 시작하는 버전 태그를 포함하면 추가로:
   ```
   git tag [버전]
   git push origin [버전]
   ```
   → GitHub Actions deploy-windows.yml이 exe 빌드 + Releases 업로드 자동 실행

## 완료 후 출력
```
배포 완료
- 웹: https://j-mug.github.io/Solare/ (Actions 완료까지 약 2~3분)
- 커밋: [커밋 해시] [메시지]
- Windows 릴리즈: [태그 있으면 표시 / 없으면 생략]
```
