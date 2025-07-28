import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../home/user_home_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_gate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  // Biến để quản lý trạng thái của checkbox
  bool _termsAccepted = false;
  // Biến để quản lý ẩn/hiện mật khẩu
  bool _isPasswordObscured = true;

  // Hàm initState() là một phương thức vòng đời của StatefulWidget,
  // được gọi một lần duy nhất khi widget này được tạo ra lần đầu tiên.
  // Ở đây, nó dùng để kiểm tra trạng thái đăng nhập của người dùng ngay khi màn hình đăng nhập được khởi tạo.
  @override
  void initState() {
    super
        .initState(); // Gọi hàm khởi tạo của lớp cha để đảm bảo mọi thứ được thiết lập đúng.
    _checkLoginStatus(); // Kiểm tra xem người dùng đã đăng nhập chưa, nếu rồi thì chuyển sang màn hình chính.
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // Nếu đã đăng nhập, chuyển thẳng sang Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserHomeScreen()),
      );
    }
  }

  Future<void> _login() async {
    final user = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      print('Đăng nhập thành công!');
      print('ID: ${user.id}');
      print('Email: ${user.email}');
      print('Name: ${user.name}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thành công! Xin chào ${user.name}')),
      );

      // Lưu thông tin đăng nhập và thông tin người dùng
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_id', user.id.toString());

      //if login success, go to home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng nhập thất bại!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hàm build trả về widget giao diện của màn hình đăng nhập
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
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
              Icon(
                Icons.supervised_user_circle, // Icon thay thế cho logo
                size: 80.0,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 60),

              // 2. Trường nhập email
              TextFormField(
                controller: _emailController,
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
                controller: _passwordController,
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
                onPressed: _termsAccepted ? _login : null,
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
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'Bằng việc đăng nhập, tôi xác nhận đã đọc và đồng ý với ',
                          ),
                          TextSpan(
                            text: 'Thỏa thuận người dùng',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // TODO: Mở trang Thỏa thuận người dùng
                                print('Navigate to Terms of Service');
                              },
                          ),
                          const TextSpan(text: ' và '),
                          TextSpan(
                            text: 'Chính sách bảo mật',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
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
