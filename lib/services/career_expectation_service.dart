import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/career_expectation.dart';

class CareerExpectationService {
  static const String baseUrl = 'http://192.168.1.2:8080';

  // Lấy danh sách kỳ vọng nghề nghiệp
  static Future<Map<String, dynamic>?> fetchCareerExpectations(
    int userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/career-expectations/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('API Response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // ✅ SỬA: Lấy data từ wrapper
        final data = jsonData['data'];

        return {
          'expectations': (data['expectations'] as List)
              .map((e) => CareerExpectation.fromJson(e))
              .toList(),
          'count': data['count'],
          'maxCount': data['maxCount'],
          'jobSeekingStatus': data['jobSeekingStatus'],
          'jobSeekingStatusDisplay': data['jobSeekingStatusDisplay'],
        };
      }
      return null;
    } catch (e) {
      print('Error fetching career expectations: $e');
      return null;
    }
  }

  // Tạo kỳ vọng nghề nghiệp mới
  static Future<bool> createCareerExpectation(
    int userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/career-expectations/user/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Create API Response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // ✅ SỬA: Kiểm tra statusCode trong response
        return jsonData['statusCode'] == 200;
      }
      return false;
    } catch (e) {
      print('Error creating career expectation: $e');
      return false;
    }
  }

  // Cập nhật kỳ vọng nghề nghiệp
  static Future<bool> updateCareerExpectation(
    int userId,
    int expectationId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$baseUrl/api/v1/career-expectations/$expectationId/user/$userId',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Update API Response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['statusCode'] == 200;
      }
      return false;
    } catch (e) {
      print('Error updating career expectation: $e');
      return false;
    }
  }

  // Xóa kỳ vọng nghề nghiệp
  static Future<bool> deleteCareerExpectation(
    int userId,
    int expectationId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$baseUrl/api/v1/career-expectations/$expectationId/user/$userId',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      print('Delete API Response: ${response.body}'); // Debug log
      print('Delete API Status Code: ${response.statusCode}'); // Debug log

      if (response.statusCode == 200) {
        // ✅ SỬA: Kiểm tra xem response có phải JSON không
        try {
          final jsonData = json.decode(response.body);
          return jsonData['statusCode'] == 200;
        } catch (e) {
          // ✅ SỬA: Nếu không phải JSON (plain text), chỉ cần kiểm tra status code
          print(
            'Response is not JSON, treating as success based on status code',
          );
          return true; // HTTP 200 = thành công
        }
      }
      return false;
    } catch (e) {
      print('Error deleting career expectation: $e');
      return false;
    }
  }

  // Cập nhật trạng thái tìm việc
  static Future<bool> updateJobSeekingStatus(int userId, String status) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$baseUrl/api/v1/career-expectations/job-seeking-status/user/$userId',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'jobSeekingStatus': status}),
      );

      print('Update Status API Response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['statusCode'] == 200;
      }
      return false;
    } catch (e) {
      print('Error updating job seeking status: $e');
      return false;
    }
  }

  // Lấy các tùy chọn cho form
  static Future<Map<String, dynamic>?> getFormOptions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/career-expectations/options'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Options API Response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // ✅ SỬA: Trả về data từ wrapper
        return jsonData['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching form options: $e');
      return null;
    }
  }
}
