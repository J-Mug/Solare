import 'package:flutter/material.dart';

enum MoodboardItemType { text, colorBlock, imageRef }

class MoodboardItem {
  final String id;
  final MoodboardItemType type;
  final double x;
  final double y;
  final double width;
  final double height;

  // text / colorBlock
  final String content;
  final int colorValue; // Color.value

  // imageRef
  final String? driveFileId; // Drive appDataFolder 내 이미지 파일 ID

  const MoodboardItem({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    this.width = 160,
    this.height = 100,
    this.content = '',
    this.colorValue = 0xFFFFFFFF,
    this.driveFileId,
  });

  factory MoodboardItem.fromJson(Map<String, dynamic> json) => MoodboardItem(
        id: json['id'] as String,
        type: MoodboardItemType.values.firstWhere(
            (t) => t.name == json['type'],
            orElse: () => MoodboardItemType.text),
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num?)?.toDouble() ?? 160,
        height: (json['height'] as num?)?.toDouble() ?? 100,
        content: json['content'] as String? ?? '',
        colorValue: json['color'] as int? ?? 0xFFFFFFFF,
        driveFileId: json['drive_file_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'content': content,
        'color': colorValue,
        if (driveFileId != null) 'drive_file_id': driveFileId,
      };

  MoodboardItem copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    String? content,
    int? colorValue,
  }) =>
      MoodboardItem(
        id: id,
        type: type,
        x: x ?? this.x,
        y: y ?? this.y,
        width: width ?? this.width,
        height: height ?? this.height,
        content: content ?? this.content,
        colorValue: colorValue ?? this.colorValue,
        driveFileId: driveFileId,
      );

  Color get color => Color(colorValue);
}

class MoodboardData {
  final String projectId;
  final List<MoodboardItem> items;
  final DateTime updatedAt;

  const MoodboardData({
    required this.projectId,
    this.items = const [],
    required this.updatedAt,
  });

  factory MoodboardData.empty(String projectId) => MoodboardData(
        projectId: projectId,
        updatedAt: DateTime.now(),
      );

  factory MoodboardData.fromJson(Map<String, dynamic> json) => MoodboardData(
        projectId: json['project_id'] as String,
        items: (json['items'] as List? ?? [])
            .map((e) => MoodboardItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'project_id': projectId,
        'items': items.map((i) => i.toJson()).toList(),
        'updated_at': updatedAt.toIso8601String(),
      };

  MoodboardData copyWith({List<MoodboardItem>? items}) => MoodboardData(
        projectId: projectId,
        items: items ?? this.items,
        updatedAt: DateTime.now(),
      );
}
