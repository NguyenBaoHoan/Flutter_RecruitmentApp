import 'package:flutter/material.dart';

class AttachCVPage extends StatelessWidget {
  const AttachCVPage({super.key});

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
          'Đính kèm CV',
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
            // Thông báo về định dạng file
            const Text(
              'Nên sử dụng tệp PDF cho CV. Các định dạng DOC, DOCX, JPG và PNG đều được hỗ trợ, kích thước không quá 20M.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Card "Tạo CV nhanh chóng"
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: const Color(0xFF6A5ACD), // Màu tím đậm
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
                              color: Colors.white,
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
                    // Icon hoặc hình ảnh minh họa
                    Image.network(
                      'https://placehold.co/80x80/6A5ACD/white?text=CV', // Placeholder image
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.insert_drive_file,
                          size: 60,
                          color: Colors.white,
                        ); // Fallback icon
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
                      'https://placehold.co/200x200/white/grey?text=No+Data', // Placeholder image
                      width: 200,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          size: 100,
                          color: Colors.grey.shade400,
                        ); // Fallback icon if image fails to load
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Chưa có dữ liệu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Màu nền của nút
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bo tròn góc nút
            ),
          ),
          child: const Text(
            'Tải lên tệp đính kèm mới (0/3)',
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
