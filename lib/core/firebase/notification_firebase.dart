import 'package:flutter/foundation.dart';

class NotificationFirebase {
  // 컴파일 시 주입되는 환경변수를 통해 API Key와 URL을 할당합니다.
  // flutter run --dart-define=NOTIFICATION_FIREBASE_URL=... 형식으로 사용.
  static const dbUrl = String.fromEnvironment('NOTIFICATION_FIREBASE_URL');
  static const apiKey = String.fromEnvironment('NOTIFICATION_FIREBASE_KEY');

  Future<void> sendInvite({
    required String recipientUid,
    required String projectId,
    required String projectName,
    required String ownerName,
    required String ownerUid,
    required String projectFirebaseUrl,
    required String projectFirebaseKey,
  }) async {
    if (dbUrl.isEmpty) {
      if (kDebugMode) print('공용 Firebase 설정이 누락되어 초대를 보낼 수 없습니다.');
      return;
    }
    // TODO: 공용 Firebase 연결 및 invites/{recipient_uid}/{invite_id} 경로에 저장
    print('초대 전송: $recipientUid 님에게 $projectName 프로젝트 알림 발송 중...');
  }

  Future<void> deleteInvite(String recipientUid, String inviteId) async {
    if (dbUrl.isEmpty) return;
    // TODO: 초대를 수락하거나 거절한 경우 공용 공간에서 삭제
  }
}
