import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'collab_repository.dart';
import 'collab_repository_impl.dart';
import 'invite_model.dart';

export 'invite_model.dart';
export 'collab_repository.dart';

final collabRepositoryProvider =
    Provider<CollabRepository>((_) => CollabRepositoryImpl());

/// Pending invites for a given email address.
final pendingInvitesProvider = FutureProvider.autoDispose
    .family<List<InviteModel>, String>((ref, email) async {
  if (email.isEmpty) return [];
  return ref.watch(collabRepositoryProvider).getPendingInvites(email);
});

class CollabController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  CollabController(this._ref) : super(const AsyncData(null));

  CollabRepository get _repo => _ref.read(collabRepositoryProvider);

  Future<void> sendInvite({
    required String projectId,
    required String projectName,
    required String ownerEmail,
    required String inviteeEmail,
  }) async {
    state = const AsyncLoading();
    try {
      await _repo.sendInvite(
        projectId: projectId,
        projectName: projectName,
        ownerEmail: ownerEmail,
        inviteeEmail: inviteeEmail,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeInvite({
    required String inviteId,
    required String inviteeEmail,
  }) async {
    await _repo.removeInvite(
      inviteId: inviteId,
      inviteeEmail: inviteeEmail,
    );
    _ref.invalidate(pendingInvitesProvider(inviteeEmail));
  }
}

final collabControllerProvider =
    StateNotifierProvider<CollabController, AsyncValue<void>>(
  (ref) => CollabController(ref),
);
