# Solare 검증 체크리스트

> Phase 1 + Phase 2 코드 완성 후 실제 동작 검증
> 순서대로 진행. 앞 단계 실패하면 해당 단계 수정 후 다시 시작.

---

## 0. 빌드 확인 (가장 먼저)

- [ ] `flutter pub get` 오류 없음
- [ ] `flutter build web --release --base-href /Solare/` 빌드 성공
- [ ] `flutter build windows --release --dart-define=DESKTOP_CLIENT_SECRET=...` 빌드 성공
- [ ] 빌드 경고 중 치명적인 것 없음 (unused import 정도는 무시)

---

## 1. 인증

### 웹 (Chrome)
- [ ] `https://j-mug.github.io/Solare/` 접속 → 로그인 화면 표시
- [ ] Google 로그인 버튼 클릭 → Google OAuth 팝업 정상 열림
- [ ] 로그인 완료 → 자동으로 `/projects` 페이지로 이동
- [ ] 새로고침 → 자동 재인증 (로그인 화면으로 돌아가지 않음)
- [ ] 로그아웃 → `/` 로그인 화면으로 이동

### Windows exe
- [ ] `solare.exe` 실행 → 로그인 화면
- [ ] 로그인 클릭 → 시스템 기본 브라우저에서 Google OAuth 열림
- [ ] 로그인 완료 → 앱에서 자동으로 `/projects`로 이동
- [ ] 앱 재시작 → 자동 재인증 (로그인 없이 바로 `/projects`)

---

## 2. 프로젝트 관리

- [ ] 프로젝트 생성 (개인 유형) → 목록에 표시
- [ ] 프로젝트 생성 (협업 유형) → 팀원 초대 UI 표시
- [ ] 프로젝트 삭제 → 목록에서 제거
- [ ] 앱 재시작 → 프로젝트 목록 유지 (Drive에서 로드)
- [ ] 프로젝트 클릭 → ProjectDetail 화면 (기능 그리드 표시)

---

## 3. 노트 (Phase 1)

- [ ] 노트 화면 접속 (`/projects/:id/notes`)
- [ ] 새 페이지 생성 → 목록에 추가
- [ ] 페이지 제목 편집 → 저장 후 목록에 반영
- [ ] 페이지 내용 편집 → 3초 후 자동 저장 (저장 중 표시)
- [ ] 하위 페이지 생성 → 트리에서 중첩 표시
- [ ] 앱 재시작 → 노트 데이터 유지
- [ ] Drive에서 직접 확인: `appDataFolder/projects/{id}/notes/*.json` 파일 존재

---

## 4. 분기 수형도 (Phase 1)

- [ ] 수형도 화면 접속 (`/projects/:id/tree`)
- [ ] 빈 캔버스 클릭 → 노드 추가 다이얼로그
- [ ] 노드 타입 선택 (event/choice/condition/result) → 색상/모양 다름
- [ ] 노드 드래그 → 위치 이동
- [ ] 노드 연결 (핸들 드래그) → 화살표 생성
- [ ] 노드 길게 누르기 → 편집/삭제 메뉴
- [ ] 노드에 연결된 노트 페이지 설정 → 클릭 시 해당 노트로 이동
- [ ] Drive에서 확인: `appDataFolder/projects/{id}/branch_tree.json` 존재

---

## 5. 캐릭터 (Phase 2)

- [ ] 캐릭터 목록 화면 접속 (`/projects/:id/characters`)
- [ ] 캐릭터 생성 → 목록에 추가
- [ ] 캐릭터 편집 - 기본 정보 탭:
  - [ ] 이름, MBTI, 배경 이야기 입력 → 저장
- [ ] 캐릭터 편집 - 습관/트라우마 탭:
  - [ ] 습관 추가/삭제
  - [ ] 트라우마 추가/삭제
- [ ] 캐릭터 편집 - 관계 탭:
  - [ ] 다른 캐릭터와 관계 추가
  - [ ] 관계 타입 선택 (친구/적/가족 등)
  - [ ] 관계 삭제
- [ ] 앱 재시작 → 캐릭터 데이터 유지
- [ ] Drive: `appDataFolder/projects/{id}/characters/*.json` 존재

---

## 6. 위키 (Phase 2)

