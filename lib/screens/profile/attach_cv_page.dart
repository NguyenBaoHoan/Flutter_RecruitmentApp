import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/upload_file_service.dart';

// Trang đính kèm CV cho hồ sơ cá nhân
class AttachCVPage extends StatefulWidget {
  const AttachCVPage({super.key});

  @override
  State<AttachCVPage> createState() => _AttachCVPageState();
}

class _AttachCVPageState extends State<AttachCVPage> {
  String? uploadedCV; // Tên file CV đã upload (lấy từ backend)
  bool isUploading = false; // Trạng thái đang upload file
  int? currentUserId; // ID người dùng hiện tại

  @override
  void initState() {
    super.initState();
    _loadCurrentUserCV(); // Tải CV khi vào trang
  }

  // Hàm tải CV hiện tại của user từ backend
  Future<void> _loadCurrentUserCV() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Debug: In ra các key trong SharedPreferences
      print('=== DEBUG SharedPreferences ===');
      print('All keys in prefs: ${prefs.getKeys()}');

      // Lấy user_id từ local (được lưu dưới dạng int)
      currentUserId = prefs.getInt('user_id');
      print('user_id from prefs: $currentUserId');

      if (currentUserId != null) {
        print('✅ Found user_id: $currentUserId');

        // Gọi API lấy tên file CV của user
        String? cvFileName = await FileService.getCurrentUserCV(currentUserId!);
        print('CV fileName from API: $cvFileName');

        // Nếu có file CV thì cập nhật lên giao diện
        if (cvFileName != null && cvFileName.isNotEmpty) {
          setState(() {
            uploadedCV = cvFileName;
          });
        }
      } else {
        print('❌ No user_id found in SharedPreferences');
      }
    } catch (e) {
      print('❌ Error in _loadCurrentUserCV: $e');
    }
  }

  // Hàm upload CV lên backend
  Future<void> uploadCV() async {
    print('=== DEBUG Upload CV ===');
    print('currentUserId: $currentUserId');

    // Nếu chưa có userId thì thử lấy lại từ SharedPreferences
    if (currentUserId == null) {
      await _loadCurrentUserCV();

      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy thông tin người dùng!')),
        );
        return;
      }
    }

    // Chọn file từ thiết bị (chỉ cho phép các định dạng phổ biến)
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        isUploading = true; // Hiển thị trạng thái đang upload
      });

      File file = File(result.files.single.path!);
      // Gọi API upload CV lên server
      String? uploadResult = await FileService.uploadCV(file, currentUserId!);

      if (uploadResult != null) {
        setState(() {
          uploadedCV = uploadResult; // Cập nhật tên file trả về từ server
          isUploading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Upload CV thành công!')));

        // Reload lại để lấy file mới nhất
        await _loadCurrentUserCV();
      } else {
        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Upload CV thất bại!')));
      }
    }
  }

  // Hàm xóa CV của user
  Future<void> deleteCV() async {
    if (currentUserId == null) return;

    // Gọi API xóa file CV
    bool success = await FileService.deleteCV(currentUserId!);
    if (success) {
      setState(() {
        uploadedCV = null; // Xóa tên file khỏi giao diện
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa CV thành công!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Xóa CV thất bại!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy màu sắc từ theme hiện tại của ứng dụng
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      // AppBar sẽ tự động lấy màu từ theme
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông báo về định dạng file hỗ trợ
            const Text(
              'Nên sử dụng tệp PDF cho CV. Các định dạng DOC, DOCX, JPG và PNG đều được hỗ trợ, kích thước không quá 20M.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Card "Tạo CV nhanh chóng" - Giữ nguyên màu tím đặc trưng
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: const Color(0xFF6A5ACD), // Màu tím làm điểm nhấn
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Thông tin mô tả
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Tạo CV nhanh chóng',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Chữ trắng trên nền tím
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
                    // Ảnh minh họa CV
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

            // Hiển thị CV hoặc "Chưa có dữ liệu"
            Expanded(
              child: uploadedCV == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ảnh placeholder khi chưa có CV
                          Image.network(
                            isDarkMode
                                ? 'https://placehold.co/200x200/303030/grey?text=No+Data'
                                : 'https://placehold.co/200x200/white/grey?text=No+Data',
                            width: 200,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported_outlined,
                                size: 100,
                                color: theme.dividerColor,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Chưa có CV nào được tải lên',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Widget preview CV (ảnh hoặc icon file)
                            _buildCVPreview(uploadedCV!),
                            const SizedBox(width: 16),
                            // Thông tin tên file CV
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getDisplayName(uploadedCV!),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'CV hiện tại',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Nút xóa CV
                            IconButton(
                              onPressed: deleteCV,
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      // Nút upload CV ở dưới cùng màn hình
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: uploadedCV == null && !isUploading ? uploadCV : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isUploading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  uploadedCV == null ? 'Tải lên CV (0/1)' : 'Đã có CV (1/1)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  // Widget preview CV (ảnh hoặc icon file)
  Widget _buildCVPreview(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
    // Đường dẫn file trên server
    final url = 'http://192.168.1.2:8080/uploads/uploads/$fileName';

    return GestureDetector(
      onTap: () => _openCVViewer(fileName),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isImage
            // Nếu là ảnh thì hiển thị ảnh
            ? Image.network(
                url,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 60,
                  ),
                ),
              )
            // Nếu là file PDF/DOC thì hiển thị icon
            : Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: ext == 'pdf'
                      ? Colors.red.shade50
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  ext == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file,
                  size: 60,
                  color: ext == 'pdf' ? Colors.red : Colors.blue,
                ),
              ),
      ),
    );
  }

  // Hàm hiển thị tên file thân thiện (bỏ timestamp/uuid nếu có)
  String _getDisplayName(String fileName) {
    if (fileName.contains('-') && fileName.split('-').length >= 3) {
      // Bỏ timestamp và UUID, chỉ lấy tên gốc
      final parts = fileName.split('-');
      return parts.sublist(2).join('-');
    }
    return fileName;
  }

  // Hàm mở viewer cho file CV (ảnh hoặc PDF/DOC)
  void _openCVViewer(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
    final url = 'http://192.168.1.2:8080/uploads/uploads/$fileName';

    if (isImage) {
      // Hiển thị ảnh fullscreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _ImageViewer(imageUrl: url, fileName: fileName),
        ),
      );
    } else {
      // Hiển thị PDF/DOC viewer
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _PDFViewer(pdfUrl: url, fileName: fileName),
        ),
      );
    }
  }
}

