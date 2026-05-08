class PageModel {
  final String id;
  final String projectId;
  final String? parentId;
  final String title;
  final Map<String, dynamic> contentJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PageModel({
    required this.id,
    required this.projectId,
    this.parentId,
    this.title = '',
    Map<String, dynamic>? contentJson,
    required this.createdAt,
    required this.updatedAt,
  }) : contentJson = contentJson ?? const {};

  factory PageModel.create({
    required String projectId,
    String? parentId,
    String title = '제목 없음',
  }) {
    final now = DateTime.now();
    return PageModel(
      id: 'page_${now.millisecondsSinceEpoch}',
      projectId: projectId,
      parentId: parentId,
      title: title,
      contentJson: const {},
      createdAt: now,
      updatedAt: now,
    );
  }

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      parentId: json['parent_id'] as String?,
      title: json['title'] as String? ?? '',
      contentJson: (json['content'] as Map<String, dynamic>?) ?? const {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'parent_id': parentId,
        'title': title,
        'content': contentJson,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  PageModel copyWith({
    String? title,
    Map<String, dynamic>? contentJson,
    String? parentId,
  }) {
    return PageModel(
      id: id,
      projectId: projectId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
