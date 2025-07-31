
import 'package:flutter/material.dart';

// SectionHeader là một widget dùng để hiển thị tiêu đề cho từng phần trong giao diện.
// Nó nhận vào một chuỗi 'title' và hiển thị nó với kiểu chữ lớn, đậm, có khoảng cách phía trên và dưới.

class SectionHeader extends StatelessWidget {
  // Thuộc tính title là tiêu đề sẽ được hiển thị
  final String title;

  // Hàm khởi tạo nhận vào title, super.key để hỗ trợ key cho widget
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Widget Padding giúp tạo khoảng cách trên/dưới cho tiêu đề
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Cách đều 16px trên và dưới
      child: Text(
        title, // Hiển thị nội dung tiêu đề
        style: const TextStyle(
          fontSize: 18, // Cỡ chữ 18
          fontWeight: FontWeight.bold, // Chữ in đậm
        ),
      ),
    );
  }
}