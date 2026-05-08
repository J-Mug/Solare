class InviteModel {
  final String inviteId;
  final String projectId;
  final String projectName;
  final String ownerEmail;
  final String inviteeEmail;
  final DateTime timestamp;

  const InviteModel({
    required this.inviteId,
    required this.projectId,
    required this.projectName,
    required this.ownerEmail,
    required this.inviteeEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'inviteId': inviteId,
        'projectId': projectId,
        'projectName': projectName,
        'ownerEmail': ownerEmail,
        'inviteeEmail': inviteeEmail,
        'timestamp': timestamp.toIso8601String(),
      };

  factory InviteModel.fromMap(String id, Map<dynamic, dynamic> map) =>
      InviteModel(
        inviteId: id,
        projectId: map['projectId'] as String,
        projectName: map['projectName'] as String,
        ownerEmail: map['ownerEmail'] as String,
        inviteeEmail: map['inviteeEmail'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
}

/// Sanitizes an email for use as a Firebase key.
String sanitizeEmailKey(String email) =>
    email.replaceAll('.', '_').replaceAll('@', '__at__');
