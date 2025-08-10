import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecruiterPostJobScreen extends StatefulWidget {
  final void Function(Map<String, String> newJob)? onJobPosted;
  final Map<String, String>? initialJob;

  const RecruiterPostJobScreen({super.key, this.onJobPosted, this.initialJob});

  @override
  State<RecruiterPostJobScreen> createState() => _RecruiterPostJobScreenState();
}

class _RecruiterPostJobScreenState extends State<RecruiterPostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _title = '';
  String _company = '';
  String _salary = '';
  String _location = '';
  String _status = 'pending';

  final DateFormat _dateFormatDisplay = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.initialJob != null) {
      final job = widget.initialJob!;
      _title = job['title'] ?? '';
      _company = job['company'] ?? '';
      _salary = job['salary'] ?? '';
      _location = job['location'] ?? '';
      _descriptionController.text = job['description'] ?? '';
      _dateController.text = job['postDate'] ?? '';
      _status = job['status'] ?? 'pending';
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
      helpText: 'Chọn hạn nộp hồ sơ',
      locale: const Locale('vi'),
    );
    if (picked != null) {
      _dateController.text = _dateFormatDisplay.format(picked);
    }
  }

  bool _validateDate(String? text) {
    if (text == null || text.trim().isEmpty) return false;
    try {
      _dateFormatDisplay.parseStrict(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme để sử dụng
    final theme = Theme.of(context);

    return Scaffold(
      // <<< SỬA ĐỔI >>> Xóa màu nền cố định
      appBar: AppBar(
        title: Text(
          widget.initialJob == null
              ? "Đăng một công việc mới"
              : "Chỉnh sửa thông tin công việc",
        ),
        // <<< SỬA ĐỔI >>> Xóa các màu cố định, AppBar sẽ tự động đổi màu
        elevation: 1,
        titleTextStyle: TextStyle(
          color: theme.textTheme.titleLarge?.color, // Lấy màu từ theme
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCoolTitle(context), // <<< SỬA ĐỔI >>> Truyền context
              const SizedBox(height: 24),
              _buildTextField(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                label: "Chức danh/Vị trí công việc",
                initialValue: _title,
                onSaved: (v) => _title = v ?? '',
                validator: (v) => v == null || v.trim().isEmpty
                    ? "Nhập chức danh/vị trí"
                    : null,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                label: "Tên công ty",
                initialValue: _company,
                onSaved: (v) => _company = v ?? '',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Nhập tên công ty" : null,
              ),
              const SizedBox(height: 18),
               _buildTextField(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                label: "Mức lương",
                initialValue: _salary,
                onSaved: (v) => _salary = v ?? '',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Nhập mức lương" : null,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                context: context, // <<< SỬA ĐỔI >>> Truyền context
                label: "Địa điểm làm việc",
                initialValue: _location,
                onSaved: (v) => _location = v ?? '',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Nhập địa điểm" : null,
              ),
              const SizedBox(height: 18),
              _buildDescriptionField(context), // <<< SỬA ĐỔI >>> Truyền context
              const SizedBox(height: 18),
              _buildDateInput(context),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  // <<< SỬA ĐỔI >>> Nút sẽ tự động lấy màu từ theme
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                    elevation: 1,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (!_validateDate(_dateController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Nhập hạn nộp hồ sơ đúng định dạng dd/MM/yyyy",
                            ),
                          ),
                        );
                        return;
                      }
                      _formKey.currentState?.save();
                      final job = {
                        'title': _title,
                        'company': _company,
                        'salary': _salary,
                        'location': _location,
                        'postDate': _dateController.text,
                        'status': _status,
                        'description': _descriptionController.text,
                      };
                      if (widget.onJobPosted != null) {
                        widget.onJobPosted!(job);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.initialJob == null ? "Đăng tin" : "Lưu chỉnh sửa",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoolTitle(BuildContext context) { // <<< SỬA ĐỔI >>> Nhận context
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.post_add_rounded, size: 48, color: theme.colorScheme.primary), // <<< SỬA ĐỔI >>>
        const SizedBox(height: 8),
        const Text(
          "Điền thông tin tuyển dụng thật chi tiết nhé!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ), // <<< SỬA ĐỔI >>> Xóa màu cố định
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context, // <<< SỬA ĐỔI >>> Nhận context
    required String label,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
    String? initialValue,
  }) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(color: theme.dividerColor, width: 1);
    final focusedBorderSide = BorderSide(color: theme.colorScheme.primary, width: 2);
    final borderRadius = BorderRadius.circular(14);
    
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        // <<< SỬA ĐỔI >>> Dùng màu card từ theme
        fillColor: theme.cardColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: focusedBorderSide,
        ),
      ),
      style: const TextStyle(fontSize: 15),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDescriptionField(BuildContext context) { // <<< SỬA ĐỔI >>> Nhận context
    final theme = Theme.of(context);
    final borderSide = BorderSide(color: theme.dividerColor, width: 1);
    final focusedBorderSide = BorderSide(color: theme.colorScheme.primary, width: 2);
    final borderRadius = BorderRadius.circular(14);

    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      minLines: 3,
      decoration: InputDecoration(
        labelText: "Mô tả công việc",
        filled: true,
        fillColor: theme.cardColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
        enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
        focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorderSide),
      ),
      style: const TextStyle(fontSize: 15),
      validator: (value) =>
          value == null || value.trim().isEmpty ? "Nhập mô tả công việc" : null,
    );
  }

  Widget _buildDateInput(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(color: theme.dividerColor, width: 1);
    final focusedBorderSide = BorderSide(color: theme.colorScheme.primary, width: 2);
    final borderRadius = BorderRadius.circular(14);

    return TextFormField(
      controller: _dateController,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: "Hạn nộp hồ sơ (dd/MM/yyyy)",
        filled: true,
        fillColor: theme.cardColor,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
          onPressed: () => _showDatePicker(context),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
        enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: borderSide),
        focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorderSide),
      ),
      style: const TextStyle(fontSize: 15),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nhập hạn nộp hồ sơ';
        }
        if (!_validateDate(value)) {
          return 'Định dạng ngày dd/MM/yyyy';
        }
        return null;
      },
    );
  }
}