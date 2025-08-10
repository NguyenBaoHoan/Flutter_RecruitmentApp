import 'package:flutter/material.dart';

class MyWorksPage extends StatelessWidget {
  const MyWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme hiện tại để sử dụng
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
          'Cập nhật sản phẩm cá nhân',
          style: TextStyle(
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
              // <<< SỬA ĐỔI >>> Text sẽ tự động đổi màu
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Phần thông tin tác phẩm
            const Text(
              'Thông tin tác phẩm',
              // <<< SỬA ĐỔI >>> Text sẽ tự động đổi màu
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              // <<< SỬA ĐỔI >>> Card sẽ tự động đổi màu
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Vui lòng giới thiệu ngắn gọn về thông tin tác phẩm của bạn...',
                    // <<< SỬA ĐỔI >>> hintStyle và counterStyle sẽ tự động đổi màu
                    hintStyle: TextStyle(color: theme.hintColor),
                    border: InputBorder.none,
                    counterText: '0/2000',
                  ),
                  maxLength: 2000,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Phần tải hình ảnh lên
            const Text(
              'Tải hình ảnh lên (0/12)',
              // <<< SỬA ĐỔI >>> Text sẽ tự động đổi màu
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              // <<< SỬA ĐỔI >>> Card sẽ tự động đổi màu
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Nút thêm ảnh
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        // <<< SỬA ĐỔI >>> Dùng màu viền từ theme
                        border: Border.all(color: theme.dividerColor, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        // <<< SỬA ĐỔI >>> Icon sẽ tự động đổi màu
                        icon: const Icon(Icons.add, size: 40),
                        onPressed: () {
                          // Xử lý khi nhấn nút thêm ảnh
                        },
                      ),
                    ),
                    const SizedBox(height: 100), // Khoảng trống mô phỏng
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
          // <<< SỬA ĐỔI >>> Nút sẽ tự động lấy màu từ theme
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Lưu',
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