import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;

  // Lưu lịch sử tìm kiếm
  Future<void> saveSearchHistory(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    List<String> history = await getSearchHistory();

    // Loại bỏ query trùng lặp
    history.remove(query.trim());

    // Thêm query mới vào đầu danh sách
    history.insert(0, query.trim());

    // Giới hạn số lượng lịch sử
    if (history.length > _maxHistoryItems) {
      history = history.take(_maxHistoryItems).toList();
    }

    await prefs.setStringList(_searchHistoryKey, history);
  }

  // Lấy lịch sử tìm kiếm
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  // Xóa một item khỏi lịch sử
  Future<void> removeSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = await getSearchHistory();
    history.remove(query);
    await prefs.setStringList(_searchHistoryKey, history);
  }

  // Xóa toàn bộ lịch sử
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }
}
