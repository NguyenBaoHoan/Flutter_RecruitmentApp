import 'package:flutter/material.dart';

// CustomTabBar: Widget tab bar tự thiết kế, gồm 2 tab (Tất cả / Chưa đọc)
class CustomTabBar extends StatelessWidget {
  // Chỉ số tab đang chọn (0 hoặc 1)
  final int selectedIndex;

  // Hàm callback khi chọn tab mới
  final Function(int) onTabSelected;

  const CustomTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Lề xung quanh tab bar
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // Kiểu nền của tab bar
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(34),
      ),

      // Hai tab con nằm trong Row
      child: Row(
        children: [
          // Tab thứ nhất: Tất cả
          Expanded(
            child: GestureDetector(
              // Khi bấm gọi callback onTabSelected(0)
              onTap: () => onTabSelected(0),

              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                // Nếu được chọn -> nền màu xanh
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(34),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Tất cả',
                  style: TextStyle(
                    // Nếu được chọn -> text trắng, không thì xanh
                    color: selectedIndex == 0 ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // Tab thứ hai: Chưa đọc
          Expanded(
            child: GestureDetector(
              // Khi bấm gọi callback onTabSelected(1)
              onTap: () => onTabSelected(1),

              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                // Nếu được chọn -> nền màu xanh
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Chưa đọc',
                  style: TextStyle(
                    // Nếu được chọn -> text trắng, không thì xanh
                    color: selectedIndex == 1 ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
