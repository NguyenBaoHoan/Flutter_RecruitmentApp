import 'package:flutter/material.dart';
import 'package:job_finder_app/widgets/nav_helper.dart';
import '../../models/chat_model.dart';
import '../../services/chat_api_service.dart';
import '../../services/websocket_service.dart';
import '../../widgets/custom_tab_bar.dart';
import 'chat_item.dart';
import '../../widgets/main_bottom_nav_bar.dart';

// Màn hình danh sách chat chính
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // Chỉ số tab đang được chọn (vd: Tất cả / Chưa đọc)
  int _selectedTab = 0;

  // Chỉ số item được chọn ở bottom nav (vd: Home / Chat / Profile)
  final int _selectedBottomNav = 1; // Tab "Thông báo" là index 1

  // Services
  final ChatApiService _apiService = ChatApiService();
  final WebSocketService _webSocketService = WebSocketService();

  // State
  List<ChatModel> chats = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Mock current user ID (trong thực tế sẽ lấy từ authentication)
  final int _currentUserId = 3;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
    _setupWebSocket();
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    handleMainNavTap(context, index); // Không cần setState
  }

  // Load danh sách phòng chat từ backend
  Future<void> _loadChatRooms() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final chatRooms = await _apiService.getChatRooms(_currentUserId);
      final chatModels = chatRooms
          .map((room) => ChatModel.fromChatRoom(room, _currentUserId))
          .toList();

      setState(() {
        chats = chatModels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Setup WebSocket connection
  void _setupWebSocket() {
    _webSocketService.onConnected = () {
      print('WebSocket connected');
    };

    _webSocketService.onError = (error) {
      print('WebSocket error: $error');
    };

    _webSocketService.onDisconnected = () {
      print('WebSocket disconnected');
    };

    _webSocketService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // App bar tuỳ chỉnh
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          60,
        ), // <--- CHỈNH CHIỀU CAO APPBAR Ở ĐÂY
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ), // <--- CHỈNH LỀ TRONG APPBAR Ở ĐÂY
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 40,
                ), // <--- CHỈNH ĐỘ RỘNG CỦA KHOẢNG TRỐNG BÊN TRÁI
                const Text(
                  'Trò chuyện',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                // Nút tìm kiếm bên phải
                Container(
                  width: 60, // <--- CHỈNH KÍCH THƯỚC NÚT SEARCH
                  height: 60, // <--- CHỈNH KÍCH THƯỚC NÚT SEARCH
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

      // Phần thân: gồm tab bar + danh sách chat
      body: Column(
        children: [
          // CustomTabBar: tab tuỳ chỉnh do bạn tự làm
          CustomTabBar(
            selectedIndex: _selectedTab,
            onTabSelected: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),

          // Danh sách chat cuộn được
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
                      // Nếu đang ở tab "Chưa đọc" (giả sử index == 1) -> chỉ hiển thị các tin chưa đọc
                      if (_selectedTab == 1 && !chats[index].isUnread)
                        return const SizedBox.shrink();
                      return ChatItem(chat: chats[index]);
                    },
                  ),
          ),
        ],
      ),

      // Thanh điều hướng dưới
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedBottomNav,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
