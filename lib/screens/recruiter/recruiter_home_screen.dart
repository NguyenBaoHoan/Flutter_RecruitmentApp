import 'package:flutter/material.dart';
import '../../widgets/main_bottom_nav_bar.dart'; // Đường dẫn đúng với cấu trúc project

class RecruiterHomeScreen extends StatefulWidget {
  const RecruiterHomeScreen({super.key});

  @override
  State<RecruiterHomeScreen> createState() => _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 0) {
      // Logic tới trang chủ recruiter (nếu có)
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/chat');
    }
    // Thêm logic cho "Hồ sơ" nếu muốn
  }

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme hiện tại để sử dụng
    final theme = Theme.of(context);

    return Scaffold(
      // <<< SỬA ĐỔI >>> AppBar sẽ tự động đổi màu theo theme
      appBar: AppBar(
        title: const Text("Quản lý vị trí"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Center(
            // <<< SỬA ĐỔI >>> Icon sẽ lấy màu chính từ theme
            child: Icon(Icons.business_center, size: 100, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Chưa có dữ liệu",
              // <<< SỬA ĐỔI >>> Text sẽ tự động đổi màu
              style: TextStyle(fontSize: 18),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/manage-jobs');
                },
                // <<< SỬA ĐỔI >>> Nút sẽ tự động lấy màu từ theme
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Đăng một công việc mới",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}