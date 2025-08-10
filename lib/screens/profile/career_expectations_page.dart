import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/career_expectation.dart';
import '../../services/career_expectation_service.dart';
import '../../widgets/add_career_expectation_dialog.dart';
import '../../widgets/job_seeking_status_dialog.dart';
import '../../widgets/expectation_card.dart';

// Trang quản lý kỳ vọng nghề nghiệp của người dùng
class CareerExpectationsPage extends StatefulWidget {
  const CareerExpectationsPage({super.key});

  @override
  State<CareerExpectationsPage> createState() => _CareerExpectationsPageState();
}

class _CareerExpectationsPageState extends State<CareerExpectationsPage> {
  int? userId; // ID người dùng hiện tại
  bool loading = true; // Trạng thái loading khi lấy dữ liệu
  List<CareerExpectation> expectations = []; // Danh sách kỳ vọng nghề nghiệp
  int count = 0; // Số lượng kỳ vọng hiện tại
  int maxCount = 3; // Số lượng kỳ vọng tối đa
  String jobSeekingStatus = JobSeekingStatus.readyNow; // Trạng thái tìm việc
  String jobSeekingStatusDisplay =
      'Sẵn sàng nhận việc ngay'; // Hiển thị trạng thái tìm việc

  @override
  void initState() {
    super.initState();
    _initData(); // Khởi tạo dữ liệu khi mở màn hình
  }

  // Lấy userId từ local và load danh sách kỳ vọng
  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {
      await _loadExpectations();
    }

    setState(() {
      loading = false;
    });
  }

  // Gọi API lấy danh sách kỳ vọng nghề nghiệp và trạng thái tìm việc
  Future<void> _loadExpectations() async {
    if (userId == null) return;

    final data = await CareerExpectationService.fetchCareerExpectations(
      userId!,
    );
    if (data != null) {
      setState(() {
        expectations = data['expectations'];
        count = data['count'];
        maxCount = data['maxCount'];
        jobSeekingStatus = data['jobSeekingStatus'];
        jobSeekingStatusDisplay = data['jobSeekingStatusDisplay'];
      });
    }
  }

  // Hiển thị dialog thêm kỳ vọng nghề nghiệp mới
  void _showAddExpectationDialog() {
    if (count >= maxCount) {
      _showSnackBar('Bạn chỉ có thể tạo tối đa $maxCount kỳ vọng nghề nghiệp');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCareerExpectationDialog(
        userId: userId!,
        onSuccess: () async {
          await _loadExpectations(); // Reload danh sách sau khi thêm thành công
          Navigator.pop(context);
          _showSnackBar('Đã thêm kỳ vọng nghề nghiệp thành công');
        },
      ),
    );
  }

  // Hiển thị dialog chọn trạng thái tìm việc
  void _showJobSeekingStatusDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => JobSeekingStatusDialog(
        currentStatus: jobSeekingStatus,
        onStatusChanged: (newStatus) async {
          Navigator.pop(context);

          if (userId != null) {
            final success =
                await CareerExpectationService.updateJobSeekingStatus(
                  userId!,
                  newStatus,
                );

            if (success) {
              await _loadExpectations(); // Reload để đảm bảo sync
              _showSnackBar('Đã cập nhật trạng thái tìm việc');
            } else {
              _showSnackBar('Cập nhật thất bại');
            }
          }
        },
      ),
    );
  }

  // Gọi API xóa kỳ vọng nghề nghiệp và reload danh sách
  Future<void> _deleteExpectation(int expectationId) async {
    if (userId == null) return;

    // Hiển thị loading khi đang xóa
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await CareerExpectationService.deleteCareerExpectation(
      userId!,
      expectationId,
    );

    // Đóng dialog loading
    Navigator.pop(context);

    if (success) {
      // Reload danh sách
      await _loadExpectations();
      _showSnackBar('Đã xóa kỳ vọng nghề nghiệp thành công');
    } else {
      _showSnackBar('Xóa thất bại, vui lòng thử lại');
    }
  }

  // Hiển thị thông báo SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kỳ vọng nghề nghiệp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header với số lượng kỳ vọng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thêm vị trí mong muốn của bạn',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$count/$maxCount',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Mô tả ngắn về chức năng
                  Text(
                    'Thêm nhiều kỳ vọng tìm kiếm việc làm để có được cơ hội việc làm công nghệ cao chính xác hơn',
                    style: TextStyle(fontSize: 14, color: theme.hintColor),
                  ),
                  const SizedBox(height: 24),

                  // Danh sách các kỳ vọng nghề nghiệp đã tạo
                  ...expectations.map(
                    (expectation) => ExpectationCard(
                      expectation: expectation,
                      onDelete: () => _deleteExpectation(expectation.id),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nút thêm kỳ vọng mới (chỉ hiển thị khi chưa đủ maxCount)
                  if (count < maxCount)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.dividerColor),
                      ),
                      child: InkWell(
                        onTap: _showAddExpectationDialog,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: theme.primaryColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Thêm kỳ vọng nghề nghiệp',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Card trạng thái tìm việc
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: _showJobSeekingStatusDialog,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Icon trạng thái
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.work_outline,
                                color: theme.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Thông tin trạng thái
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Trạng thái tìm việc',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    jobSeekingStatusDisplay,
                                    style: TextStyle(
                                      color: theme.hintColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: theme.hintColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
