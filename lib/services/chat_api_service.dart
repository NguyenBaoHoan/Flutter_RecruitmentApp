import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import '../models/chat_room.dart';

class ChatApiService {
  static const String _baseUrl =
      'http://10.0.2.2:8080'; // Sử dụng localhost cho backend Java Spring Boot khi chạy Flutter mobile

  // Lấy lịch sử tin nhắn của một phòng chat
  Future<List<ChatMessage>> getChatHistory(String roomId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/chat/rooms/$roomId/messages'),
        headers: {
          'Content-Type': 'application/json',
          // Thêm Authorization header nếu cần
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        return jsonData.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chat history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting chat history: $e');
    }
  }

  // Lấy danh sách phòng chat của một user
  Future<List<ChatRoom>> getChatRooms(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/chat/users/$userId/rooms'),
        headers: {
          'Content-Type': 'application/json',
          // Thêm Authorization header nếu cần
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        return jsonData.map((json) => ChatRoom.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chat rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting chat rooms: $e');
    }
  }

  // Gửi tin nhắn qua REST (cho testing)
  Future<ChatMessage?> sendMessage(ChatMessage message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/sendMessage'),
        headers: {
          'Content-Type': 'application/json',
          // Thêm Authorization header nếu cần
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode(message.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ChatMessage.fromJson(jsonData);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  // Lấy thông tin phòng chat giữa 2 user
  Future<ChatRoom?> getChatRoomBetweenUsers(int user1Id, int user2Id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/chat/rooms/between/$user1Id/$user2Id'),
        headers: {
          'Content-Type': 'application/json',
          // Thêm Authorization header nếu cần
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ChatRoom.fromJson(jsonData);
      } else {
        throw Exception('Failed to get chat room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting chat room: $e');
    }
  }
}
