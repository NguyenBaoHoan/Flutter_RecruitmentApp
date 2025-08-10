// lib/services/favorite_job_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart'; // <-- Use the Job model directly

class FavoriteJobService {
  // Use 10.0.2.2 for Android emulator to connect to localhost
  static const String _baseUrl = 'http://10.0.2.2:8080/api/favorite-jobs';

  // Lấy danh sách job yêu thích của user
  Future<List<Job>> getFavoriteJobs(int userId) async {
    final uri = Uri.parse(
      '$_baseUrl?userId=$userId',
    ); // chỉnh endpoint nếu khác
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to get favorites: ${res.statusCode} ${res.body}');
    }

    final decoded = jsonDecode(res.body);

    // Chuẩn hóa về List<dynamic>
    dynamic list;
    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        final result =
            data['result'] ?? data['items'] ?? data['content'] ?? data['rows'];
        if (result is List) {
          list = result;
        } else if (result is Map<String, dynamic>) {
          list = [result]; // server trả 1 object
        }
      }
    }
    if (list is! List) {
      throw Exception(
        'Unexpected favorites response shape: ${decoded.runtimeType}',
      );
    }

    // Mỗi phần tử có thể là job trực tiếp hoặc bọc trong { id, job: {...} }
    return list.map<Job>((e) {
      final m = e as Map<String, dynamic>;
      final jobJson = (m['job'] is Map<String, dynamic>)
          ? m['job'] as Map<String, dynamic>
          : m;
      return Job.fromApi(jobJson);
    }).toList();
  }

  // Thêm job vào danh sách yêu thích
  Future<String> addToFavorites(int userId, int jobId) async {
    final uri = Uri.parse('$_baseUrl/add?userId=$userId&jobId=$jobId');
    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to add to favorites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to favorites: $e');
    }
  }

  // Xóa job khỏi danh sách yêu thích
  Future<String> removeFromFavorites(int userId, int jobId) async {
    final uri = Uri.parse('$_baseUrl/remove?userId=$userId&jobId=$jobId');
    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
          'Failed to remove from favorites: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  // Kiểm tra job có được yêu thích không
  Future<bool> checkIfFavorited(int userId, int jobId) async {
    final uri = Uri.parse('$_baseUrl/check?userId=$userId&jobId=$jobId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      } else {
        // Assume not favorited if there's an error
        return false;
      }
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Đếm số job yêu thích của user
  Future<int> countFavoriteJobs(int userId) async {
    final uri = Uri.parse('$_baseUrl/count?userId=$userId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // **FIXED**: Parse the JSON object and get the 'data' field
        final decodedBody = json.decode(response.body);
        return decodedBody['data'] as int;
      } else {
        throw Exception(
          'Failed to count favorite jobs: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error counting favorite jobs: $e');
    }
  }
}
