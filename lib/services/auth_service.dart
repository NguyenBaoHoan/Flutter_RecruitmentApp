import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_finder_app/services/user_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart'; // Giữ nguyên model User của bạn
import 'package:flutter/services.dart';

class AuthResult {
  final User user;
  final String accessToken;
  AuthResult({required this.user, required this.accessToken});
}

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/v1/auth';

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/register'); // Giả sử _baseUrl đã có
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print('Đăng ký thành công!');
        return true;
      } else {
        // In ra lỗi từ backend để dễ debug
        print('Đăng ký thất bại: ${response.statusCode}');
        print('Nội dung lỗi: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi gọi API đăng ký: $e');
      return false;
    }
  }

  /// Phương thức đăng nhập bằng email/mật khẩu
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userName": email, "passWord": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json['data'] != null && json['data']['user'] != null) {
        final user = User.fromJson(json['data']['user']);
        // Lưu user vào SharedPreferences
        await UserPreferencesService.saveUser(user);
        return user;
      }
    }
    return null;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    // Lấy token đã lưu của người dùng
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      print('Lỗi: Không tìm thấy token người dùng.');
      return false;
    }

    // URL tới backend. Lưu ý: endpoint này nằm trong UserController nên có thể không có /auth
    final url = Uri.parse('http://10.0.2.2:8080/api/v1/users/change-password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Gửi token để xác thực
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        print('Đổi mật khẩu thành công.');
        return true;
      } else {
        print(
          'Lỗi đổi mật khẩu từ backend: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Lỗi mạng khi đổi mật khẩu: $e');
      return false;
    }
  }
}
