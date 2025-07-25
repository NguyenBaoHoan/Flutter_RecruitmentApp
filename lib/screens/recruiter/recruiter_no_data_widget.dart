import 'package:flutter/material.dart';

class RecruiterNoDataWidget extends StatelessWidget {
  final String? text;
  const RecruiterNoDataWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.work_off, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            text ?? 'Chưa có dữ liệu',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
