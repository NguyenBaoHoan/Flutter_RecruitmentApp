import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/work_experience.dart';
import '../models/skill.dart';

class CVService {
  static const String baseUrl = 'http://192.168.1.2:8080/api/v1';

  // Lấy access token từ SharedPreferences
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Headers với Authorization
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // === USER PROFILE ===
  static Future<UserProfile?> getUserProfile(int userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/profile/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserProfile.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  static Future<bool> updateUserProfile(int userId, UserProfile profile) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/users/profile/$userId'),
        headers: headers,
        body: json.encode(profile.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // === WORK EXPERIENCE ===
  static Future<List<WorkExperience>> getUserExperiences(int userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/experiences/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => WorkExperience.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching experiences: $e');
      return [];
    }
  }

  static Future<bool> createExperience(
    int userId,
    WorkExperience experience,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/experiences/user/$userId'),
        headers: headers,
        body: json.encode(experience.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating experience: $e');
      return false;
    }
  }

  static Future<bool> updateExperience(WorkExperience experience) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/experiences/${experience.id}'),
        headers: headers,
        body: json.encode(experience.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating experience: $e');
      return false;
    }
  }

  static Future<bool> deleteExperience(int experienceId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/experiences/$experienceId'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting experience: $e');
      return false;
    }
  }

  // === SKILLS ===
  static Future<List<Skill>> getUserSkills(int userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/skills/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Skill.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching skills: $e');
      return [];
    }
  }

  static Future<bool> createSkill(int userId, Skill skill) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/skills/user/$userId'),
        headers: headers,
        body: json.encode(skill.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating skill: $e');
      return false;
    }
  }

  static Future<bool> deleteSkill(int skillId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/skills/$skillId'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting skill: $e');
      return false;
    }
  }
}
