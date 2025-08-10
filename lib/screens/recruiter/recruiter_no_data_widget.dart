import 'package:flutter/material.dart';

class RecruiterNoDataWidget extends StatelessWidget {
  final String? text;
  const RecruiterNoDataWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme hiện tại để sử dụng
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // <<< SỬA ĐỔI >>> Icon sẽ tự động đổi màu
          Icon(Icons.work_off, size: 100, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            text ?? 'Chưa có dữ liệu',
            // <<< SỬA ĐỔI >>> Text sẽ tự động đổi màu
            style: TextStyle(fontSize: 16, color: theme.disabledColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}