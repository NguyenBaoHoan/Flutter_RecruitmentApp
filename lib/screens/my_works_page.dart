import 'package:flutter/material.dart';

class MyWorksPage extends StatelessWidget {
  const MyWorksPage({super.key});

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
          'Cập nhật sản phẩm cá nhân',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông báo về nội dung tải lên
            const Text(
              'Nội dung tải lên không được chứa thông tin nhạy cảm và thông tin liên hệ cá nhân, chẳng hạn như mã QR, số điện thoại hoặc địa chỉ email, v.v.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Phần thông tin tác phẩm
            Text(
              'Thông tin tác phẩm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Vui lòng giới thiệu ngắn gọn về thông tin tác phẩm của bạn...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none, // Bỏ đường viền của TextField
                    counterText: '0/2000', // Hiển thị số ký tự
                    counterStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                  maxLength: 2000,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Phần tải hình ảnh lên
            Text(
              'Tải hình ảnh lên (0/12)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Nút thêm ảnh
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        // Đã thay đổi style: BorderStyle.dashed thành BorderStyle.solid
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, size: 40, color: Colors.grey.shade500),
                        onPressed: () {
                          // Xử lý khi nhấn nút thêm ảnh
                        },
                      ),
                    ),
                    const SizedBox(height: 100), // Khoảng trống để mô phỏng không gian còn lại
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Xử lý khi nhấn nút Lưu
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Màu nền của nút
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bo tròn góc nút
            ),
          ),
          child: const Text(
            'Lưu',
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
