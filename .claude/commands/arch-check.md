최근 수정된 코드의 아키텍처 규칙 준수 여부를 검사합니다.

$ARGUMENTS: 검사할 파일 경로 또는 feature 이름 (비어있으면 전체 lib/ 검사)

검사 항목:

**1. Feature 독립성**
- `lib/features/A/` 파일이 `lib/features/B/`를 직접 import하지 않는지
- core/ 경유 없는 cross-feature import가 있으면 경고

**2. Drive 경로**
- appDataFolder 이외 경로 사용 없는지
- 일반 Drive 폴더 경로 패턴(`/root`, `/My Drive`) 사용 없는지

**3. 상태관리**
- StatefulWidget 사용이 불필요한 곳에 있는지
- Riverpod 외 상태관리 패턴(setState 과다 사용 등) 없는지

**4. Firebase 사용**
- Firebase에 원본 데이터 저장 시도 없는지 (delta만 허용)
- `projects/{id}/deltas/` 외 경로 write 없는지

**5. 토큰/시크릿**
- 하드코딩된 API 키, 클라이언트 시크릿 없는지

각 위반사항은 파일:라인 형식으로 보고하고, 수정 방법을 제안하세요.
위반 없으면 "아키텍처 규칙 준수" 출력.
