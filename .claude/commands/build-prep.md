배포 전 체크리스트를 실행합니다.

$ARGUMENTS: `web` 또는 `windows` 또는 `all` (기본값: all)

아래 항목들을 순서대로 확인하세요:

**공통**
- [ ] `pubspec.yaml` version 확인 (배포할 버전인지)
- [ ] `lib/` 내 TODO 주석 중 블로커급인 것 있는지 grep
- [ ] `String.fromEnvironment` 사용 중인 dart-define 키 목록 출력
- [ ] 하드코딩된 시크릿 없는지 `/arch-check` 수준으로 확인

**웹 (web 또는 all)**
- [ ] `web/index.html`에 Firebase config가 placeholder가 아닌지
- [ ] `.github/workflows/deploy-web.yml` 존재 확인
- [ ] base-href 설정이 `/Solare/`인지 확인

**Windows (windows 또는 all)**
- [ ] `.github/workflows/deploy-windows.yml` 존재 확인
- [ ] GitHub Secret `DESKTOP_CLIENT_SECRET` 필요 여부 안내
- [ ] 빌드 명령: `flutter build windows --release --dart-define=DESKTOP_CLIENT_SECRET=...`

체크 후 배포 준비 여부를 "준비됨" / "미준비 (이유)" 로 판정하세요.
