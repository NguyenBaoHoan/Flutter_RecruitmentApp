import 'package:flutter/material.dart';

// Màn hình CV trực tuyến
class OnlineCVPage extends StatelessWidget {
  const OnlineCVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Text(
          'Nguyễn Văn Nghĩa', // Tên người dùng hiển thị trên AppBar
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () {
              // Xử lý khi nhấn nút chỉnh sửa
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Phần thông tin cá nhân
              _buildPersonalInfoCard(),
              const SizedBox(height: 20),
              // Trạng thái tìm việc
              _buildInfoCard(
                icon: Icons.lightbulb_outline,
                title: 'Trạng thái tìm việc',
                content: 'Sẵn sàng nhận việc ngay',
              ),
              const SizedBox(height: 15),
              // Kỳ vọng nghề nghiệp
              _buildInfoCard(
                icon: Icons.emoji_events_outlined,
                title: 'Kỳ vọng nghề nghiệp(0/3)',
                content: 'Tạm thời chưa có dữ liệu',
              ),
              const SizedBox(height: 15),
              // Lịch sử học vấn
              _buildInfoCard(
                icon: Icons.history_edu_outlined,
                title: 'Lịch sử học vấn',
                content: 'Tạm thời chưa có dữ liệu',
              ),
              const SizedBox(height: 15),
              // Ưu điểm
              _buildInfoCard(
                icon: Icons.thumb_up_alt_outlined,
                title: 'Ưu điểm',
                content: 'Tạm thời chưa có dữ liệu',
              ),
              const SizedBox(height: 15),
              // Kinh nghiệm làm việc
              _buildInfoCard(
                icon: Icons.work_outline,
                title: 'Kinh nghiệm làm việc',
                content: 'Tạm thời chưa có dữ liệu',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Thẻ thông tin cá nhân
  Widget _buildPersonalInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Ảnh đại diện và tên
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.shade100,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'Nguyễn Văn Nghĩa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Các thông tin chi tiết
            _buildInfoRow(Icons.cake_outlined, '20 Tuổi'),
            _buildInfoRow(Icons.phone_android, 'Trong vòng sáu tháng'), // Icon phone_android
            _buildInfoRow(Icons.lock_outline, 'Không bị ràng buộc'),
            _buildInfoRow(Icons.mail_outline, 'nn436223@gmail.com'),
          ],
        ),
      ),
    );
  }

  // Hàng thông tin chi tiết
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  // Thẻ thông tin chung
  Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
