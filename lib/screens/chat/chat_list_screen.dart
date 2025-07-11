import 'package:flutter/material.dart';
import 'package:job_finder_app/widgets/nav_helper.dart';
import '../../models/chat_model.dart';
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

  // Danh sách các cuộc trò chuyện mẫu
  final List<ChatModel> chats = [
    ChatModel(
      avatarUrl: '',
      title: 'System Notifications',
      lastMessage: 'Bạn đã thêm mong muốn tìm việc (Fullstack...',
      time: '06/26 20:15',
      isUnread: false,
    ),
    ChatModel(
      avatarUrl: '',
      title: 'Customer service',
      lastMessage: 'Xin chào user_85003, tôi là nhân viên chăm...',
      time: '06/26 20:13',
      isUnread: false,
    ),
  ];

  void _onBottomNavTapped(int index) {
    handleMainNavTap(context, index); // Không cần setState
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
            child: ListView.builder(
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
