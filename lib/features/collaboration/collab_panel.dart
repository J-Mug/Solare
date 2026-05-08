import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_provider.dart';
import 'presentation/invite_team_dialog.dart';

/// Shows collaboration info and invite controls for a project.
/// [projectId], [projectName], [ownerEmail], [memberEmails] describe the project.
class CollabPanel extends ConsumerWidget {
  final String projectId;
  final String projectName;
  final String ownerEmail;
  final List<String> memberEmails;

  const CollabPanel({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.ownerEmail,
    required this.memberEmails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myEmail = ref.watch(authProvider).user?.email ?? '';
    final isOwner = ownerEmail == myEmail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.group),
          title: const Text('협업 멤버'),
          trailing: isOwner
              ? IconButton(
                  icon: const Icon(Icons.person_add),
                  tooltip: '팀원 초대',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => InviteTeamDialog(
                      projectId: projectId,
                      projectName: projectName,
                      ownerEmail: ownerEmail,
                      memberEmails: memberEmails,
                    ),
                  ),
                )
              : null,
        ),
        if (memberEmails.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('아직 초대된 팀원이 없습니다.',
                style: TextStyle(color: Colors.grey)),
          )
        else
          ...memberEmails.map(
            (email) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(email),
              dense: true,
            ),
          ),
      ],
    );
  }
}

