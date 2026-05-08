import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/collaboration/collab_provider.dart';
import '../../../core/collaboration/invite_model.dart';

class PendingInvitesDialog extends ConsumerWidget {
  final String myEmail;

  /// Called when the user accepts an invite.
  /// The caller is responsible for creating/adding the project locally.
  final Future<void> Function(InviteModel invite)? onAccept;

  const PendingInvitesDialog({
    super.key,
    required this.myEmail,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitesAsync = ref.watch(pendingInvitesProvider(myEmail));

    return AlertDialog(
      title: const Text('협업 초대'),
      content: SizedBox(
        width: 360,
        child: invitesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('오류: $e'),
          data: (invites) {
            if (invites.isEmpty) {
              return const Text('대기 중인 초대가 없습니다.');
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: invites
                  .map((invite) => _InviteTile(
                        invite: invite,
                        myEmail: myEmail,
                        onAccept: onAccept,
                      ))
                  .toList(),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

class _InviteTile extends ConsumerWidget {
  final InviteModel invite;
  final String myEmail;
  final Future<void> Function(InviteModel)? onAccept;

  const _InviteTile({
    required this.invite,
    required this.myEmail,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(collabControllerProvider);

    return Card(
      child: ListTile(
        title: Text(invite.projectName),
        subtitle: Text('${invite.ownerEmail}님의 초대'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: state.isLoading
                  ? null
                  : () => ref
                      .read(collabControllerProvider.notifier)
                      .removeInvite(
                        inviteId: invite.inviteId,
                        inviteeEmail: myEmail,
                      ),
              child: const Text('거절'),
            ),
            const SizedBox(width: 4),
            FilledButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await onAccept?.call(invite);
                      await ref
                          .read(collabControllerProvider.notifier)
                          .removeInvite(
                            inviteId: invite.inviteId,
                            inviteeEmail: myEmail,
                          );
                    },
              child: const Text('수락'),
            ),
          ],
        ),
      ),
    );
  }
}
