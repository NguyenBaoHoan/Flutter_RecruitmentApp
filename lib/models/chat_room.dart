class ChatRoom {
  final String id;
  final List<int> participantIds;
  final DateTime? lastUpdated;
  final String? lastMessage;
  final String? participantName;
  final String? participantAvatar;

  ChatRoom({
    required this.id,
    required this.participantIds,
    this.lastUpdated,
    this.lastMessage,
    this.participantName,
    this.participantAvatar,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    // Tách participantIds từ id dạng "2_3_4_5"
    String id = json['id'] ?? '';
    List<int> participantIds = id
        .split('_')
        .where((e) => e.isNotEmpty)
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();

    return ChatRoom(
      id: id,
      participantIds: participantIds,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
      lastMessage: json['lastMessage'],
      participantName: json['participantName'],
      participantAvatar: json['participantPhotoUrl'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'lastMessage': lastMessage,
      'participantName': participantName,
      'participantAvatar': participantAvatar,
    };
  }
}
