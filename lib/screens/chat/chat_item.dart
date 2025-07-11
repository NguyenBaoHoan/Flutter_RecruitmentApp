import 'package:flutter/material.dart';
import '../../models/chat_model.dart';

// Widget ChatItem: Dùng để hiển thị 1 item chat trong danh sách chat
class ChatItem extends StatelessWidget {
  // Nhận vào 1 đối tượng ChatModel
  final ChatModel chat;

  // Constructor: bắt buộc phải truyền vào ChatModel
  const ChatItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Khoảng cách lề ngoài item
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

      // Hiển thị nội dung theo hàng ngang: Avatar - Nội dung - Thời gian
      child: Row(
        children: [
          // Phần avatar người chat
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue[100],
            // Nếu avatarUrl không rỗng -> load ảnh từ mạng
            backgroundImage: chat.avatarUrl.isNotEmpty
                ? NetworkImage(chat.avatarUrl)
                : null,
            // Nếu avatarUrl rỗng -> hiển thị icon mặc định
            child: chat.avatarUrl.isEmpty
                ? Icon(Icons.notifications, color: Colors.blue, size: 32)
                : null,
          ),

          // Khoảng cách giữa avatar và nội dung chat
          const SizedBox(width: 14),

          // Nội dung tin nhắn: tên & tin nhắn cuối
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người/nhóm chat
                Text(
                  chat.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 4),

                // Tin nhắn gần nhất
                Text(
                  chat.lastMessage,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    // Nếu tin nhắn chưa đọc -> bôi đậm
                    fontWeight: chat.isUnread
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  maxLines: 1, // Chỉ hiển thị 1 dòng
                  overflow: TextOverflow.ellipsis, // Nếu dài thì thêm dấu "..."
                ),
              ],
            ),
          ),

          // Thời gian + chấm thông báo nếu chưa đọc
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Thời gian tin nhắn
              Text(
                chat.time,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),

              // Nếu tin nhắn chưa đọc -> hiện chấm xanh
              if (chat.isUnread)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
