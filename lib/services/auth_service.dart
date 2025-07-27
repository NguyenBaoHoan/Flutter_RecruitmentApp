import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/v1'; 
  final _storage = const FlutterSecureStorage();

  // HÀM LOGIN BẰNG EMAIL/PASSWORD ĐÃ LƯU TRONG DATABASE
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
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

      // API trả về token, lưu lại token
      if (json['data'] != null && json['data']['user'] != null) {
        await _storage.write(key: 'token', value: json['data']['token']);
      }

      if (json['data'] != null && json['data']['user'] != null) {
        return User.fromJson(json['data']['user']);
      }
    }
    return null;
  }

  // HÀM ĐĂNG NHẬP VỚI GOOGLE
  Future<User?> signInWithGoogle() async {
    try {
      // LẤY TOKEN TỪ GOOGLE
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // HUỶ QUÁ TRÌNH ĐĂNG NHẬP
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth?.idToken;

      if (idToken == null) {
        //GỬI IDTOKEN ĐẾN API
        final url = Uri.parse('$_baseUrl/google-login');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': idToken}),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> json = jsonDecode(response.body);

          // LƯU LẠI TOKEN TRÊN SERVER
          if (json['data'] != null && json['data']['user'] != null) {
            await _storage.write(key: 'token', value: json['data']['token']);
          }

          // LẤY THÔNG TIN USER
          if (json['data'] != null && json['data']['user'] != null) {
            return User.fromJson(json['data']['user']);
          }
        } 
      } 
    } catch (e) {
          print("Lỗi khi đăng nhập bằng Google: $e");
    } 
    return null;
  }

  // HÀM ĐĂNG XUẤT
  Future<void> signOut() async {
    await GoogleSignIn().signOut(); // ĐĂNG XUẤT TỪ GOOGLE
    await _storage.delete(key: 'auth_token'); // XÓA LẠI TOKEN
  }


  // HÀM LẤY TOKEN ĐÃ LƯU
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}