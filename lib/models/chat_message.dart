class ChatMessage {
  final String? id;
  final String content;
  final int senderId;
  final int recipientId;
  final String messageType;
  final String? chatRoomId;
  final String? senderName;
  final DateTime? createdAt;
  final bool isRead;

  ChatMessage({
    this.id,
    required this.content,
    required this.senderId,
    required this.recipientId,
    this.messageType = 'TEXT',
    this.chatRoomId,
    this.senderName,
    this.createdAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString(),
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? 0,
      recipientId: json['recipientId'] ?? 0,
      messageType: json['messageType'] ?? 'TEXT',
      chatRoomId: json['chatRoomId'],
      senderName: json['senderName'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderId': senderId,
      'recipientId': recipientId,
      'messageType': messageType,
    };
  }
} 