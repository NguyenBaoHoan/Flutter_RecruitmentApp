import 'package:flutter/material.dart';
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

  final ChatApiService _apiService = ChatApiService();
  final WebSocketService _webSocketService = WebSocketService();

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Mock current user ID (trong thực tế sẽ lấy từ authentication)
  final int _currentUserId = 3;

  @override
  void initState() {
    super.initState();
    print('=== FLUTTER DEBUG ===');
    print('ChatDetailScreen: Room ID: ${widget.chat.roomId}');
    print('ChatDetailScreen: Participant ID: ${widget.chat.participantId}');
    print('ChatDetailScreen: Title: ${widget.chat.title}');
    print('ChatDetailScreen: Current User ID: $_currentUserId');
    print('=== END FLUTTER DEBUG ===');

    _loadChatHistory();
    _setupWebSocket();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
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

      setState(() {
        _messages = messages;
        _isLoading = false;
      });

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _setupWebSocket() {
    print('=== WEBSOCKET CHAT DETAIL SETUP ===');
    print('Setting up WebSocket for chat detail...');

    _webSocketService.onConnected = () {
      print('=== WEBSOCKET CHAT DETAIL CONNECTED ===');
      print('WebSocket connected in chat detail');
      if (widget.chat.roomId != null) {
        print('Subscribing to room: ${widget.chat.roomId}');
        _webSocketService.subscribeToRoom(widget.chat.roomId!);
      } else {
        print('Room ID is null, cannot subscribe');
      }
      print('=== END WEBSOCKET CHAT DETAIL CONNECTED ===');
    };

    _webSocketService.onMessageReceived = (ChatMessage message) {
      print('=== RECEIVED MESSAGE ===');
      print('Message content: ${message.content}');
      print('Sender ID: ${message.senderId}');
      print('Recipient ID: ${message.recipientId}');
      print('Current User ID: $_currentUserId');
      print('=== END RECEIVED ===');

      setState(() {
        _messages.add(message);
      });
      _scrollToBottom();
    };

    _webSocketService.onError = (error) {
      print('=== WEBSOCKET CHAT DETAIL ERROR ===');
      print('WebSocket error in chat detail: $error');
      print('=== END WEBSOCKET CHAT DETAIL ERROR ===');
    };

    _webSocketService.onDisconnected = () {
      print('=== WEBSOCKET CHAT DETAIL DISCONNECTED ===');
      print('WebSocket disconnected in chat detail');
      print('=== END WEBSOCKET CHAT DETAIL DISCONNECTED ===');
    };

    print('Connecting to WebSocket...');
    _webSocketService.connect();
    print('=== END WEBSOCKET CHAT DETAIL SETUP ===');
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final recipientId = widget.chat.participantId!;
    final message = ChatMessage(
      content: messageText,
      senderId: _currentUserId,
      recipientId: recipientId,
      messageType: 'TEXT',
    );

    // Thêm vào danh sách để hiển thị ngay
    setState(() {
       _messages.insert(0, message);
    });

    print('=== SENDING MESSAGE ===');
    print('Message content: $messageText');
    print('Sender ID: $_currentUserId');
    print('Recipient ID: $recipientId');
    print('=== END SENDING ===');

    _webSocketService.sendMessage(message);
    _messageController.clear();
    _scrollToBottom();
  }

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
                    'Online', // Có thể thêm logic để check online status
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
          // Messages area
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $_errorMessage',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadChatHistory,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    reverse: true, // Thêm dòng này!
                    itemBuilder: (context, index) {
                      final message = _messages[index]; // KHÔNG đảo index nữa!
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
