class ChatModel {
  final String avatarUrl;
  final String title;
  final String lastMessage;
  final String time;
  final bool isUnread;

  ChatModel({
    required this.avatarUrl,
    required this.title,
    required this.lastMessage,
    required this.time,
    this.isUnread = false,
  });
}
