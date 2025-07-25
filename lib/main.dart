// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import các màn hình của bạn
import 'package:job_finder_app/screens/login/login_screen.dart'; // <-- THÊM DÒNG NÀY
import 'package:job_finder_app/screens/home/user_home_screen.dart';
import 'package:job_finder_app/screens/chat/chat_list_screen.dart';
import 'package:job_finder_app/screens/choose_area/choose_area_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_finder_app/screens/login/auth_gate.dart'; // Đường dẫn tuỳ bạn đặt file

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recruitment App',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1), // Your primary color
        scaffoldBackgroundColor: const Color(
          0xFFF5F5F7,
        ), // Your background color
        fontFamily: 'Inter', // Your preferred font
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1A1A1A)),
          bodyMedium: TextStyle(color: Color(0xFF555555)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF333333)),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(), // Chạy vào AuthGate đầu tiên
    );
  }
}
