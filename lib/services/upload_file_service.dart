import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FileService {
  static const String _baseUrl =
      'http://192.168.1.2:8080/api/v1'; // Địa chỉ backend API

  // Hàm lấy CV hiện tại của user từ backend
  static Future<String?> getCurrentUserCV(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/files/user/$userId/cv'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Kiểm tra và lấy tên file CV từ response
        if (data['data'] != null && data['data']['fileName'] != null) {
          return data['data']['fileName'];
        } else if (data['data'] != null && data['data']['cvPath'] != null) {
          String cvPath = data['data']['cvPath'];
          // Trả về tên file từ đường dẫn
          return cvPath.substring(cvPath.lastIndexOf('/') + 1);
        } else {
          // Không có dữ liệu CV
          return null;
        }
      } else {
        // Lỗi khi gọi API
        return null;
      }
    } catch (e) {
      // Lỗi khi xử lý dữ liệu hoặc kết nối
      return null;
    }
  }

  // Hàm upload CV lên backend
  static Future<String?> uploadCV(File file, int userId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/files/upload-cv'),
      );

      // Xác định loại file để gửi lên backend
      String ext = file.path.split('.').last.toLowerCase();
      MediaType contentType;
      switch (ext) {
        case 'pdf':
          contentType = MediaType('application', 'pdf');
          break;
        case 'doc':
          contentType = MediaType('application', 'msword');
          break;
        case 'docx':
          contentType = MediaType(
            'application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document',
          );
          break;
        case 'jpg':
        case 'jpeg':
          contentType = MediaType('image', 'jpeg');
          break;
        case 'png':
          contentType = MediaType('image', 'png');
          break;
        default:
          contentType = MediaType('application', 'octet-stream');
      }

      // Thêm trường userId và file vào request
      request.fields['userId'] = userId.toString();
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: contentType,
        ),
      );

      // Gửi request lên backend
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        // Lấy tên file từ response trả về
        if (jsonResponse['data'] != null &&
            jsonResponse['data']['fileName'] != null) {
          return jsonResponse['data']['fileName'];
        } else {
          // Không có tên file trong response
          return null;
        }
      } else {
        // Lỗi khi upload file
        return null;
      }
    } catch (e) {
      // Lỗi khi xử lý upload
      return null;
    }
  }

  // Hàm xóa CV của user trên backend
  static Future<bool> deleteCV(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/files/delete-cv?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      // Trả về true nếu xóa thành công
      return response.statusCode == 200;
    } catch (e) {
      // Lỗi khi gọi API xóa
      return false;
    }
  }
}
