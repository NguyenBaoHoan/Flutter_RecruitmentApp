import 'package:flutter/material.dart';

class AttachCVPage extends StatelessWidget {
  const AttachCVPage({super.key});

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy màu sắc từ theme hiện tại của ứng dụng
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      // <<< SỬA ĐỔI >>> AppBar sẽ tự động lấy màu từ theme
      appBar: AppBar(
        elevation: 0,
        // Nút back và title sẽ tự động đổi màu theo theme
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Text(
          'Đính kèm CV',
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
            // Thông báo về định dạng file
            const Text(
              'Nên sử dụng tệp PDF cho CV. Các định dạng DOC, DOCX, JPG và PNG đều được hỗ trợ, kích thước không quá 20M.',
              // <<< SỬA ĐỔI >>> Text sẽ tự động đổi màu
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Card "Tạo CV nhanh chóng" - Giữ nguyên màu tím đặc trưng
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: const Color(0xFF6A5ACD), // Giữ màu tím làm điểm nhấn
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Tạo CV nhanh chóng',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Chữ trắng trên nền tím luôn nổi bật
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Tạo CV nhanh chóng với công nghệ của chúng tôi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.network(
                      'https://placehold.co/80x80/6A5ACD/white?text=CV',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.insert_drive_file,
                          size: 60,
                          color: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Phần "Chưa có dữ liệu"
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      // <<< SỬA ĐỔI >>> Thay đổi màu ảnh placeholder theo theme
                      isDarkMode
                          ? 'https://placehold.co/200x200/303030/grey?text=No+Data'
                          : 'https://placehold.co/200x200/white/grey?text=No+Data',
                      width: 200,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          size: 100,
                          // <<< SỬA ĐỔI >>> Lấy màu icon từ theme
                          color: theme.dividerColor,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chưa có dữ liệu',
                      // <<< SỬA ĐỔI >>> Text sẽ tự động đổi màu
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
            // Xử lý khi nhấn nút "Tải lên tệp đính kèm mới"
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
            'Tải lên tệp đính kèm mới (0/3)',
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