// Widget xem ảnh fullscreen
class _ImageViewer extends StatelessWidget {
  final String imageUrl;
  final String fileName;

  const _ImageViewer({required this.imageUrl, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(fileName, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image,
              size: 100,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget xem PDF/DOC (chỉ hiển thị icon và tên, không render nội dung file)
class _PDFViewer extends StatelessWidget {
  final String pdfUrl;
  final String fileName;

  const _PDFViewer({required this.pdfUrl, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadFile(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              fileName.endsWith('.pdf')
                  ? Icons.picture_as_pdf
                  : Icons.insert_drive_file,
              size: 100,
              color: fileName.endsWith('.pdf') ? Colors.red : Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              fileName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Nhấn nút tải xuống để xem file',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _downloadFile(context),
              icon: const Icon(Icons.download),
              label: const Text('Tải xuống'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _openInBrowser(context),
              child: const Text('Mở trong trình duyệt'),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị dialog chứa URL file để tải xuống
  void _downloadFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tải xuống file'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('URL file:'),
            const SizedBox(height: 8),
            SelectableText(pdfUrl, style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị snackbar với URL file (có thể mở rộng để copy hoặc mở bằng url_launcher)
  void _openInBrowser(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mở URL: $pdfUrl'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // Copy URL to clipboard nếu cần
          },
        ),
      ),
    );
  }
}
