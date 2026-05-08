import '../firebase/firebase_config.dart';
import 'collab_repository.dart';
import 'invite_model.dart';

/// Firebase path: invites/{sanitizedEmail}/{inviteId}
class CollabRepositoryImpl implements CollabRepository {
  @override
  Future<void> sendInvite({
    required String projectId,
    required String projectName,
    required String ownerEmail,
    required String inviteeEmail,
  }) async {
    final key = sanitizeEmailKey(inviteeEmail);
    final ref = FirebaseConfig.dbRoot.child('invites/$key').push();
    final invite = InviteModel(
      inviteId: ref.key!,
      projectId: projectId,
      projectName: projectName,
      ownerEmail: ownerEmail,
      inviteeEmail: inviteeEmail,
      timestamp: DateTime.now(),
    );
    await ref.set(invite.toMap());
  }

  @override
  Future<List<InviteModel>> getPendingInvites(String email) async {
    if (email.isEmpty) return [];
    final key = sanitizeEmailKey(email);
    final snapshot =
        await FirebaseConfig.dbRoot.child('invites/$key').get();
    if (!snapshot.exists || snapshot.value == null) return [];
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((e) => InviteModel.fromMap(
              e.key as String,
              e.value as Map<dynamic, dynamic>,
            ))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> removeInvite({
    required String inviteId,
    required String inviteeEmail,
  }) async {
    final key = sanitizeEmailKey(inviteeEmail);
    await FirebaseConfig.dbRoot
        .child('invites/$key/$inviteId')
        .remove();
  }
}
