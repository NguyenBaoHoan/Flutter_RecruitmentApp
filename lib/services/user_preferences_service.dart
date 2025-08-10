import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserPreferencesService {
  static const _kIsLoggedIn = 'isLoggedIn';
  static const _kUserId = 'user_id';
  static const _kUserName = 'user_name';
  static const _kUserEmail = 'user_email';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    // Lưu các thông tin cơ bản
    await prefs.setString(_kUserName, (user.name ?? '').toString());
    await prefs.setString(_kUserEmail, (user.email ?? '').toString());

    // Lưu user_id: ưu tiên int, fallback string nếu không parse được
    await prefs.remove(_kUserId); // xóa key cũ để tránh conflict type
    final parsed = int.tryParse((user.id ?? '').toString());
    if (parsed != null) {
      await prefs.setInt(_kUserId, parsed);
    } else {
      await prefs.setString(_kUserId, (user.id ?? '').toString());
    }
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // Ưu tiên đọc int
    final idInt = prefs.getInt(_kUserId);
    if (idInt != null) return idInt;

    // Nếu trước đó lưu string thì parse
    final idStr = prefs.getString(_kUserId);
    if (idStr == null || idStr.trim().isEmpty) return null;
    return int.tryParse(idStr);
  }

  static Future<void> setIsLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsLoggedIn, value);
  }

  static Future<bool> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedIn) ?? false;
  }

  // Tuỳ chọn: hàm clear khi logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kIsLoggedIn);
    await prefs.remove(_kUserId);
    await prefs.remove(_kUserName);
    await prefs.remove(_kUserEmail);
  }
}
