// lib/screens/home/job_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/job_model.dart'; // <-- Import Job model
import '../../services/user_preferences_service.dart';
import '../../widgets/job_detail/bullet_list_item.dart';
import '../../widgets/job_detail/company_info_card.dart';
import '../../widgets/job_detail/favorite_button.dart'; // <-- Import new widget
import '../../widgets/job_detail/info_chip.dart';
import '../../widgets/job_detail/map_widget.dart';
import '../../widgets/job_detail/section_header.dart';

class JobDetailScreen extends StatefulWidget {
  // **REFACTORED**: Use the Job object directly for type safety
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  int? _userId;
  bool _isLoadingUserId = true;

  @override
  void initState() {
    super.initState();
    // Log khi vào màn chi tiết job
    print(
      '➡️ [JOB DETAIL] Opened | jobId=${widget.job.id}, jobName=${widget.job.name}',
    );
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final userId = await UserPreferencesService.getUserId();
      // Log sau khi lấy userId
      print('👤 [JOB DETAIL] Loaded | userId=$userId, jobId=${widget.job.id}');
      setState(() {
        _userId = userId;
        _isLoadingUserId = false;
      });
    } catch (e) {
      print('❌ [JOB DETAIL] Error loading userId: $e');
      setState(() {
        _isLoadingUserId = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // <<< SỬA ĐỔI >>> AppBar sẽ tự động đổi màu
      appBar: AppBar(
        title: Text(
          widget.job.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        // actions và leading sẽ tự động đổi màu theo theme
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Builder(
              builder: (context) {
                // Không có id job thì không hiển thị
                if (widget.job.id == null) return const SizedBox.shrink();

                // Đang tải userId -> spinner
                if (_isLoadingUserId) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                // Chưa đăng nhập -> vẫn hiển thị tim rỗng
                if (_userId == null) {
                  return IconButton(
                    tooltip: 'Thêm yêu thích',
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng đăng nhập để thêm vào yêu thích',
                          ),
                        ),
                      );
                    },
                  );
                }

                // Đã đăng nhập -> dùng FavoriteButton
                return FavoriteButton(jobId: widget.job.id!, userId: _userId!);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildJobHeader(context), _buildJobDetails(context)],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildJobHeader(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme để sử dụng
    final theme = Theme.of(context);

    return Container(
      // <<< SỬA ĐỔI >>> Dùng màu card từ theme
      color: theme.cardColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.job.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.job.salary,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // <<< SỬA ĐỔI >>> Dùng màu error từ theme để nổi bật
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              InfoChip(icon: Icons.location_on_outlined, text: widget.job.location),
              InfoChip(icon: Icons.work_outline, text: widget.job.experience),
              InfoChip(icon: Icons.school_outlined, text: widget.job.educationLevel),
              InfoChip(icon: Icons.schedule_outlined, text: widget.job.jobType),
              InfoChip(icon: Icons.today_outlined, text: widget.job.postedDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetails(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(top: 8),
      // <<< SỬA ĐỔI >>> Dùng màu card từ theme
      color: theme.cardColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Các SectionHeader và Text sẽ tự động đổi màu
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
          ...widget.job.benefits
              .map((item) => BulletListItem(text: item))
              .toList(),

          const Divider(height: 32),
          const SectionHeader(title: 'Địa chỉ làm việc'),
          Text(
            widget.job.workAddress,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 16),
          MapWidget(
            address: widget.job.workAddress,
            companyName: widget.job.companyName,
          ),
          const SizedBox(height: 24),
          // Giả sử CompanyInfoCard đã được tối ưu hóa
          // CompanyInfoCard(job: widget.job),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // <<< SỬA ĐỔI >>> Dùng màu từ theme
          color: theme.cardColor,
          border: Border(
            top: BorderSide(color: theme.dividerColor, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () { /* TODO: Logic gửi CV */ },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Gửi CV'),
                // Style của OutlinedButton thường tự thích ứng tốt
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: theme.colorScheme.primary,
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
                onPressed: () { /* TODO: Logic liên hệ */ },
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Liên hệ ngay'),
                // <<< SỬA ĐỔI >>> Dùng màu từ theme
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
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