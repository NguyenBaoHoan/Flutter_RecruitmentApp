import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class JobApiService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api/v1';

  // Tìm kiếm việc làm
  Future<Map<String, dynamic>> searchJobs({
    String? query,
    String? location,
    String? experience,
    String? jobType,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['filter'] = 'name: \'$query\'';
      }
      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }
      if (experience != null && experience.isNotEmpty) {
        queryParams['experience'] = experience;
      }
      if (jobType != null && jobType.isNotEmpty) {
        queryParams['jobType'] = jobType;
      }

      final uri = Uri.parse(
        '$_baseUrl/jobs',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to search jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching jobs: $e');
    }
  }

  // Lấy danh sách việc làm phổ biến
  Future<List<Job>> getPopularJobs() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/jobs/popular'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> jobsData = jsonData['data']['result'] ?? [];

        return jobsData.map((json) => Job.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load popular jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading popular jobs: $e');
    }
  }

  // Lấy toàn bộ jobs (gom tất cả trang theo meta.pages)
  Future<List<Job>> getAllJobs({int pageSize = 50}) async {
    final List<Job> all = [];
    int page = 1;
    int pages = 1;

    do {
      final uri = Uri.parse('$_baseUrl/jobs?page=$page&pageSize=$pageSize');
      final res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }

      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected response shape');
      }

      final data = decoded['data'] as Map<String, dynamic>?;
      final meta = data?['meta'] as Map<String, dynamic>?;
      final list = (data?['result'] as List?) ?? const [];

      all.addAll(list.map<Job>((e) => Job.fromApi(e as Map<String, dynamic>)));

      pages = (meta?['pages'] as num?)?.toInt() ?? 1;
      page++;
    } while (page <= pages);

    return all;
  }
}
