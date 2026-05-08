import 'package:flutter_flow_chart/flutter_flow_chart.dart';

/// Node type enum
enum BranchNodeType { event, choice, condition, result }

extension BranchNodeTypeExt on BranchNodeType {
  String get label {
    switch (this) {
      case BranchNodeType.event: return '이벤트';
      case BranchNodeType.choice: return '선택지';
      case BranchNodeType.condition: return '조건';
      case BranchNodeType.result: return '결과';
    }
  }
}

/// Custom data attached to each FlowElement
class BranchNodeData {
  final BranchNodeType type;
  final String description;
  final String? connectedPageId;
  final List<String> tags;

  const BranchNodeData({
    required this.type,
    this.description = '',
    this.connectedPageId,
    this.tags = const [],
  });

  BranchNodeData copyWith({
    BranchNodeType? type,
    String? description,
    String? connectedPageId,
    List<String>? tags,
  }) {
    return BranchNodeData(
      type: type ?? this.type,
      description: description ?? this.description,
      connectedPageId: connectedPageId ?? this.connectedPageId,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type.index,
        'description': description,
        'connectedPageId': connectedPageId,
        'tags': tags,
      };

  factory BranchNodeData.fromMap(Map<String, dynamic> map) => BranchNodeData(
        type: BranchNodeType.values[map['type'] as int? ?? 0],
        description: map['description'] as String? ?? '',
        connectedPageId: map['connectedPageId'] as String?,
        tags: List<String>.from(map['tags'] as List? ?? []),
      );
}

/// DataSerializer for BranchNodeData (required by flutter_flow_chart)
class BranchNodeDataSerializer
    with DataSerializer<BranchNodeData, Map<String, dynamic>> {
  @override
  Map<String, dynamic>? toJson(BranchNodeData? data) => data?.toMap();

  @override
  BranchNodeData? fromJson(Map<String, dynamic>? source) =>
      source == null ? null : BranchNodeData.fromMap(source);
}
