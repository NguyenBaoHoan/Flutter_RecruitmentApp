// lib/widgets/job_detail/job_card.dart

import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../screens/job_detail/job_detail_screen.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job; // vẫn giữ Map theo cấu trúc hiện tại

  const JobCard({super.key, required this.job});

  Job _toJob(Map<String, dynamic> m) {
    List<String> listOf(dynamic v) {
      if (v == null) return const <String>[];
      if (v is List) return v.map((e) => e.toString()).toList();
      return <String>[v.toString()];
    }

    return Job(
      id: (m['id'] is int) ? m['id'] as int : int.tryParse('${m['id']}'),
      name: (m['title'] ?? m['name'] ?? '').toString(),
      salary: (m['salary'] ?? '').toString(),
      location: (m['location'] ?? '').toString(),
      experience: (m['experience'] ?? '').toString(),
      educationLevel: (m['educationLevel'] ?? '').toString(),
      jobType: (m['jobType'] ?? '').toString(),
      postedDate: (m['postedDate'] ?? '').toString(),
      description: listOf(m['description']),
      requirements: listOf(m['requirements']),
      benefits: listOf(m['benefits']),
      workAddress: (m['workAddress'] ?? '').toString(),
      companyName: (m['companyName'] ?? m['company'] ?? '').toString(),
      companyLogoAsset: (m['companyLogoAsset'] ?? '').toString(),
      locationCompany: (m['locationCompany'] ?? '').toString(),
      companySize: (m['companySize'] ?? '').toString(),
      companyIndustry: (m['companyIndustry'] ?? '').toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final jobModel = _toJob(job);
        print('🟣 [JOB CARD] Tap -> jobId=${jobModel.id}, name=${jobModel.name}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => JobDetailScreen(job: jobModel)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.business_center, // Icon mẫu
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['company'] ?? '',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(job['salary'] ?? '', Colors.grey[200]!),
                const SizedBox(width: 8),
                _buildInfoChip(job['location'] ?? '', Colors.grey[200]!),
                const SizedBox(width: 8),
                _buildInfoChip(job['postDate'] ?? '', Colors.grey[200]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
    );
  }
}