- [ ] 위키 목록 화면 접속 (`/projects/:id/wiki`)
- [ ] 항목 생성 (카테고리 선택) → 목록 카테고리별 그룹 표시
- [ ] 항목 편집:
  - [ ] 제목 변경 → 저장
  - [ ] 내용 입력 (appflowy_editor) → 3초 후 자동 저장
  - [ ] `[[다른항목]]` 형식으로 내부 링크 작성
  - [ ] 링크 아이콘 클릭 → 링크 목록 팝업
  - [ ] 존재하는 항목 링크 → 클릭 시 해당 항목 이동
  - [ ] 존재하지 않는 항목 링크 → 주황색 경고 아이콘
- [ ] Drive: `appDataFolder/projects/{id}/wiki/*.json` 존재

---

## 7. 에피소드 (Phase 2)

- [ ] 에피소드 목록 화면 접속 (`/projects/:id/episodes`)
- [ ] 에피소드 생성 (제목 + 회차 번호) → 회차 순 정렬
- [ ] 에피소드 편집:
  - [ ] 내용 입력 → 하단 글자 수 카운터 실시간 업데이트
  - [ ] 3초 후 자동 저장
- [ ] Drive: `appDataFolder/projects/{id}/episodes/*.json` 존재

---

## 8. 무드보드 (Phase 2, exe 전용)

### 웹
- [ ] 무드보드 메뉴 없음 또는 "PC 앱에서 사용 가능" 안내

### exe
- [ ] 무드보드 화면 접속 (`/projects/:id/moodboard`)
- [ ] 텍스트 블록 추가 → 캔버스에 표시
- [ ] 색상 블록 추가 → 랜덤 색상 블록 표시
- [ ] 블록 드래그 → 위치 이동
- [ ] 블록 길게 누르기 → 삭제 메뉴
- [ ] Drive: `appDataFolder/projects/{id}/moodboard.json` 존재

---

## 9. 타임라인 (Phase 2)

- [ ] 타임라인 화면 접속 (`/projects/:id/timeline`)
- [ ] 이벤트 추가 (제목 + 날짜 + 정렬 순서) → 순서대로 표시
- [ ] 이벤트 편집 → 내용 변경
- [ ] 이벤트 삭제
- [ ] 날짜 형식 자유 입력 ("Day 1", "3년 2월", "2025-03-01" 등)
- [ ] Drive: `appDataFolder/projects/{id}/timeline.json` 존재

---

## 10. 실시간 협업 (Phase 1, 선택)

> 두 기기/브라우저로 동시 접속 필요

- [ ] 협업 프로젝트 생성 → 팀원 이메일 초대
- [ ] 팀원이 앱 열었을 때 초대 알림 팝업
- [ ] 팀원 수락 → 동일 프로젝트 접근
- [ ] 한 쪽에서 노트 편집 → 상대방 화면 자동 반영 (3초 내)
- [ ] Firebase Console에서 `projects/{id}/deltas/` 경로 delta 확인

---

## 11. 오프라인 동작 (Phase 1, 선택)

- [ ] 인터넷 끊기 → 앱 계속 사용 가능
- [ ] 오프라인 편집 → 로컬 저장
- [ ] 인터넷 복구 → Drive 자동 동기화

---

## 12. 배포

### 웹 (GitHub Pages)
- [ ] `git push origin main` → GitHub Actions 자동 실행
- [ ] Actions 완료 → `https://j-mug.github.io/Solare/` 업데이트 확인
- [ ] Google OAuth 동의 화면에 `https://j-mug.github.io` authorized origins 등록 확인

### Windows exe
- [ ] `git tag v1.0.0 && git push origin v1.0.0`
- [ ] GitHub Actions deploy-windows.yml 실행
- [ ] GitHub Releases에 `solare-windows-v1.0.0.zip` 업로드 확인
- [ ] zip 다운로드 → 압축 해제 → `solare.exe` 실행 정상

---

## 버그 우선순위 기준

**블로커** (출시 전 필수 수정):
- 로그인 안 됨
- 데이터 저장/로드 안 됨
- 앱 크래시

**높음** (출시 후 빠른 수정):
- 기능은 동작하지만 데이터 손실 가능성
- 자동 저장 미작동

**낮음** (여유 있을 때):
- UI 미세 정렬
- 성능 개선
