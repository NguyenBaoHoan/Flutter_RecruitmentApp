import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PortfolioService {
  static const String _host = '192.168.1.2'; // Đồng bộ IP backend
  static const String _base = 'http://$_host:8080/api/v1/portfolio';
  static const int maxImages = 12;

  // Lấy toàn bộ portfolio (mô tả + danh sách ảnh)
  static Future<Map<String, dynamic>?> fetchPortfolio(int userId) async {
    final r = await http.get(Uri.parse('$_base/$userId'));
    if (r.statusCode == 200) {
      final jsonData = json.decode(r.body);
      // Sau khi backend phẳng: payload nằm ở jsonData['data'] (wrapper) (nếu có wrapper)
      final payload =
          jsonData['data'] ?? jsonData; // fallback nếu không có wrapper
      return payload;
    }
    return null;
  }

  // Lưu / cập nhật mô tả
  static Future<bool> saveDescription(int userId, String desc) async {
    final req = http.MultipartRequest('POST', Uri.parse('$_base/description'));
    req.fields['userId'] = userId.toString();
    req.fields['description'] = desc;
    final res = await req.send();
    return res.statusCode == 200;
  }

  // Upload thêm ảnh (trả về danh sách ảnh mới). Phải truyền currentCount hiện tại.
  static Future<List<dynamic>> uploadImages(
    int userId,
    int currentCount,
  ) async {
    final remain = maxImages - currentCount;
    if (remain <= 0) return [];

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );
    if (result == null) return [];

    final req = http.MultipartRequest('POST', Uri.parse('$_base/images'));
    req.fields['userId'] = userId.toString();
    for (final f in result.files.take(remain)) {
      if (f.path != null) {
        req.files.add(await http.MultipartFile.fromPath('files', f.path!));
      }
    }

    final res = await req.send();
    if (res.statusCode == 200) {
      final body = await res.stream.bytesToString();
      final jsonData = json.decode(body);
      final payload = jsonData['data'] ?? jsonData;
      final imgs = payload['images'];
      if (imgs is List) return List<dynamic>.from(imgs);
    }
    return [];
  }

  // Xóa ảnh theo imageId
  static Future<bool> deleteImage(int userId, int imageId) async {
    final r = await http.delete(
      Uri.parse('$_base/images/$imageId?userId=$userId'),
    );
    return r.statusCode == 200;
  }
}
