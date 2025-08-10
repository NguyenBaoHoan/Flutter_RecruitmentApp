import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/theme_provider.dart';
import '../../widgets/main_bottom_nav_bar.dart';
import '../../widgets/nav_helper.dart';
import '../profile/attach_cv_page.dart';
import '../profile/career_expectations_page.dart';
import '../profile/favorites_page.dart';
import '../profile/my_works_page.dart';
import '../profile/online_cv_page.dart';
import '../profile/setting_screen.dart';

class HomePageProfile extends StatefulWidget {
  const HomePageProfile({super.key});

  @override
  State<HomePageProfile> createState() => _HomePageProfileState();
}

class _HomePageProfileState extends State<HomePageProfile> {
  final int _selectedIndex = 2;
  String _userName = 'Người dùng';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Người dùng';
      _userEmail = prefs.getString('user_email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy theme và themeProvider để sử dụng
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      // <<< SỬA ĐỔI >>> AppBar sẽ tự động đổi màu
      appBar: AppBar(
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: const Text(
          'Của tôi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Nút chuyển theme (giữ nguyên)
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined),
            onPressed: () {
              // Xử lý khi nhấn nút hỗ trợ
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
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
            _buildStatsSection(context), // <<< SỬA ĐỔI >>> Truyền context
            const SizedBox(height: 20),
            _buildNavigationList(context),
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
      // <<< SỬA ĐỔI >>> Xóa màu cố định
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.shade100, // Giữ màu nhấn
            ),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.purple, // Giữ màu nhấn
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
          const Text(
            'CV trực tuyến',
            // <<< SỬA ĐỔI >>> Xóa màu cố định
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Phần thống kê
  Widget _buildStatsSection(BuildContext context) { // <<< SỬA ĐỔI >>> Nhận context
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(context, 'Đã trò chuyện', '0'), // <<< SỬA ĐỔI >>> Truyền context
          _buildStatCard(context, 'Đã gửi CV', '0'), // <<< SỬA ĐỔI >>> Truyền context
          _buildStatCard(context, 'Chờ Phỏng Vấn', '0'), // <<< SỬA ĐỔI >>> Truyền context
        ],
      ),
    );
  }

  // Thẻ thống kê
  Widget _buildStatCard(BuildContext context, String title, String count) { // <<< SỬA ĐỔI >>> Nhận context
    final theme = Theme.of(context);

    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        // <<< SỬA ĐỔI >>> Dùng màu từ theme
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                // <<< SỬA ĐỔI >>> Xóa màu cố định
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                count,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // <<< SỬA ĐỔI >>> Dùng màu chính của theme
                  color: theme.colorScheme.primary,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
            _buildNavigationItem(context, Icons.description_outlined, 'CV trực tuyến', () { Navigator.push(context, MaterialPageRoute(builder: (context) => const OnlineCVPage())); }),
            _buildNavigationItem(context, Icons.attach_file_outlined, 'Đính kèm CV', () { Navigator.push(context, MaterialPageRoute(builder: (context) => const AttachCVPage())); }),
            _buildNavigationItem(context, Icons.emoji_events_outlined, 'Kỳ vọng nghề nghiệp', () { Navigator.push(context, MaterialPageRoute(builder: (context) => const CareerExpectationsPage())); }),
            _buildNavigationItem(context, Icons.article_outlined, 'Tác phẩm của tôi', () { Navigator.push(context, MaterialPageRoute(builder: (context) => const MyWorksPage())); }),
            _buildNavigationItem(context, Icons.favorite_outline, 'Thú vị', () { Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage())); }),
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
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      // <<< SỬA ĐỔI >>> Xóa màu cố định
      child: ListTile(
        // <<< SỬA ĐỔI >>> Icon và Text sẽ tự động đổi màu
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    handleMainNavTap(context, index);
  }
}