import 'package:flutter/material.dart';

class CareerExpectationsPage extends StatelessWidget {
  const CareerExpectationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme hiện tại để sử dụng cho các màu sắc
    final theme = Theme.of(context);

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
          'Quản lý mục tiêu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề và mô tả
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Thêm vị trí mong muốn của bạn',
                    // <<< SỬA ĐỔI >>> Xóa màu cố định
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '0/3',
                  // <<< SỬA ĐỔI >>> Xóa màu cố định
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text('Thêm nhiều kỳ vọng tìm kiếm việc làm để có được cơ hội việc làm công nghệ cao chính xác hơn',
              // <<< SỬA ĐỔI >>> Xóa màu cố định
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Mục "Sẵn sàng nhận việc ngay"
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              // <<< SỬA ĐỔI >>> Xóa màu trắng cố định, Card sẽ tự lấy màu từ theme
              child: ListTile(
                title: const Text(
                  'Sẵn sàng nhận việc ngay',
                  // <<< SỬA ĐỔI >>> Xóa màu cố định
                  style: TextStyle(fontSize: 16),
                ),
                // <<< SỬA ĐỔI >>> Xóa màu cố định
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Xử lý khi nhấn vào mục này
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Xử lý khi nhấn nút "Thêm vào (0/3)"
          },
          // <<< SỬA ĐỔI >>> Nút sẽ tự động lấy màu từ theme
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary, // Lấy màu chính của theme
            foregroundColor: theme.colorScheme.onPrimary, // Lấy màu chữ phù hợp
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Thêm vào (0/3)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}