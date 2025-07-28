# Chat Implementation Guide

## Tổng quan
Đây là implementation chat realtime cho ứng dụng tuyển dụng việc làm, kết nối Flutter với Spring Boot WebSocket backend.

## Cấu trúc Files

### Models
- `lib/models/chat_message.dart` - Model cho tin nhắn chat
- `lib/models/chat_room.dart` - Model cho phòng chat
- `lib/models/chat_model.dart` - Model cho UI chat list (đã cập nhật)

### Services
- `lib/services/websocket_service.dart` - WebSocket service để kết nối realtime
- `lib/services/chat_api_service.dart` - REST API service

### Screens
- `lib/screens/chat/chat_list_screen.dart` - Màn hình danh sách chat (đã cập nhật)
- `lib/screens/chat/chat_detail_screen.dart` - Màn hình chat chi tiết (mới)
- `lib/screens/chat/chat_item.dart` - Widget item chat (đã cập nhật)

## Cài đặt

### 1. Thêm dependencies
Đã thêm vào `pubspec.yaml`:
```yaml
web_socket_channel: ^2.4.0
```

### 2. Cấu hình IP
Thay đổi IP trong các file sau:
- `lib/services/websocket_service.dart` - Dòng 6: `ws://192.168.88.114:8080/ws`
- `lib/services/chat_api_service.dart` - Dòng 6: `http://192.168.88.114:8080`

### 3. Chạy lệnh
```bash
flutter pub get
```

## Cách sử dụng

### 1. Backend (Spring Boot)
- Đảm bảo backend đang chạy trên port 8080
- WebSocket endpoint: `/ws`
- REST endpoints: `/chat/rooms/{roomId}/messages`, `/chat/users/{userId}/rooms`

### 2. Flutter App
- Chạy app: `flutter run`
- Vào màn hình Chat
- Tap vào một conversation để mở chat detail
- Gửi tin nhắn realtime

## Tính năng

### ✅ Đã implement
- [x] Kết nối WebSocket với Spring Boot
- [x] Lấy danh sách phòng chat từ REST API
- [x] Lấy lịch sử tin nhắn
- [x] Gửi tin nhắn realtime qua WebSocket
- [x] Nhận tin nhắn realtime
- [x] UI đẹp theo design hiện tại
- [x] Error handling và loading states

### 🔄 Cần bổ sung (tùy chọn)
- [ ] Authentication (JWT token)
- [ ] Push notifications
- [ ] File/image sharing
- [ ] Typing indicators
- [ ] Online/offline status
- [ ] Message read receipts

## Luồng hoạt động

1. **Kết nối WebSocket**: App tự động kết nối khi vào màn hình chat
2. **Load danh sách chat**: Gọi REST API để lấy danh sách phòng chat
3. **Vào chat detail**: Tap vào item để mở màn hình chat chi tiết
4. **Subscribe topic**: Tự động subscribe vào topic của phòng chat
5. **Gửi tin nhắn**: Gửi qua WebSocket, nhận broadcast realtime
6. **Lưu tin nhắn**: Backend tự động lưu vào database

## Troubleshooting

### WebSocket không kết nối được
- Kiểm tra IP backend có đúng không
- Đảm bảo backend đang chạy
- Kiểm tra firewall/network

### REST API lỗi
- Kiểm tra URL và port
- Đảm bảo backend có CORS config
- Kiểm tra authentication nếu có

### Tin nhắn không gửi được
- Kiểm tra WebSocket connection
- Kiểm tra STOMP frame format
- Kiểm tra backend logs

## Notes
- Hiện tại dùng mock user ID = 1, cần thay bằng user thật từ authentication
- Có thể thêm loading indicators và error messages chi tiết hơn
- Có thể optimize performance bằng cách cache messages 