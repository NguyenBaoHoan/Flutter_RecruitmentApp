import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';
import '../models/chat_message.dart';

class WebSocketService {
  // --- Singleton Pattern ---
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  // --- Stomp Client ---
  StompClient? _stompClient;
  bool _isConnected = false;

  // --- Callbacks ---
  // Sử dụng StreamController để nhiều nơi có thể lắng nghe cùng lúc
  final StreamController<ChatMessage> _messageController =
      StreamController.broadcast();
  Stream<ChatMessage> get onMessageReceived => _messageController.stream;

  Function(String)? onError;
  Function()? onConnected;
  Function()? onDisconnected;

  // --- Trạng thái kết nối ---
  bool get isConnected => _isConnected;

  // --- Quản lý các subscription ---
  // Key là destination (vd: /topic/rooms/1_2), value là hàm un-subscribe
  final Map<String, StompUnsubscribe> _subscriptions = {};

  void connect() {
    if (_isConnected) {
      print("WebSocket is already connected.");
      return;
    }

    print("Connecting to WebSocket...");
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.2:8080/ws', // Thay bằng IP của bạn nếu cần
        onConnect: _onConnectCallback,
        onDisconnect: _onDisconnectCallback,
        onWebSocketError: (dynamic error) {
          print("WebSocket Error: $error");
          _isConnected = false;
          onError?.call(error.toString());
        },
        onStompError: (StompFrame frame) {
          print("STOMP Error: ${frame.body}");
          onError?.call(frame.body ?? 'STOMP Error');
        },
      ),
    );

    _stompClient!.activate();
  }

  void _onConnectCallback(StompFrame frame) {
    _isConnected = true;
    print("WebSocket connected successfully.");
    onConnected?.call();
  }

  void _onDisconnectCallback(StompFrame frame) {
    _isConnected = false;
    print("WebSocket disconnected.");
    _subscriptions.clear(); // Xóa tất cả subscription khi mất kết nối
    onDisconnected?.call();
  }

  void subscribeToRoom(String roomId) {
    if (!_isConnected || _stompClient == null) {
      print("Cannot subscribe, WebSocket is not connected.");
      return;
    }

    final destination = '/topic/rooms/$roomId';

    // Nếu đã subscribe rồi thì không làm lại
    if (_subscriptions.containsKey(destination)) {
      print("Already subscribed to $destination");
      return;
    }

    print("Subscribing to $destination");
    final unsubscribeCallback = _stompClient!.subscribe(
      destination: destination,
      callback: (frame) {
        if (frame.body != null) {
          try {
            final jsonData = json.decode(frame.body!);
            final chatMessage = ChatMessage.fromJson(jsonData);
            _messageController.add(chatMessage); // Đẩy message vào stream
          } catch (e) {
            print("Error parsing message: $e");
          }
        }
      },
    );
    // Lưu lại hàm unsubscribe để có thể hủy sau này
    _subscriptions[destination] = unsubscribeCallback;
  }

  void unsubscribeFromRoom(String roomId) {
    final destination = '/topic/rooms/$roomId';
    if (_subscriptions.containsKey(destination)) {
      print("Unsubscribing from $destination");
      // Gọi hàm hủy đăng ký
      _subscriptions[destination]!();
      // Xóa khỏi danh sách đã đăng ký
      _subscriptions.remove(destination);
    }
  }

  void sendMessage(ChatMessage message) {
    if (!_isConnected || _stompClient == null) {
      print("Cannot send message, WebSocket is not connected.");
      return;
    }

    _stompClient!.send(
      destination: '/app/chat.sendMessage',
      body: json.encode(message.toJson()),
    );
    print("Message sent to /app/chat.sendMessage");
  }

  void disconnect() {
    if (_stompClient != null) {
      _stompClient!.deactivate();
    }
    _isConnected = false;
    print("WebSocket service deactivated.");
  }

  // Không cần dispose Singleton, nhưng có thể thêm hàm reset nếu cần
}
