import 'chat_room.dart';

class ChatModel {
  final String avatarUrl;
  final String title;
  final String lastMessage;
  final String time;
  final bool isUnread;
  final String? roomId; // room id
  final int? participantId; // ID của người còn lại (recipient)

  ChatModel({
    required this.avatarUrl,
    required this.title,
    required this.lastMessage,
    required this.time,
    this.isUnread = false,
    this.roomId,
    this.participantId,
  });

  // Factory constructor để tạo từ ChatRoom
  factory ChatModel.fromChatRoom(ChatRoom room, int currentUserId) {
    // Lấy participantId là người còn lại, không phải mình
    int? participantId;
    final others = room.participantIds
        .where((id) => id != currentUserId)
        .toList();
    if (others.isNotEmpty) {
      participantId = others.first;
    } else {
      participantId = null;
    }
    return ChatModel(
      avatarUrl: room.participantAvatar ?? '',
      title: room.participantName ?? 'Unknown User',
      lastMessage: room.lastMessage ?? 'No messages yet',
      time: room.lastUpdated != null ? _formatTime(room.lastUpdated!) : '',
      isUnread: false,
      roomId: room.id,
      participantId: participantId,
    );
  }

  static String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    }
  }
}
