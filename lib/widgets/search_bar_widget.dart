// widgets/search_bar_widget.dart
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBarWidget({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onSearch,
        decoration: const InputDecoration(
          hintText: 'Tìm kiếm việc làm...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
