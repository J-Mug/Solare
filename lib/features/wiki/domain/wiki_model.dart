class WikiEntry {
  final String id;
  final String projectId;
  final String title;
  final String category; // 'world' | 'faction' | 'place' | 'item' | 'event' | 'other'
  final Map<String, dynamic> contentJson; // appflowy_editor document JSON
  final List<String> internalLinks; // [[링크]] 파싱 결과
  final DateTime updatedAt;

  const WikiEntry({
    required this.id,
    required this.projectId,
    required this.title,
    this.category = 'other',
    Map<String, dynamic>? contentJson,
    this.internalLinks = const [],
    required this.updatedAt,
  }) : contentJson = contentJson ?? const {};

  factory WikiEntry.create({
    required String projectId,
    required String title,
    String category = 'other',
  }) {
    final now = DateTime.now();
    return WikiEntry(
      id: 'wiki_${now.millisecondsSinceEpoch}',
      projectId: projectId,
      title: title,
      category: category,
      updatedAt: now,
    );
  }

  factory WikiEntry.fromJson(Map<String, dynamic> json) => WikiEntry(
        id: json['id'] as String,
        projectId: json['project_id'] as String,
        title: json['title'] as String,
        category: json['category'] as String? ?? 'other',
        contentJson:
            (json['content'] as Map<String, dynamic>?) ?? const {},
        internalLinks:
            List<String>.from(json['internal_links'] as List? ?? []),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'title': title,
        'category': category,
        'content': contentJson,
        'internal_links': internalLinks,
        'updated_at': updatedAt.toIso8601String(),
      };

  WikiEntry copyWith({
    String? title,
    String? category,
    Map<String, dynamic>? contentJson,
    List<String>? internalLinks,
  }) =>
      WikiEntry(
        id: id,
        projectId: projectId,
        title: title ?? this.title,
        category: category ?? this.category,
        contentJson: contentJson ?? this.contentJson,
        internalLinks: internalLinks ?? this.internalLinks,
        updatedAt: DateTime.now(),
      );

  /// [[링크]] 패턴에서 링크 목록 추출
  static List<String> parseLinks(String text) {
    final pattern = RegExp(r'\[\[(.+?)\]\]');
    return pattern.allMatches(text).map((m) => m.group(1)!).toList();
  }
}
