class CharacterRelationship {
  final String targetId;
  final String type; // 'friend' | 'enemy' | 'family' | 'lover' | 'rival' | 'other'
  final String description;

  const CharacterRelationship({
    required this.targetId,
    required this.type,
    required this.description,
  });

  factory CharacterRelationship.fromJson(Map<String, dynamic> json) =>
      CharacterRelationship(
        targetId: json['target_id'] as String,
        type: json['type'] as String,
        description: json['description'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'target_id': targetId,
        'type': type,
        'description': description,
      };
}

class CharacterModel {
  final String id;
  final String projectId;
  final String name;
  final String? mbti;
  final String backstory;
  final List<String> habits;
  final List<String> traumas;
  final List<CharacterRelationship> relationships;
  final DateTime updatedAt;

  const CharacterModel({
    required this.id,
    required this.projectId,
    required this.name,
    this.mbti,
    this.backstory = '',
    this.habits = const [],
    this.traumas = const [],
    this.relationships = const [],
    required this.updatedAt,
  });

  factory CharacterModel.create({
    required String projectId,
    required String name,
  }) =>
      CharacterModel(
        id: _uuid(),
        projectId: projectId,
        name: name,
        updatedAt: DateTime.now(),
      );

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json['id'] as String,
        projectId: json['project_id'] as String,
        name: json['name'] as String,
        mbti: json['mbti'] as String?,
        backstory: json['backstory'] as String? ?? '',
        habits: List<String>.from(json['habits'] as List? ?? []),
        traumas: List<String>.from(json['traumas'] as List? ?? []),
        relationships: (json['relationships'] as List? ?? [])
            .map((e) =>
                CharacterRelationship.fromJson(e as Map<String, dynamic>))
            .toList(),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'name': name,
        if (mbti != null) 'mbti': mbti,
        'backstory': backstory,
        'habits': habits,
        'traumas': traumas,
        'relationships': relationships.map((r) => r.toJson()).toList(),
        'updated_at': updatedAt.toIso8601String(),
      };

  CharacterModel copyWith({
    String? name,
    String? mbti,
    bool clearMbti = false,
    String? backstory,
    List<String>? habits,
    List<String>? traumas,
    List<CharacterRelationship>? relationships,
  }) =>
      CharacterModel(
        id: id,
        projectId: projectId,
        name: name ?? this.name,
        mbti: clearMbti ? null : (mbti ?? this.mbti),
        backstory: backstory ?? this.backstory,
        habits: habits ?? this.habits,
        traumas: traumas ?? this.traumas,
        relationships: relationships ?? this.relationships,
        updatedAt: DateTime.now(),
      );
}

String _uuid() {
  final now = DateTime.now().microsecondsSinceEpoch;
  return 'char_${now}_${now.hashCode.abs()}';
}
