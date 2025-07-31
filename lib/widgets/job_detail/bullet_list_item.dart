
import 'package:flutter/material.dart';

class BulletListItem extends StatelessWidget {
  final String text;
  const BulletListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("✓ ", style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.55)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}