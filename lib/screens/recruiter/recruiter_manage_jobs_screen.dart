import 'package:flutter/material.dart';
import '../../widgets/job_detail/job_card.dart';
import 'recruiter_no_data_widget.dart';
import 'recruiter_post_job_screen.dart';

class RecruiterManageJobsScreen extends StatefulWidget {
  const RecruiterManageJobsScreen({super.key});

  @override
  State<RecruiterManageJobsScreen> createState() =>
      _RecruiterManageJobsScreenState();
}

class _RecruiterManageJobsScreenState extends State<RecruiterManageJobsScreen> {
  // Dữ liệu mẫu cứng cho UI demo
  final List<Map<String, String>> jobs = [
    {
      'title': 'Backend Developer',
      'company': 'Công ty ABC',
      'salary': '20-30 triệu',
      'location': 'Hà Nội',
      'status': 'open',
      'description': 'Phát triển API cho hệ thống.',
    },
    {
      'title': 'Frontend Developer',
      'company': 'Công ty XYZ',
      'salary': '15-25 triệu',
      'location': 'Hồ Chí Minh',
      'status': 'pending',
      'description': 'Xây dựng giao diện web.',
    },
  ];
  String searchQuery = '';

  List<Map<String, String>> getJobsByStatus(String status) =>
      jobs.where((job) => job['status'] == status).toList();

  List<Map<String, String>> filterJobs(List<Map<String, String>> jobList) {
    if (searchQuery.isEmpty) return jobList;
    final q = searchQuery.toLowerCase();
    return jobList
        .where(
          (job) =>
              (job['title'] ?? '').toLowerCase().contains(q) ||
              (job['company'] ?? '').toLowerCase().contains(q) ||
              (job['salary'] ?? '').toLowerCase().contains(q) ||
              (job['location'] ?? '').toLowerCase().contains(q) ||
              (job['description'] ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  Widget _buildStatsDescription(List<Map<String, String>> currentList) {
    // <<< THÊM MỚI >>> Lấy theme để sử dụng
    final theme = Theme.of(context);
    final listChucDanh = currentList.map((j) => j['title']).toSet().toList();
    String chucdanh = listChucDanh.join(', ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        "Hiện tại đang có ${currentList.length} vị trí"
        "${listChucDanh.isNotEmpty ? " (${chucdanh})" : ""}. "
        "Vị trí sẽ duyệt theo chức danh/vị trí công việc mà bạn đã đăng.",
        // <<< SỬA ĐỔI >>> Dùng màu chính của theme
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildSearchBar(void Function(String) onChanged) {
    // <<< THÊM MỚI >>> Lấy theme để sử dụng
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên, chức danh, lương, mô tả...',
          prefixIcon: const Icon(Icons.search),
          // <<< SỬA ĐỔI >>> Dùng màu card từ theme
          fillColor: theme.cardColor,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            // <<< SỬA ĐỔI >>> Dùng màu viền từ theme
            borderSide: BorderSide(color: theme.dividerColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder( // <<< THÊM MỚI >>> Thêm enabledBorder để đồng bộ
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme để sử dụng
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý vị trí'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                // <<< SỬA ĐỔI >>> TabBar sẽ tự động đổi màu theo theme
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                indicatorColor: theme.colorScheme.primary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: "Tất cả"),
                  Tab(text: "Đang mở"),
                  Tab(text: "Đang chờ duyệt"),
                  Tab(text: "Không được duyệt"),
                  Tab(text: "Đã đóng"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // TAB TẤT CẢ
            Column(
              children: [
                _buildStatsDescription(filterJobs(jobs)),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(jobs).isEmpty
                      ? const RecruiterNoDataWidget(text: "Chưa có vị trí nào!")
                      : ListView.builder(
                          itemCount: filterJobs(jobs).length,
                          itemBuilder: (context, index) {
                            final filteredJob = filterJobs(jobs)[index];
                            return JobCard(job: filteredJob);
                          },
                        ),
                ),
              ],
            ),
            // TAB ĐANG MỞ
            Column(
              children: [
                _buildStatsDescription(filterJobs(jobs)),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(jobs).isEmpty
                      ? const RecruiterNoDataWidget(text: "Chưa có vị trí nào!")
                      : ListView.builder(
                          itemCount: filterJobs(jobs).length,
                          itemBuilder: (context, index) {
                            final filteredJob = filterJobs(jobs)[index];
                            return JobCard(job: filteredJob);
                          },
                        ),
                ),
              ],
            ),
            // TAB ĐANG CHỜ DUYỆT
            Column(
              children: [
                _buildStatsDescription(filterJobs(getJobsByStatus("pending"))),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(getJobsByStatus("pending")).isEmpty
                      ? const RecruiterNoDataWidget(
                          text: "Chưa có vị trí chờ duyệt",
                        )
                      : ListView.builder(
                          itemCount: filterJobs(
                            getJobsByStatus("pending"),
                          ).length,
                          itemBuilder: (context, idx) {
                            final filteredJob = filterJobs(
                              getJobsByStatus("pending"),
                            )[idx];
                            return JobCard(job: filteredJob);
                          },
                        ),
                ),
              ],
            ),
            // KHÔNG ĐƯỢC DUYỆT
            Column(
              children: [
                _buildStatsDescription(filterJobs(getJobsByStatus("rejected"))),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(getJobsByStatus("rejected")).isEmpty
                      ? const RecruiterNoDataWidget(
                          text: "Không có vị trí bị từ chối",
                        )
                      : ListView.builder(
                          itemCount: filterJobs(
                            getJobsByStatus("rejected"),
                          ).length,
                          itemBuilder: (context, idx) {
                            final filteredJob = filterJobs(
                              getJobsByStatus("rejected"),
                            )[idx];
                            return JobCard(job: filteredJob);
                          },
                        ),
                ),
              ],
            ),
            // ĐÃ ĐÓNG
            Column(
              children: [
                _buildStatsDescription(filterJobs(getJobsByStatus("closed"))),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(getJobsByStatus("closed")).isEmpty
                      ? const RecruiterNoDataWidget(
                          text: "Không có vị trí đã đóng",
                        )
                      : ListView.builder(
                          itemCount: filterJobs(
                            getJobsByStatus("closed"),
                          ).length,
                          itemBuilder: (context, idx) {
                            final filteredJob = filterJobs(
                              getJobsByStatus("closed"),
                            )[idx];
                            return JobCard(job: filteredJob);
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecruiterPostJobScreen(),
                  ),
                );
              },
              // <<< SỬA ĐỔI >>> Nút sẽ tự động lấy màu từ theme
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Đăng một công việc mới",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}