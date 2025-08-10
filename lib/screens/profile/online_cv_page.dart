import 'package:flutter/material.dart';

// Màn hình CV trực tuyến
class OnlineCVPage extends StatelessWidget {
  const OnlineCVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // <<< SỬA ĐỔI >>> AppBar sẽ tự động đổi màu theo theme
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Text(
          'Nguyễn Văn Nghĩa', // Tên người dùng hiển thị trên AppBar
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
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
              _buildPersonalInfoCard(context), // <<< SỬA ĐỔI >>> Truyền context
              const SizedBox(height: 20),
              // Trạng thái tìm việc
              _buildInfoCard(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                icon: Icons.lightbulb_outline,
                title: 'Trạng thái tìm việc',
                content: 'Sẵn sàng nhận việc ngay',
              ),
              const SizedBox(height: 15),
              // Kỳ vọng nghề nghiệp
              _buildInfoCard(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                icon: Icons.emoji_events_outlined,
                title: 'Kỳ vọng nghề nghiệp(0/3)',
                content: 'Tạm thời chưa có dữ liệu',
              ),
              const SizedBox(height: 15),
              // Lịch sử học vấn
              _buildInfoCard(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                icon: Icons.history_edu_outlined,
                title: 'Lịch sử học vấn',
                content: 'Tạm thời chưa có dữ liệu',
              ),
              const SizedBox(height: 15),
              // Ưu điểm
              _buildInfoCard(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                icon: Icons.thumb_up_alt_outlined,
                title: 'Ưu điểm',
                content: 'Tạm thời chưa có dữ liệu',
              ),
              const SizedBox(height: 15),
              // Kinh nghiệm làm việc
              _buildInfoCard(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
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
  Widget _buildPersonalInfoCard(BuildContext context) { // <<< SỬA ĐỔI >>> Nhận context
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      // <<< SỬA ĐỔI >>> Xóa màu cố định, Card sẽ tự lấy màu từ theme
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
                    color: Colors.purple.shade100, // Giữ màu nhấn
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.purple, // Giữ màu nhấn
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'Nguyễn Văn Nghĩa',
                  // <<< SỬA ĐỔI >>> Xóa màu cố định
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
            _buildInfoRow(Icons.phone_android, 'Trong vòng sáu tháng'),
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
          // <<< SỬA ĐỔI >>> Icon và Text sẽ tự động đổi màu
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Thẻ thông tin chung
  Widget _buildInfoCard({
    required BuildContext context, // <<< SỬA ĐỔI >>> Nhận context
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      // <<< SỬA ĐỔI >>> Xóa màu cố định
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // <<< SỬA ĐỔI >>> Dùng màu chính của theme
                Icon(icon, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  // <<< SỬA ĐỔI >>> Xóa màu cố định
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              // <<< SỬA ĐỔI >>> Xóa màu cố định
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}