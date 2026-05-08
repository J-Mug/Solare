class EpisodeModel {
  final String id;
  final String projectId;
  final String title;
  final int chapterNumber;
  final Map<String, dynamic> contentJson; // appflowy_editor document JSON
  final int wordCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EpisodeModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.chapterNumber = 0,
    Map<String, dynamic>? contentJson,
    this.wordCount = 0,
    required this.createdAt,
    required this.updatedAt,
  }) : contentJson = contentJson ?? const {};

  factory EpisodeModel.create({
    required String projectId,
    required String title,
    int chapterNumber = 0,
  }) {
    final now = DateTime.now();
    return EpisodeModel(
      id: 'ep_${now.millisecondsSinceEpoch}',
      projectId: projectId,
      title: title,
      chapterNumber: chapterNumber,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        id: json['id'] as String,
        projectId: json['project_id'] as String,
        title: json['title'] as String,
        chapterNumber: json['chapter_number'] as int? ?? 0,
        contentJson:
            (json['content'] as Map<String, dynamic>?) ?? const {},
        wordCount: json['word_count'] as int? ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'title': title,
        'chapter_number': chapterNumber,
        'content': contentJson,
        'word_count': wordCount,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  EpisodeModel copyWith({
    String? title,
    int? chapterNumber,
    Map<String, dynamic>? contentJson,
    int? wordCount,
  }) =>
      EpisodeModel(
        id: id,
        projectId: projectId,
        title: title ?? this.title,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        contentJson: contentJson ?? this.contentJson,
        wordCount: wordCount ?? this.wordCount,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

  /// 공백 기준 단어 수 / 한국어는 글자 수 기준으로도 계산
  static int countWords(String text) => text.trim().isEmpty ? 0 : text.trim().length;
}
