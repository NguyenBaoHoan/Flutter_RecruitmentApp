// lib/screens/job_detail/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:job_finder_app/models/job_model.dart';
import 'package:job_finder_app/widgets/job_detail/bullet_list_item.dart';
import 'package:job_finder_app/widgets/job_detail/company_info_card.dart';
import 'package:job_finder_app/widgets/job_detail/info_chip.dart';
import 'package:job_finder_app/widgets/job_detail/section_header.dart';
import '../../widgets/job_detail/map_widget.dart';

class JobDetailScreen extends StatefulWidget {
  final Job job; // Nhận dữ liệu công việc từ màn hình trước

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Sử dụng màu nền từ theme của bạn
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Back-End Developer', // Tiêu đề AppBar
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phần thông tin chính
            _buildJobHeader(context),

            // Phần chi tiết (trong một card trắng)
            _buildJobDetails(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildJobHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.job.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.job.salary,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              InfoChip(
                icon: Icons.location_on_outlined,
                text: widget.job.location,
              ),
              InfoChip(icon: Icons.work_outline, text: widget.job.experience),
              InfoChip(
                icon: Icons.school_outlined,
                text: widget.job.educationLevel,
              ),
              InfoChip(icon: Icons.schedule_outlined, text: widget.job.jobType),
              InfoChip(icon: Icons.today_outlined, text: widget.job.postedDate),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFF3E0), // Màu vàng nhạt
              child: Icon(
                Icons.person,
                color: Color(0xFFFFA726),
              ), // Màu vàng cam
            ),
            title: const Text(
              'Nhân sự',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Nhân sự'),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetails(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Chi tiết công việc'),
          const Text(
            'Mô Tả:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...widget.job.description
              .map((item) => BulletListItem(text: item))
              .toList(),
          const SizedBox(height: 16),
          const Text(
            'Yêu Cầu:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...widget.job.requirements
              .map((item) => BulletListItem(text: item))
              .toList(),
          const Divider(height: 32),

          const SectionHeader(title: 'Lợi ích công việc'),
          ...widget.job.benefits.map((item) {
            final parts = item.split(':');
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
                  children: [
                    TextSpan(
                      text: '${parts[0]}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: parts.length > 1 ? parts[1].trim() : ''),
                  ],
                ),
              ),
            );
          }).toList(),
          const Divider(height: 32),

          const SectionHeader(title: 'Địa chỉ làm việc'),
          Text(
            widget.job.workAddress,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Giải thích chi tiết về widget.job.workAddress:
          //
          // 1. `widget` là một thuộc tính đặc biệt trong State class (_JobDetailScreenState) của StatefulWidget (JobDetailScreen).
          //    Khi bạn tạo một StatefulWidget, bạn sẽ có 2 class: 
          //    - class JobDetailScreen extends StatefulWidget
          //    - class _JobDetailScreenState extends State<JobDetailScreen>
          //    Trong class State, bạn có thể truy cập các thuộc tính của widget cha thông qua biến `widget`.
          //
          // 2. `job` là một thuộc tính của JobDetailScreen (được truyền vào khi tạo màn hình này).
          //    Nó chứa thông tin về công việc, ví dụ: tên công ty, mô tả, địa chỉ làm việc, v.v.
          //
          // 3. `workAddress` là một thuộc tính của đối tượng job, lưu trữ địa chỉ làm việc của công việc đó.
          //
          // => Vì vậy, `widget.job.workAddress` sẽ lấy ra địa chỉ làm việc của công việc hiện tại, 
          //    được truyền từ màn hình trước vào JobDetailScreen.
          //
          // Ví dụ: Khi bạn mở chi tiết một công việc, màn hình này sẽ nhận một đối tượng Job (job) 
          // và bạn có thể truy cập các thông tin của công việc đó qua widget.job.
          MapWidget(
            address: widget.job.workAddress,
            companyName: widget.job.companyName,
          ),
          const SizedBox(height: 24),

          CompanyInfoCard(job: widget.job),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  /* TODO: Logic gửi CV */
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Gửi CV'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  /* TODO: Logic liên hệ */
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Liên hệ ngay'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary, // Dùng màu từ theme
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
