import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Biến để lưu trạng thái của các switch
  bool _newMessages = true;
  bool _profileUpdates = true;
  bool _jobSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo và nhắc nhở'),
      ),
      body: ListView(
        children: [
          _buildSwitchTile(
            title: 'Tin nhắn mới',
            subtitle: 'Nhận thông báo khi có tin nhắn mới từ nhà tuyển dụng.',
            value: _newMessages,
            onChanged: (newValue) {
              setState(() => _newMessages = newValue);
              // TODO: Gọi API để lưu cài đặt này
            },
          ),
          _buildSwitchTile(
            title: 'Cập nhật hồ sơ',
            subtitle: 'Nhận thông báo khi nhà tuyển dụng xem hồ sơ hoặc cập nhật trạng thái ứng tuyển.',
            value: _profileUpdates,
            onChanged: (newValue) {
              setState(() => _profileUpdates = newValue);
              // TODO: Gọi API để lưu cài đặt này
            },
          ),
          _buildSwitchTile(
            title: 'Gợi ý việc làm',
            subtitle: 'Nhận thông báo về các việc làm mới phù hợp với bạn.',
            value: _jobSuggestions,
            onChanged: (newValue) {
              setState(() => _jobSuggestions = newValue);
              // TODO: Gọi API để lưu cài đặt này
            },
          ),
        ],
      ),
    );
  }

  // Widget tùy chỉnh cho mỗi mục cài đặt
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}