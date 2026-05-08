# Solare (ForgeWrite) 아키텍처

## 데이터 흐름 전체

사용자 입력
    ↓
Presentation (Flutter Widget)
    ↓
Domain (Riverpod Provider + UseCase)
    ↓
Data (Repository)
    ├─ LocalRepository → SQLite (즉시 저장)
    └─ DriveRepository → Google Drive (3초 debounce)
         ↓ (동시에)
    FirebaseRepository → Firebase (즉시, delta만)

## 실시간 협업 흐름

내 편집
    ↓ 즉시
Firebase delta 전송 → 상대방 화면 반영
    ↓ 3초 후
Drive 저장 → Firebase delta 삭제

## 레이어 책임

Presentation: UI만. 비즈니스 로직 없음
Domain: 비즈니스 규칙. 외부 의존성 없음
Data: Drive/Firebase/SQLite 구현체
Core: 전역 서비스 (Auth, Sync, Platform)

## Feature 독립성

각 feature는 자신의 data/domain/presentation을 가짐
feature A가 feature B를 직접 import하면 안 됨
공유 데이터는 core/db 또는 Drive 파일로 교환

## 폴더 구조

lib/
├─ core/
│    ├─ auth/          ← Google OAuth (web: google_sign_in, desktop: googleapis_auth)
│    ├─ drive/         ← Drive API 클라이언트 (appDataFolder 전용)
│    ├─ firebase/      ← Firebase 클라이언트 (delta 중계만)
│    ├─ db/            ← SQLite (Drift, 로컬 캐시)
│    ├─ sync/          ← SyncEngine (debounce Drive 저장)
│    ├─ router/        ← go_router 라우팅
│    └─ platform/      ← 웹/exe 분기 처리
│
├─ features/
│    ├─ notes/         ← 노트 시스템 (✅ 완료)
│    ├─ branch_tree/   ← 분기 수형도 (🔄 진행 중)
│    ├─ characters/    ← 캐릭터 시트 (Phase 2)
│    ├─ wiki/          ← 세계관 위키 (Phase 2)
│    ├─ episodes/      ← 에피소드 에디터 (Phase 2)
│    ├─ moodboard/     ← 무드보드 exe 전용 (Phase 2)
│    ├─ timeline/      ← 타임라인 (Phase 2)
│    └─ collaboration/ ← 협업 초대/권한 (Phase 1)
│
└─ shared/
     ├─ widgets/
     └─ utils/
