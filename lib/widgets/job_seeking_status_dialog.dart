import 'package:flutter/material.dart';
import '../models/career_expectation.dart';

// Dialog chọn trạng thái tìm việc
class JobSeekingStatusDialog extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;

  const JobSeekingStatusDialog({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header dialog
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trạng thái tìm việc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Danh sách các trạng thái tìm việc
          ...JobSeekingStatus.getDisplayMap().entries.map((entry) {
            return RadioListTile<String>(
              value: entry.key,
              groupValue: currentStatus,
              title: Text(entry.value),
              onChanged: (value) => onStatusChanged(value!),
            );
          }).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
