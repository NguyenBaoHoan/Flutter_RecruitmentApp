import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import 'package:intl/intl.dart';


class RecruiterPostJobScreen extends StatefulWidget {
  final void Function(Job newJob) onJobPosted;
  final Job? initialJob;

  const RecruiterPostJobScreen({
    super.key,
    required this.onJobPosted,
    this.initialJob,
  });

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
  final DateFormat _dateFormatSave = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    if (widget.initialJob != null) {
      final job = widget.initialJob!;
      _title = job.title;
      _company = job.company;
      _salary = job.salary;
      _location = job.location;
      _descriptionController.text = job.description;
      _dateController.text = _dateFormatDisplay.format(
        DateTime.tryParse(job.postDate) ?? DateTime.now(),
      );
      _status = job.status;
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
      initialDate: DateTime.tryParse(widget.initialJob?.postDate ?? '') ?? now,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(widget.initialJob == null
            ? "Đăng một công việc mới"
            : "Chỉnh sửa thông tin công việc"),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCoolTitle(),
              const SizedBox(height: 24),
              _buildTextField(
                label: "Chức danh/Vị trí công việc",
                initialValue: _title,
                onSaved: (v) => _title = v ?? '',
                validator: (v) => v == null || v.trim().isEmpty
                    ? "Nhập chức danh/vị trí"
                    : null,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                label: "Tên công ty",
                initialValue: _company,
                onSaved: (v) => _company = v ?? '',
                validator: (v) => v == null || v.trim().isEmpty
                    ? "Nhập tên công ty"
                    : null,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                label: "Mức lương",
                initialValue: _salary,
                onSaved: (v) => _salary = v ?? '',
                validator: (v) => v == null || v.trim().isEmpty
                    ? "Nhập mức lương"
                    : null,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                label: "Địa điểm làm việc",
                initialValue: _location,
                onSaved: (v) => _location = v ?? '',
                validator: (v) => v == null || v.trim().isEmpty
                    ? "Nhập địa điểm"
                    : null,
              ),
              const SizedBox(height: 18),
              _buildDescriptionField(),
              const SizedBox(height: 18),
              _buildDateInput(context),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2),
                    elevation: 1,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (!_validateDate(_dateController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Nhập hạn nộp hồ sơ đúng định dạng dd/MM/yyyy")),
                        );
                        return;
                      }
                      _formKey.currentState?.save();
                      final parsedDate =
                      _dateFormatDisplay.parseStrict(_dateController.text);
                      final job = Job(
                        iconUrl: "",
                        title: _title,
                        company: _company,
                        salary: _salary,
                        location: _location,
                        postDate: _dateFormatSave.format(parsedDate),
                        status: _status,
                        description: _descriptionController.text,
                      );
                      widget.onJobPosted(job);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.initialJob == null ? "Đăng tin" : "Lưu chỉnh sửa"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoolTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.post_add_rounded, size: 48, color: Colors.blue[600]),
        const SizedBox(height: 8),
        const Text(
          "Điền thông tin tuyển dụng thật chi tiết nhé!",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
      ),
      style: const TextStyle(fontSize: 15),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      minLines: 3,
      decoration: InputDecoration(
        labelText: "Mô tả công việc",
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
      ),
      style: const TextStyle(fontSize: 15),
      validator: (value) => value == null || value.trim().isEmpty
          ? "Nhập mô tả công việc"
          : null,
    );
  }

  Widget _buildDateInput(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: "Hạn nộp hồ sơ (dd/MM/yyyy)",
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
          onPressed: () => _showDatePicker(context),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
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
