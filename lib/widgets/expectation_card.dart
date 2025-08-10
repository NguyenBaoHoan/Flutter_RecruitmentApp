import 'package:flutter/material.dart';
import '../models/career_expectation.dart';

// Widget hiển thị từng kỳ vọng nghề nghiệp
class ExpectationCard extends StatelessWidget {
  final CareerExpectation expectation;
  final VoidCallback onDelete;

  const ExpectationCard({
    super.key,
    required this.expectation,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.primaryColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Tên vị trí mong muốn
                Expanded(
                  child: Text(
                    expectation.desiredPosition,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Icon xóa kỳ vọng nghề nghiệp
                IconButton(
                  onPressed: () => _showDeleteConfirmDialog(context),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[400],
                    size: 20,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                ),
                const SizedBox(width: 8),
                // Icon điều hướng (chưa có chức năng)
                Icon(Icons.arrow_forward_ios, color: theme.hintColor, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            // Loại hình công việc và mức lương
            Text(
              '${expectation.jobTypeDisplay} · ${expectation.salaryRange}',
              style: TextStyle(color: theme.hintColor, fontSize: 14),
            ),
            const SizedBox(height: 4),
            // Ngành nghề mong muốn
            Text(
              expectation.desiredIndustry,
              style: TextStyle(color: theme.hintColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị dialog xác nhận xóa kỳ vọng nghề nghiệp
  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Xác nhận xóa',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa kỳ vọng nghề nghiệp:\n"${expectation.desiredPosition}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
