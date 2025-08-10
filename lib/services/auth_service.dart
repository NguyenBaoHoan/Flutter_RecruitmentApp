import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'user_preferences_service.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/v1/auth/login');
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
