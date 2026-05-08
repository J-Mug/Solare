import 'invite_model.dart';

abstract class CollabRepository {
  Future<void> sendInvite({
    required String projectId,
    required String projectName,
    required String ownerEmail,
    required String inviteeEmail,
  });

  Future<List<InviteModel>> getPendingInvites(String email);

  Future<void> removeInvite({
    required String inviteId,
    required String inviteeEmail,
  });
}
