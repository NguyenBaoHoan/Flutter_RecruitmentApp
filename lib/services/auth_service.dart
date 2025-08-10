import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:job_finder_app/services/user_preferences_service.dart';
import '../models/user_model.dart'; // Giữ nguyên model User của bạn
import 'package:flutter/services.dart';

// Class nhỏ để đóng gói kết quả đăng nhập (user và token)
class AuthResult {
  final User user;
  final String accessToken;

  AuthResult({required this.user, required this.accessToken});
}

class AuthService {
  // <<< GOOGLE SIGN-IN >>>
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '6579631510-ee6ofdl2djag0ghvuhgck7e5mknei6nf.apps.googleusercontent.com',
  );

  // URL tới backend - Đã đổi sang IP 192.168.1.2
  final String _baseUrl = 'http://192.168.1.2:8080/api/v1/auth';

  /// <<< THÊM MỚI >>> Phương thức đăng ký tài khoản mới
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
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

  /// Phương thức đăng nhập bằng Google
  Future<AuthResult?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Đăng nhập Google đã bị hủy.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        // Trường hợp này hiếm khi xảy ra nếu googleUser không null, nhưng vẫn kiểm tra
        throw Exception('Không lấy được Google ID Token sau khi xác thực.');
      }

      // Gửi token lên backend
      final response = await http.post(
        Uri.parse('$_baseUrl/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final User user = User.fromJson(responseBody['user']);
        final String accessToken = responseBody['accessToken'];
        return AuthResult(user: user, accessToken: accessToken);
      } else {
        print('Lỗi từ backend: ${response.statusCode} - ${response.body}');
        await _googleSignIn.signOut();
        return null;
      }
    }
    // <<< BẮT LỖI CHI TIẾT Ở ĐÂY >>>
    on PlatformException catch (e) {
      print('!!! LỖI PlatformException KHI ĐĂNG NHẬP GOOGLE:');
      print('    Mã lỗi (code): ${e.code}');
      print('    Thông báo (message): ${e.message}');
      print('    Chi tiết (details): ${e.details}');
      return null;
    } catch (e) {
      print('!!! Lỗi chung trong quá trình signInWithGoogle: $e');
      return null;
    }
  }

  /// Phương thức đăng xuất google account
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    // TODO: xoá accessToken đã lưu trên thiết bị
    // Tại đây bạn cũng cần xóa token đã lưu trong bộ nhớ của app
    print('Đã đăng xuất.');
  }

  /// Phương thức đăng nhập bằng email/mật khẩu
  Future<User?> login(String email, String password) async {
    // ✅ SỬA: Sử dụng _baseUrl thay vì hardcode URL
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
}
