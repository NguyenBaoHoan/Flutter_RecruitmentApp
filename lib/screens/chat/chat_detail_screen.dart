import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/chat_message.dart';
import '../../models/chat_model.dart';
import '../../services/chat_api_service.dart';
import '../../services/websocket_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatModel chat;
  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Lấy instance singleton của services
  final ChatApiService _apiService = ChatApiService();
  final WebSocketService _webSocketService = WebSocketService();

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentUserId = 0;

  // StreamSubscription để lắng nghe tin nhắn
  StreamSubscription<ChatMessage>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    if (userIdString != null) {
      _currentUserId = int.tryParse(userIdString) ?? 0;
    }

    await _loadChatHistory();
    _setupWebSocketListeners();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    // --- SỬA ĐỔI QUAN TRỌNG ---
    // Hủy subscription của phòng này khi thoát
    if (widget.chat.roomId != null) {
      _webSocketService.unsubscribeFromRoom(widget.chat.roomId!);
    }
    // Hủy lắng nghe stream
    _messageSubscription?.cancel();

    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    if (widget.chat.roomId == null) return;
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final messages = await _apiService.getChatHistory(widget.chat.roomId!);
      if (mounted) {
        setState(() {
          _messages = messages.reversed.toList(); // Đảo ngược để hiển thị đúng
          _isLoading = false;
        });
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToBottom(isAnimated: false),
      );
    } catch (e) {
      if (mounted)
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
    }
  }

  void _setupWebSocketListeners() {
    // --- SỬA ĐỔI QUAN TRỌNG ---
    if (widget.chat.roomId == null) return;

    // 1. Subscribe vào phòng chat này
    _webSocketService.subscribeToRoom(widget.chat.roomId!);

    // 2. Lắng nghe tất cả tin nhắn đến
    _messageSubscription?.cancel(); // Hủy sub cũ nếu có
    _messageSubscription = _webSocketService.onMessageReceived.listen((
      message,
    ) {
      // Chỉ xử lý tin nhắn của phòng chat hiện tại
      if (message.chatRoomId == widget.chat.roomId) {
        print('=== RECEIVED MESSAGE FOR THIS ROOM: ${message.content} ===');
        if (mounted) {
          setState(() {
            _messages.add(message); // Thêm vào cuối danh sách
          });
          _scrollToBottom();
        }
      }
    });
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || widget.chat.participantId == null) return;

    final message = ChatMessage(
      content: messageText,
      senderId: _currentUserId,
      recipientId: widget.chat.participantId!,
      messageType: 'TEXT',
      chatRoomId: widget.chat.roomId, // Gửi cả roomId để server tiện xử lý
    );

    _webSocketService.sendMessage(message);
    _messageController.clear();

    _scrollToBottom();
  }

  void _scrollToBottom({bool isAnimated = true}) {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      if (isAnimated) {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(position);
      }
    }
  }

  // --- UI Code (không thay đổi nhiều) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue[100],
              backgroundImage: widget.chat.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.chat.avatarUrl)
                  : null,
              child: widget.chat.avatarUrl.isEmpty
                  ? Icon(Icons.person, color: Colors.blue, size: 24)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 12, color: Colors.green[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text('Error: $_errorMessage'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    // reverse: false, // Bỏ reverse để cuộn từ trên xuống
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe = message.senderId == _currentUserId;
                      return _buildMessageBubble(message, isMe);
                    },
                  ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              backgroundImage: widget.chat.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.chat.avatarUrl)
                  : null,
              child: widget.chat.avatarUrl.isEmpty
                  ? Icon(Icons.person, color: Colors.blue, size: 16)
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, color: Colors.blue, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
