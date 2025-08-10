import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // Import service của bạn

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới không khớp.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final bool success = await _authService.changePassword(
      _oldPasswordController.text,
      _newPasswordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công!')),
      );
      Navigator.pop(context); // Quay lại màn hình cài đặt
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thất bại. Vui lòng kiểm tra lại mật khẩu cũ.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi Mật Khẩu')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            TextFormField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu cũ'),
              obscureText: true,
              validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
              obscureText: true,
              validator: (v) => (v?.length ?? 0) < 6 ? 'Mật khẩu phải có ít nhất 6 ký tự' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
              obscureText: true,
              validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleChangePassword,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3))
                  : const Text('Lưu Thay Đổi'),
            )
          ],
        ),
      ),
    );
  }
}