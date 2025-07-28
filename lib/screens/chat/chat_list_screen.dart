import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_finder_app/widgets/nav_helper.dart';
import '../../models/chat_message.dart';
import '../../models/chat_model.dart';
import '../../services/chat_api_service.dart';
import '../../services/websocket_service.dart';
import '../../widgets/custom_tab_bar.dart';
import 'chat_item.dart';
import '../../widgets/main_bottom_nav_bar.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _selectedTab = 0;
  final int _selectedBottomNav = 1;

  // Lấy instance singleton của services
  final ChatApiService _apiService = ChatApiService();
  final WebSocketService _webSocketService = WebSocketService();

  List<ChatModel> chats = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentUserId = 0;

  // StreamSubscription để lắng nghe tin nhắn
  StreamSubscription<ChatMessage>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndConnect();
  }

  Future<void> _loadUserDataAndConnect() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    if (userIdString != null) {
      setState(() {
        _currentUserId = int.tryParse(userIdString) ?? 0;
      });
    }

    await _loadChatRooms(); // Tải danh sách phòng chat

    // --- SỬA ĐỔI QUAN TRỌNG ---
    // Chỉ kết nối nếu chưa có kết nối nào được thiết lập
    if (!_webSocketService.isConnected) {
      _webSocketService.connect();
    }

    // Thiết lập listener
    _setupWebSocketListeners();
  }

  void _setupWebSocketListeners() {
    // Hủy subscription cũ nếu có
    _messageSubscription?.cancel();

    // Lắng nghe stream message từ service
    _messageSubscription = _webSocketService.onMessageReceived.listen((
      message,
    ) {
      print('=== CHAT LIST: MESSAGE RECEIVED, REFRESHING LIST ===');
      // Khi có tin nhắn mới, tải lại danh sách phòng để cập nhật
      if (mounted) {
        _loadChatRooms();
      }
    });

    _webSocketService.onError = (error) {
      print('WebSocket error in chat list: $error');
      // Có thể hiển thị SnackBar lỗi ở đây
    };
  }

  @override
  void dispose() {
    // Hủy subscription khi màn hình bị đóng để tránh memory leak
    _messageSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadChatRooms() async {
    if (_currentUserId == 0) return;
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final chatRooms = await _apiService.getChatRooms(_currentUserId);
      final chatModels = chatRooms
          .map((room) => ChatModel.fromChatRoom(room, _currentUserId))
          .toList();

      if (mounted) {
        setState(() {
          chats = chatModels;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onBottomNavTapped(int index) {
    handleMainNavTap(context, index);
  }

  // --- UI Code (không thay đổi nhiều) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (Phần UI của bạn giữ nguyên)
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Text(
                  'Trò chuyện',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black87),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          CustomTabBar(
            selectedIndex: _selectedTab,
            onTabSelected: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
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
                          onPressed: _loadChatRooms,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : chats.isEmpty
                ? const Center(
                    child: Text(
                      'No conversations yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      if (_selectedTab == 1 && !chats[index].isUnread)
                        return const SizedBox.shrink();
                      return ChatItem(chat: chats[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedBottomNav,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
