# Solare

웹(Web)과 윈도우(Windows) 타겟을 지원하는 크로스 플랫폼 스토리 기획 및 협업 에디터입니다.
Riverpod, GoRouter, Drift, Google Drive appDataFolder 동기화 및 Firebase 하이브리드 엔진이 포함되어 있습니다.

## 🚀 로컬 개발 및 실행 방법

### 1. 환경 준비
- **Flutter SDK:** 3.5.0 이상 설치.
- **플랫폼 활성화:** 웹과 윈도우 타겟 환경을 활성화하세요.
  ```bash
  flutter config --enable-web
  flutter config --enable-windows-desktop
  ```

### 2. 패키지 설치 및 자동 생성 코드 빌드
앱에는 Riverpod Generator 및 Drift가 사용됩니다. 최초 실행 및 코드 변경 시 코드를 생성해야 합니다.
```bash
flutter pub get
dart run build_runner build -d
```

### 3. 디버그 모드 실행
- **Chrome 웹으로 실행:**
  ```bash
  flutter run -d chrome
  ```
- **Windows 데스크톱 앱으로 실행:**
  ```bash
  flutter run -d windows
  ```

---

## ☁️ 데이터 및 협업 아키텍처 안내

### 개인 프로젝트 (기본 모드)
* 설정 없이 Google 로그인만으로 즉시 사용 가능합니다.
* 모든 데이터는 오프라인 기기(SQLite)에 저장되며 개인 Google Drive `appDataFolder`에 안전하게 동기화됩니다.

### 팀 협업 프로젝트 (선택사항)
협업 기능은 선택 사항입니다. 다른 사람과 함께 작업하려면, 방장(팀장)이 직접 무료 Firebase 설정값을 제공해야 합니다.
1. [firebase.google.com](https://firebase.google.com/)에서 새 프로젝트를 생성합니다.
2. Realtime Database를 생성합니다(초기 테스트 모드 허용 권한 필요).
3. 앱 내 프로젝트 생성 시 **Database URL / API Key / Project ID**를 입력하여 연결을 활성화하세요.
> **보안상 팁:** Firebase 정보는 하드코딩되지 않고 각 방장의 환경에 로컬로 암호화 저장되어 동작합니다!

### 공용 초대 시스템 (개발자 설정)
앱 실행 시 우측 상단의 알림 및 팀원 초대 중계를 작동하려면, 본 빌드 옵션으로 공용 Firebase 정보를 주입해 주세요:

```bash
flutter run -d chrome \
  --dart-define=NOTIFICATION_FIREBASE_URL=https://your-public-db.firebaseio.com \
  --dart-define=NOTIFICATION_FIREBASE_KEY=your_api_key
```
