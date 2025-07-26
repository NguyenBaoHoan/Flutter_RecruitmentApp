import 'package:flutter/material.dart';
import '../../../screens/profile/attach_cv_page.dart';
import '../../../screens/profile/my_works_page.dart';
import '../../../screens/profile/favorites_page.dart';
import '../../../screens/profile/career_expectations_page.dart';
import '../../../screens/profile/online_cv_page.dart';
import '../../screens/home/user_home_screen.dart';
import '../../widgets/nav_helper.dart';
import '../../widgets/main_bottom_nav_bar.dart';
import '../../../screens/profile/setting_screen.dart';

class HomePageProfile extends StatelessWidget {
  const HomePageProfile({super.key});

  final int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,
        leading: const SizedBox.shrink(), // Ẩn nút back mặc định
        title: const Text(
          'Của tôi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: Colors.black),
            onPressed: () {
              // Xử lý khi nhấn nút hỗ trợ
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(context),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildNavigationList(context), // Truyền context vào đây
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  // Phần hồ sơ người dùng
  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          // Ảnh đại diện
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.shade100, // Màu nền của avatar
            ),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.purple, // Màu icon person
            ),
          ),
          const SizedBox(height: 10),
          // Tên và nút chỉnh sửa
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nguyễn Văn Nghĩa',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  // Xử lý khi nhấn nút chỉnh sửa
                },
                child: const Icon(Icons.edit_outlined, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Mô tả CV
          const Text(
            'CV trực tuyến',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Phần thống kê (Đã trò chuyện, Đã gửi CV, Chờ Phỏng Vấn)
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Đã trò chuyện', '0'),
          _buildStatCard('Đã gửi CV', '0'),
          _buildStatCard('Chờ Phỏng Vấn', '0'),
        ],
      ),
    );
  }

  // Thẻ thống kê
  Widget _buildStatCard(String title, String count) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bo tròn góc
        ),
        elevation: 0, // Không có đổ bóng
        color: Colors.blue.shade50, // Màu nền của thẻ
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Danh sách các mục điều hướng
  Widget _buildNavigationList(BuildContext context) {
    // Nhận context
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildNavigationItem(
            context, // Truyền context
            Icons.description_outlined,
            'CV trực tuyến',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnlineCVPage()),
              );
            },
          ),
          _buildNavigationItem(
            context,
            Icons.attach_file_outlined,
            'Đính kèm CV',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AttachCVPage()),
              );
            },
          ),
          _buildNavigationItem(
            context,
            Icons.emoji_events_outlined,
            'Kỳ vọng nghề nghiệp',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CareerExpectationsPage(),
                ),
              );
            },
          ),
          _buildNavigationItem(
            context,
            Icons.article_outlined,
            'Tác phẩm của tôi',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyWorksPage()),
              );
            },
          ),
          _buildNavigationItem(context, Icons.favorite_outline, 'Thú vị', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
          }),
        ],
      ),
    );
  }

  // Mục điều hướng đơn lẻ
  Widget _buildNavigationItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bo tròn góc
      ),
      elevation: 0, // Không có đổ bóng
      color: Colors.white, // Màu nền của thẻ
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap, // Sử dụng callback onTap
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    handleMainNavTap(context, index);
  }
}
