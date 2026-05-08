# ForgeWrite (Solare) — Claude Code 판단 기준

## 이 프로젝트가 무엇인가
노션형 노트 + 세계관 창작 + TRPG 분기 설계를 하나로 합친 창작 플랫폼.
Hemisphere 게임 개발에 직접 사용하며 검증 후 공개 배포 예정.
앱 이름: Solare (솔라레) / 코드명: ForgeWrite

## 절대 변경하지 않는 결정들

### 스토리지
- 사용자 데이터는 무조건 Google Drive appDataFolder에 저장
- appDataFolder 외 일반 Drive 폴더 절대 사용 금지
- Firebase는 실시간 delta 중계만. 원본 데이터 저장 금지
- 로컬 SQLite는 Drive 동기화 전 임시 캐시 + 오프라인 작업용

### 인증
- Google OAuth만 사용. 자체 계정 시스템 만들지 말 것
- 최초 1회 로그인 후 signInSilently()로 자동 재인증
- 토큰은 flutter_secure_storage에만 저장

### 플랫폼
- Flutter 단일 코드베이스. 플랫폼별 분리 코드 최소화
- 웹/exe 분기는 core/platform/ 안에서만 처리
- 기능 제한 (웹 vs exe)은 feature_flags.dart로 관리

### 아키텍처
- Feature-first 폴더 구조. 기능별로 완전히 독립
- 각 feature는 data / domain / presentation 3레이어
- feature 간 직접 import 금지. 반드시 core/ 경유
- Riverpod으로만 상태 관리. StatefulWidget 최소화
- Notifier/AsyncNotifier 패턴 사용 (StateNotifier 아님, 단 기존 코드는 그대로 유지)

### AI / MCP
- 앱 자체에 AI 기능 없음
- AI는 오직 MCP 서버를 통해 Claude 앱에서만 연결
- MCP 서버는 Drive 읽기/쓰기만 담당. 비즈니스 로직 없음

## 판단이 필요할 때 우선순위
1. 데이터 안전 (유실 없을 것)
2. 오프라인 작동 (인터넷 없어도 작업 가능)
3. 단순함 (복잡한 해법보다 단순한 해법)
4. 성능
5. 코드 우아함

## 작업 범위 원칙
- 요청한 것만 만든다. 관련되어 보여도 요청 없으면 만들지 않는다
- 하나의 작업 = 하나의 feature 또는 하나의 레이어
- 완성되지 않은 기능은 TODO 주석으로 명시하고 stub으로 남긴다
- 테스트는 핵심 로직(sync, auth, drive)에만 작성한다
