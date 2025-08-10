// lib/screens/user_home_screen.dart

import 'package:flutter/material.dart';
import 'package:job_finder_app/widgets/main_bottom_nav_bar.dart';
import 'package:job_finder_app/widgets/nav_helper.dart';
import '../../../models/job_model.dart';
import '../../widgets/job_detail/job_card.dart';
import '../choose_area/choose_area_screen.dart';
import '../../screens/job_detail/job_detail_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../services/job_api_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // Dùng API thay cho dữ liệu mẫu
  final JobApiService _jobApi = JobApiService();
  final List<Job> jobs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final data = await _jobApi.getAllJobs();
      setState(() {
        jobs
          ..clear()
          ..addAll(data);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    handleMainNavTap(context, index);
  }

  @override
  Widget build(BuildContext context) {
    // <<< SỬA ĐỔI >>> Xóa màu nền cố định, Scaffold sẽ tự lấy màu từ theme
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildResumeAlert(),
            _buildFilterChips(),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text('Lỗi: $_error'))
                      : ListView.builder(
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            // Giả sử JobCard đã được tối ưu hóa
                            return JobCard(job: jobs[index].toMap());
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTopBar() {
    // <<< THÊM MỚI >>> Lấy theme để sử dụng
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseAreaScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                // <<< SỬA ĐỔI >>> Dùng màu từ theme
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.dividerColor),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on_outlined), // Icon sẽ tự đổi màu
                  SizedBox(width: 8),
                  Text('Khu vực'),
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildIconButton(Icons.search),
          _buildIconButton(Icons.add),
          _buildIconButton(Icons.filter_list),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        // <<< SỬA ĐỔI >>> Dùng màu từ theme
        color: theme.cardColor,
        shape: BoxShape.circle,
        border: Border.all(color: theme.dividerColor),
      ),
      child: IconButton(
        icon: Icon(icon), // Icon sẽ tự đổi màu
        onPressed: () {
          if (icon == Icons.search) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          }
          // Xử lý các icon khác nếu cần
        },
      ),
    );
  }

  Widget _buildResumeAlert() {
    // <<< THÊM MỚI >>> Lấy theme để sử dụng
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // <<< SỬA ĐỔI >>> Dùng màu phù hợp cho cả 2 chế độ
        color: isDarkMode ? Colors.grey[800] : Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                // <<< SỬA ĐỔI >>> Đảm bảo style chữ phù hợp
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                children: [
                  const TextSpan(
                    text:
                        'Sơ yếu lý lịch đã được ẩn. Mở nó ra có thể cải thiện hiệu quả tìm kiếm việc làm. ',
                  ),
                  TextSpan(
                    text: 'CV mở',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: theme.colorScheme.secondary, // Dùng màu nhấn từ theme
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ActionChip(
            label: const Text('Việc làm hấp dẫn'),
            onPressed: () {},
            // <<< SỬA ĐỔI >>> Dùng màu từ theme
            backgroundColor: theme.colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          ActionChip(
            label: const Text('Fullstack Developer'),
            onPressed: () {},
            // <<< SỬA ĐỔI >>> Dùng màu từ theme
            backgroundColor: theme.colorScheme.secondaryContainer,
            labelStyle: TextStyle(color: theme.colorScheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}
