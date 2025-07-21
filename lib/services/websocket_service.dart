import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../models/chat_message.dart';

class WebSocketService {
  static const String _baseUrl =
      'ws://10.0.2.2:8080/ws'; // Thay bằng IP của bạn
  WebSocketChannel? _channel;
  bool _isConnected = false;

  // Callbacks
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onError;
  Function()? onConnected;
  Function()? onDisconnected;

  // Singleton pattern
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  bool get isConnected => _isConnected;

  // Kết nối WebSocket
  Future<void> connect() async {
    print('=== WEBSOCKET CONNECT DEBUG ===');
    print('Connecting to: $_baseUrl');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_baseUrl));
      _isConnected = true;
      print('WebSocket connection established');

      // Lắng nghe tin nhắn từ server
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print('=== WEBSOCKET CONNECTION ERROR ===');
          print('WebSocket error: $error');
          print('=== END WEBSOCKET CONNECTION ERROR ===');
          _isConnected = false;
          onError?.call('WebSocket error: $error');
        },
        onDone: () {
          print('=== WEBSOCKET CONNECTION DONE ===');
          print('WebSocket connection closed');
          print('=== END WEBSOCKET CONNECTION DONE ===');
          _isConnected = false;
          onDisconnected?.call();
        },
      );

      print('WebSocket listeners set up');
      onConnected?.call();
      print('=== END WEBSOCKET CONNECT DEBUG ===');
    } catch (e) {
      print('=== WEBSOCKET CONNECT ERROR ===');
      print('Failed to connect: $e');
      print('=== END WEBSOCKET CONNECT ERROR ===');
      _isConnected = false;
      onError?.call('Failed to connect: $e');
    }
  }

  // Xử lý tin nhắn nhận được
  void _handleMessage(dynamic message) {
    print('=== WEBSOCKET RECEIVE DEBUG ===');
    print('Raw message received: $message');
    print('Message type: ${message.runtimeType}');

    try {
      if (message is String) {
        // Parse STOMP frame hoặc JSON message
        if (message.startsWith('MESSAGE')) {
          print('Processing STOMP MESSAGE frame');
          // STOMP MESSAGE frame
          final lines = message.split('\n');
          String? body;
          for (int i = 0; i < lines.length; i++) {
            if (lines[i].isEmpty && i + 1 < lines.length) {
              body = lines[i + 1];
              break;
            }
          }

          if (body != null) {
            print('STOMP body found: $body');
            final jsonData = json.decode(body);
            final chatMessage = ChatMessage.fromJson(jsonData);
            print('Parsed ChatMessage: ${chatMessage.toJson()}');
            onMessageReceived?.call(chatMessage);
          } else {
            print('No STOMP body found');
          }
        } else {
          print('Processing direct JSON message');
          // JSON message trực tiếp
          final jsonData = json.decode(message);
          final chatMessage = ChatMessage.fromJson(jsonData);
          print('Parsed ChatMessage: ${chatMessage.toJson()}');
          onMessageReceived?.call(chatMessage);
        }
      } else {
        print('Message is not a String: ${message.runtimeType}');
      }
    } catch (e) {
      print('=== WEBSOCKET RECEIVE ERROR ===');
      print('Error parsing message: $e');
      print('=== END WEBSOCKET RECEIVE ERROR ===');
      onError?.call('Error parsing message: $e');
    }
    print('=== END WEBSOCKET RECEIVE DEBUG ===');
  }

  // Gửi tin nhắn
  void sendMessage(ChatMessage message) {
    if (!_isConnected || _channel == null) {
      print('=== WEBSOCKET SEND ERROR ===');
      print(
        'WebSocket not connected. Connected: $_isConnected, Channel: ${_channel != null}',
      );
      print('=== END WEBSOCKET SEND ERROR ===');
      onError?.call('WebSocket not connected');
      return;
    }

    try {
      // Tạo STOMP SEND frame
      final jsonData = json.encode(message.toJson());
      final stompFrame =
          'SEND\ndestination:/app/chat.sendMessage\ncontent-type:application/json\n\n$jsonData\u0000';

      print('=== WEBSOCKET SEND DEBUG ===');
      print('WebSocket connected: $_isConnected');
      print('Message object: ${message.toJson()}');
      print('Message JSON: $jsonData');
      print('STOMP Frame length: ${stompFrame.length}');
      print('Destination: /app/chat.sendMessage');
      print('=== END WEBSOCKET SEND DEBUG ===');

      _channel!.sink.add(stompFrame);

      print('=== WEBSOCKET SEND SUCCESS ===');
      print('Message sent successfully via WebSocket');
      print('=== END WEBSOCKET SEND SUCCESS ===');
    } catch (e) {
      print('=== WEBSOCKET SEND ERROR ===');
      print('Error sending message: $e');
      print('=== END WEBSOCKET SEND ERROR ===');
      onError?.call('Error sending message: $e');
    }
  }

  // Subscribe vào topic
  void subscribeToRoom(String roomId) {
    if (!_isConnected || _channel == null) {
      onError?.call('WebSocket not connected');
      return;
    }

    try {
      final subscribeFrame =
          'SUBSCRIBE\nid:sub-$roomId\ndestination:/topic/rooms/$roomId\n\n\u0000';
      _channel!.sink.add(subscribeFrame);
    } catch (e) {
      onError?.call('Error subscribing: $e');
    }
  }

  // Ngắt kết nối
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    _isConnected = false;
    onDisconnected?.call();
  }

  // Dispose
  void dispose() {
    disconnect();
  }
}
