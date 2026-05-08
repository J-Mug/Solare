class TimelineEvent {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final String date; // 자유 형식 날짜 (커스텀 달력 지원: "3년 2월", "Day 42" 등)
  final List<String> characterIds; // 연관 캐릭터 ID 목록
  final String? connectedPageId; // 연결된 노트 페이지
  final int sortOrder; // 정렬 순서
  final DateTime updatedAt;

  const TimelineEvent({
    required this.id,
    required this.projectId,
    required this.title,
    this.description = '',
    required this.date,
    this.characterIds = const [],
    this.connectedPageId,
    this.sortOrder = 0,
    required this.updatedAt,
  });

  factory TimelineEvent.create({
    required String projectId,
    required String title,
    required String date,
    int sortOrder = 0,
  }) {
    final now = DateTime.now();
    return TimelineEvent(
      id: 'tl_${now.millisecondsSinceEpoch}',
      projectId: projectId,
      title: title,
      date: date,
      sortOrder: sortOrder,
      updatedAt: now,
    );
  }

  factory TimelineEvent.fromJson(Map<String, dynamic> json) => TimelineEvent(
        id: json['id'] as String,
        projectId: json['project_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        date: json['date'] as String? ?? '',
        characterIds:
            List<String>.from(json['character_ids'] as List? ?? []),
        connectedPageId: json['connected_page_id'] as String?,
        sortOrder: json['sort_order'] as int? ?? 0,
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'title': title,
        'description': description,
        'date': date,
        'character_ids': characterIds,
        if (connectedPageId != null) 'connected_page_id': connectedPageId,
        'sort_order': sortOrder,
        'updated_at': updatedAt.toIso8601String(),
      };

  TimelineEvent copyWith({
    String? title,
    String? description,
    String? date,
    List<String>? characterIds,
    String? connectedPageId,
    int? sortOrder,
  }) =>
      TimelineEvent(
        id: id,
        projectId: projectId,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        characterIds: characterIds ?? this.characterIds,
        connectedPageId: connectedPageId ?? this.connectedPageId,
        sortOrder: sortOrder ?? this.sortOrder,
        updatedAt: DateTime.now(),
      );
}

class TimelineData {
  final String projectId;
  final List<TimelineEvent> events;
  final DateTime updatedAt;

  const TimelineData({
    required this.projectId,
    this.events = const [],
    required this.updatedAt,
  });

  factory TimelineData.empty(String projectId) =>
      TimelineData(projectId: projectId, updatedAt: DateTime.now());

  factory TimelineData.fromJson(Map<String, dynamic> json) => TimelineData(
        projectId: json['project_id'] as String,
        events: (json['events'] as List? ?? [])
            .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
            .toList(),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'project_id': projectId,
        'events': events.map((e) => e.toJson()).toList(),
        'updated_at': updatedAt.toIso8601String(),
      };

  TimelineData copyWith({List<TimelineEvent>? events}) => TimelineData(
        projectId: projectId,
        events: events ?? this.events,
        updatedAt: DateTime.now(),
      );
}
