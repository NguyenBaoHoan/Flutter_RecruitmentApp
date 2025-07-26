import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/auth_gate.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trung tâm cài đặt',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildSettingItem('Trung tâm bảo mật tài khoản'),
                _buildSettingItem('Thông báo và nhắc nhở'),
                _buildSettingItem('Quản lý không gian lưu trữ'),
                _buildSettingItem('Từ Thường dùng'),
                _buildSettingItem('Danh sách đen'),
                _buildSettingItem('Bảo vệ quyền riêng tư'),
                _buildRoleSwitchItem(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // xử lý đăng xuất
                onPressed: () async {
                  await _logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildSettingItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black38,
          ),
          onTap: () {
            // TODO: Xử lý chuyển trang tương ứng
          },
        ),
        const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildRoleSwitchItem() {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Chuyển đổi vai trò',
            style: TextStyle(fontSize: 16),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Người tìm việc', style: TextStyle(color: Colors.black54)),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
            ],
          ),
          onTap: () {
            // TODO: Xử lý chuyển đổi vai trò
          },
        ),
        const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Hiển thị dialog xác nhận
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // Xóa dữ liệu đăng nhập từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      // Xóa các dữ liệu khác nếu có (token, user info, etc.)
      await prefs.remove('token');
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');

      // Hiển thị thông báo
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã đăng xuất thành công')),
        );
      }

      // Chuyển về màn hình đăng nhập
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
          (route) => false,
        );
      }
    }
  }
}
