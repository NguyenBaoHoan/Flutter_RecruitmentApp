import 'package:flutter/material.dart';
import '../models/career_expectation.dart';
import '../services/career_expectation_service.dart';
import 'selection_dialogs.dart';

// Dialog thêm kỳ vọng nghề nghiệp mới
class AddCareerExpectationDialog extends StatefulWidget {
  final int userId;
  final VoidCallback onSuccess;

  const AddCareerExpectationDialog({
    super.key,
    required this.userId,
    required this.onSuccess,
  });

  @override
  State<AddCareerExpectationDialog> createState() =>
      _AddCareerExpectationDialogState();
}

class _AddCareerExpectationDialogState
    extends State<AddCareerExpectationDialog> {
  String jobType = JobTypeOptions.fullTime; // Loại hình công việc mặc định
  String desiredPosition = ''; // Vị trí mong muốn
  String desiredIndustry = ''; // Ngành nghề mong muốn
  String desiredCity = ''; // Thành phố mong muốn
  String selectedSalaryKey = 'negotiate'; // Mức lương mặc định
  double? minSalary;
  double? maxSalary;
  bool loading = false; // Trạng thái loading khi submit

  final salaryRanges = SalaryRangeOptions.getSalaryRanges();
  final positions = PositionOptions.getPositions();
  final industries = IndustryOptions.getIndustries();
  final cities = CityOptions.getCities();

  // Xử lý submit form thêm kỳ vọng nghề nghiệp
  Future<void> _submitForm() async {
    // Kiểm tra các trường bắt buộc
    if (desiredPosition.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn vị trí mong muốn')),
      );
      return;
    }
    if (desiredIndustry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngành nghề mong muốn')),
      );
      return;
    }
    if (desiredCity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn thành phố mong muốn')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    // Tạo dữ liệu gửi lên API
    final data = {
      'jobType': jobType,
      'desiredPosition': desiredPosition,
      'desiredIndustry': desiredIndustry,
      'desiredCity': desiredCity,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
    };

    final success = await CareerExpectationService.createCareerExpectation(
      widget.userId,
      data,
    );

    setState(() {
      loading = false;
    });

    if (success) {
      widget.onSuccess(); // Reload danh sách ở màn hình cha
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo kỳ vọng nghề nghiệp thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                const Text(
                  'Thêm vào kỳ vọng nghề nghiệp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          // Form nhập/chọn thông tin kỳ vọng
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Để xuất các vị trí độc quyền cho bạn dựa trên mong đợi tìm kiếm việc làm của bạn',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Chọn loại hình công việc
                  _buildSelectField(
                    'Loại hình công việc',
                    JobTypeOptions.getDisplayMap()[jobType]!,
                    () => SelectionDialogs.showJobTypeDialog(context, jobType, (
                      value,
                    ) {
                      setState(() => jobType = value);
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Chọn vị trí mong muốn
                  _buildSelectField(
                    'Vị trí mong muốn',
                    desiredPosition.isEmpty
                        ? 'Chọn vị trí mong muốn'
                        : desiredPosition,
                    () => SelectionDialogs.showPositionDialog(
                      context,
                      positions,
                      desiredPosition,
                      (value) {
                        setState(() => desiredPosition = value);
                      },
                    ),
                    isEmpty: desiredPosition.isEmpty,
                  ),

                  const SizedBox(height: 16),

                  // Chọn ngành nghề mong muốn
                  _buildSelectField(
                    'Ngành nghề mong muốn',
                    desiredIndustry.isEmpty
                        ? 'Chọn ngành nghề mong muốn'
                        : desiredIndustry,
                    () => SelectionDialogs.showIndustryDialog(
                      context,
                      industries,
                      desiredIndustry,
                      (value) {
                        setState(() => desiredIndustry = value);
                      },
                    ),
                    isEmpty: desiredIndustry.isEmpty,
                  ),

                  const SizedBox(height: 16),

                  // Chọn thành phố mong muốn
                  _buildSelectField(
                    'Thành phố mong muốn',
                    desiredCity.isEmpty
                        ? 'Chọn thành phố mong muốn'
                        : desiredCity,
                    () => SelectionDialogs.showCityDialog(
                      context,
                      cities,
                      desiredCity,
                      (value) {
                        setState(() => desiredCity = value);
                      },
                    ),
                    isEmpty: desiredCity.isEmpty,
                  ),

                  const SizedBox(height: 16),

                  // Chọn mức lương
                  _buildSelectField(
                    'Mức lương',
                    salaryRanges.firstWhere(
                      (r) => r['key'] == selectedSalaryKey,
                    )['display'],
                    () => SelectionDialogs.showSalaryDialog(
                      context,
                      salaryRanges,
                      selectedSalaryKey,
                      (key, min, max) {
                        setState(() {
                          selectedSalaryKey = key;
                          minSalary = min;
                          maxSalary = max;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Nút Lưu kỳ vọng nghề nghiệp
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Lưu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget chọn trường (hiển thị label, giá trị, và icon điều hướng)
  Widget _buildSelectField(
    String label,
    String value,
    VoidCallback onTap, {
    bool isEmpty = false,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(color: isEmpty ? theme.hintColor : null),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
