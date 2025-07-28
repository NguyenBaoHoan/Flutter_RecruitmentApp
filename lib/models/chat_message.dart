enum MessageStatus { sending, sent, delivered, read, failed }

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
  final MessageStatus status;
  final DateTime? readAt;

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
    this.status = MessageStatus.sending,
    this.readAt,
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
      status: MessageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['status'] ?? 'sending'),
        orElse: () => MessageStatus.sending,
      ),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderId': senderId,
      'recipientId': recipientId,
      'messageType': messageType,
      'chatRoomId': chatRoomId,
      'status': status.toString().split('.').last,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    int? senderId,
    int? recipientId,
    String? messageType,
    String? chatRoomId,
    String? senderName,
    DateTime? createdAt,
    bool? isRead,
    MessageStatus? status,
    DateTime? readAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      messageType: messageType ?? this.messageType,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderName: senderName ?? this.senderName,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      status: status ?? this.status,
      readAt: readAt ?? this.readAt,
    );
  }
}
