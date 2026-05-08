# 확정된 기술 결정

## 패키지 결정

| 용도 | 패키지 | 버전 | 비고 |
|------|--------|------|------|
| 블록 에디터 | appflowy_editor | ^6.2.0 | Notion에 가까움 |
| 상태관리 | flutter_riverpod | ^2.5.1 | |
| 로컬 DB | drift | ^2.20.2 | 타입 안전 |
| 캔버스 | flutter_flow_chart | ^4.1.1 | 노드 연결 기능 내장 |
| 라우팅 | go_router | ^14.6.2 | |
| 토큰 저장 | flutter_secure_storage | ^9.2.2 | |
| 웹 인증 | google_sign_in | ^6.2.1 | 웹 전용 |
| 데스크톱 인증 | googleapis_auth | ^1.6.0 | clientViaUserConsent |

## 인증 결정

- 웹: google_sign_in (GoogleSignIn 객체는 kIsWeb일 때만 생성)
- 데스크톱(Windows): googleapis_auth의 clientViaUserConsent
  - 브라우저 오픈: rundll32 url.dll,FileProtocolHandler
  - 리디렉션 포트: googleapis_auth가 자동 관리
- 토큰: flutter_secure_storage에만 저장
- AuthUser: 플랫폼 무관한 공통 모델 (email 필드)

## 아키텍처 결정

- Riverpod StateNotifier 패턴 사용 (기존 auth/notes 코드 유지)
- Repository 패턴: interface + 구현체 분리
- Drive 파일 하나 = 데이터 단위 하나 (page, character 등)
  - 예외: branch_tree.json은 nodes+edges 전체를 하나의 파일로
- Delta 방식: 전체 파일 덮어쓰기 금지, 변경분만 전송
- 충돌 해결: updated_at 타임스탬프 최신 우선

## 플랫폼 결정

- 웹: flutter build web --release --base-href /solare/
- exe: flutter build windows --release
- 플랫폼 감지: kIsWeb (dart:io 사용 불가한 웹 대비)
- 웹 전용 제한 기능: feature_flags.dart에서 관리

## Google Cloud Console 설정

- 프로젝트 ID: 1086436477247
- 웹 Client ID: 1086436477247-fhm90l8ssa3nr3p0uj3ql0pm1q1pbohn.apps.googleusercontent.com
- 데스크톱 Client ID: 1086436477247-58a9rc6mvjje5pqjfaak37v9uni15ndr.apps.googleusercontent.com
- 활성화된 API: Google Drive API, People API
- OAuth 동의 화면: 테스트 모드 (배포 전 프로덕션 전환 필요)

## MCP 서버 결정

- 런타임: Node.js + TypeScript
- 배포: Railway 무료 티어
- 슬립 방지: GitHub Actions 10분 핑
- 인증: 사용자 Drive 토큰을 MCP 요청 헤더로 전달
