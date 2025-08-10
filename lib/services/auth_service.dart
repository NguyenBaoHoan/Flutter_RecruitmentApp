import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:job_finder_app/services/user_preferences_service.dart';
import '../models/user_model.dart'; // Giữ nguyên model User của bạn

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
  );

  // URL tới backend 
  // Dùng 'http://10.0.2.2:8080' cho máy ảo Android.
  // Dùng IP thật của máy tính (ví dụ: 'http://192.168.1.5:8080') nếu test trên điện thoại thật.
  final String _baseUrl = 'http://10.0.2.2:8080/api/v1/auth';


  /// Phương thức đăng nhập bằng Google
  Future<AuthResult?> signInWithGoogle() async {
    try {
      // 1. Bắt đầu quá trình đăng nhập với Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Đăng nhập Google đã bị hủy.');
        return null; // Người dùng đã hủy
      }

      // 2. Lấy ID Token
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Không lấy được Google ID Token.');
      }

      // 3. Gửi ID Token lên backend để xác thực
      final response = await http.post(
        Uri.parse('$_baseUrl/google'), // Endpoint /google
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        
        // Phân tích response từ backend { "accessToken": "...", "user": { ... } }
        final User user = User.fromJson(responseBody['user']);
        final String accessToken = responseBody['accessToken'];

        return AuthResult(user: user, accessToken: accessToken);
      } else {
        print('Lỗi từ backend: ${response.statusCode} - ${response.body}');
        await _googleSignIn.signOut(); // Đăng xuất nếu backend lỗi
        return null;
      }
    } catch (e) {
      print('Lỗi trong quá trình signInWithGoogle: $e');
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
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "userName": email,
        "passWord": password,
      }),
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
