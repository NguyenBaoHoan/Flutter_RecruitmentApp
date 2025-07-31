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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý vị trí"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const Center(
            child: Icon(Icons.business_center, size: 100, color: Colors.blueAccent),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Chưa có dữ liệu",
              style: TextStyle(fontSize: 18, color: Colors.grey),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
