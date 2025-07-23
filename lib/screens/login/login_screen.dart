import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Biến để quản lý trạng thái của checkbox
  bool _termsAccepted = false;
  // Biến để quản lý ẩn/hiện mật khẩu
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              // 1. Logo
              // Thay 'assets/images/logo.png' bằng đường dẫn đến logo của bạn
              // Hoặc dùng Icon nếu bạn không có logo
              Icon(
                Icons.supervised_user_circle, // Icon thay thế cho logo
                size: 80.0,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 60),

              // 2. Trường nhập email
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Vui lòng nhập Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Trường nhập mật khẩu
              TextFormField(
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  hintText: 'Vui lòng nhập mật khẩu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 4. Link "Đăng nhập bằng mã xác minh"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Xử lý logic đăng nhập bằng mã xác minh
                  },
                  child: Text(
                    'Đăng nhập bằng mã xác minh',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5. Nút Đăng nhập chính
              ElevatedButton(
                onPressed: () {
                  // TODO: Xử lý logic đăng nhập
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),

              // 6. Phân cách "Hoặc đăng nhập bằng"
              Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Hoặc đăng nhập bằng',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 30),

              // 7. Các nút đăng nhập mạng xã hội
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSocialButton(FontAwesomeIcons.envelope, () {
                    // TODO: Login with Email
                  }),
                  const SizedBox(width: 20),
                  _buildSocialButton(FontAwesomeIcons.google, () {
                    // TODO: Login with Google
                  }),
                  const SizedBox(width: 20),
                  _buildSocialButton(FontAwesomeIcons.comment, () {
                    // TODO: Login with Zalo - Cần icon Zalo riêng
                    // FontAwesome không có icon Zalo, bạn có thể dùng icon khác hoặc ảnh
                  }),
                   const SizedBox(width: 20),
                  _buildSocialButton(FontAwesomeIcons.apple, () {
                    // TODO: Login with Apple
                  }),
                ],
              ),
              const SizedBox(height: 40),

              // 8. Checkbox điều khoản và chính sách
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value!;
                      });
                    },
                    activeColor: Colors.blue.shade700,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                        children: [
                          const TextSpan(
                              text: 'Bằng việc đăng nhập, tôi xác nhận đã đọc và đồng ý với '),
                          TextSpan(
                            text: 'Thỏa thuận người dùng',
                            style: TextStyle(color: Colors.blue.shade700, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // TODO: Mở trang Thỏa thuận người dùng
                              print('Navigate to Terms of Service');
                            },
                          ),
                          const TextSpan(text: ' và '),
                          TextSpan(
                            text: 'Chính sách bảo mật',
                             style: TextStyle(color: Colors.blue.shade700, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // TODO: Mở trang Chính sách bảo mật
                               print('Navigate to Privacy Policy');
                            },
                          ),
                           const TextSpan(text: ' của goodboss.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
               const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget tùy chỉnh cho các nút đăng nhập mạng xã hội
  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: FaIcon(icon),
      iconSize: 30,
      onPressed: onPressed,
      color: Colors.grey.shade800,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}