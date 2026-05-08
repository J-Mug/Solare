import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/collaboration/collab_provider.dart';

class InviteTeamDialog extends ConsumerStatefulWidget {
  final String projectId;
  final String projectName;
  final String ownerEmail;
  final List<String> memberEmails;

  const InviteTeamDialog({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.ownerEmail,
    required this.memberEmails,
  });

  @override
  ConsumerState<InviteTeamDialog> createState() => _InviteTeamDialogState();
}

class _InviteTeamDialogState extends ConsumerState<InviteTeamDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(collabControllerProvider.notifier).sendInvite(
          projectId: widget.projectId,
          projectName: widget.projectName,
          ownerEmail: widget.ownerEmail,
          inviteeEmail: _emailController.text.trim(),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(collabControllerProvider);

    return AlertDialog(
      title: const Text('팀원 초대'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '프로젝트: ${widget.projectName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (widget.memberEmails.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: widget.memberEmails
                    .map((e) => Chip(
                          label: Text(e,
                              style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '초대할 팀원 이메일',
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '이메일을 입력하세요';
                if (!v.contains('@')) return '올바른 이메일 형식이 아닙니다';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: state.isLoading ? null : _sendInvite,
          child: state.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('초대 보내기'),
        ),
      ],
    );
  }
}

