class ProjectModel {
  final String id;
  final String name;
  final bool isCollaborative;
  final String ownerEmail;
  final List<String> memberEmails;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.isCollaborative,
    required this.ownerEmail,
    required this.memberEmails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectModel.create({
    required String name,
    required String ownerEmail,
    bool isCollaborative = false,
  }) {
    final now = DateTime.now();
    return ProjectModel(
      id: 'project_${now.millisecondsSinceEpoch}',
      name: name,
      isCollaborative: isCollaborative,
      ownerEmail: ownerEmail,
      memberEmails: const [],
      createdAt: now,
      updatedAt: now,
    );
  }

  ProjectModel copyWith({
    String? name,
    bool? isCollaborative,
    List<String>? memberEmails,
    DateTime? updatedAt,
  }) =>
      ProjectModel(
        id: id,
        name: name ?? this.name,
        isCollaborative: isCollaborative ?? this.isCollaborative,
        ownerEmail: ownerEmail,
        memberEmails: memberEmails ?? this.memberEmails,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isCollaborative': isCollaborative,
        'ownerEmail': ownerEmail,
        'memberEmails': memberEmails,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ProjectModel.fromMap(Map<String, dynamic> map) => ProjectModel(
        id: map['id'] as String,
        name: map['name'] as String,
        isCollaborative: map['isCollaborative'] as bool? ?? false,
        ownerEmail: map['ownerEmail'] as String? ?? '',
        memberEmails: List<String>.from(map['memberEmails'] as List? ?? []),
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
