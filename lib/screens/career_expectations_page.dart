import 'package:flutter/material.dart';

class CareerExpectationsPage extends StatelessWidget {
  const CareerExpectationsPage({super.key});

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
          'Quản lý mục tiêu',
          style: TextStyle(
            color: Colors.black,
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Text(
                  '0/3',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'Thêm nhiều kỳ vọng tìm kiếm việc làm để có được cơ hội việc làm công nghệ cao chính xác hơn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            // Mục "Sẵn sàng nhận việc ngay"
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  'Sẵn sàng nhận việc ngay',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Màu nền của nút
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bo tròn góc nút
            ),
          ),
          child: const Text(
            'Thêm vào (0/3)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
