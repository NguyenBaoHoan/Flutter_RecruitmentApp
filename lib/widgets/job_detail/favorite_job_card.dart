// lib/widgets/favorite_job_card.dart
import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../screens/job_detail/job_detail_screen.dart'; // To navigate to details
import '../../services/favorite_job_service.dart';

class FavoriteJobCard extends StatelessWidget {
  final Job job;
  final int userId;
  final VoidCallback onRemoved; // Callback to refresh the list

  const FavoriteJobCard({
    super.key,
    required this.job,
    required this.userId,
    required this.onRemoved,
  });

  void _removeFavorite(BuildContext context) async {
    try {
      await FavoriteJobService().removeFromFavorites(userId, job.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa công việc khỏi danh sách yêu thích')),
      );
      onRemoved(); // Trigger the refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to JobDetailScreen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(job: job),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Company Logo
              Image.asset(
                job.companyLogoAsset,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.business, size: 50),
              ),
              const SizedBox(width: 12),
              // Job Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.companyName,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Remove Button
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => _removeFavorite(context),
                tooltip: 'Xóa khỏi yêu thích',
              ),
            ],
          ),
        ),
      ),
    );
  }
}