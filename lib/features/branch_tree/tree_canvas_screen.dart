import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/app_layout.dart';

class TreeCanvasScreen extends ConsumerWidget {
  final String projectId;

  const TreeCanvasScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      title: 'Branch Tree Canvas',
      showProjectSidebar: true,
      projectId: projectId,
      child: Center(
        child: Text('Interactive Flow Chart Canvas\n(flutter_flow_chart Placeholder)', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
