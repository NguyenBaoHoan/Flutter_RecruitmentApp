import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home/user_home_screen.dart';
import 'screens/recruiter/recruiter_home_screen.dart';
import 'screens/recruiter/recruiter_manage_jobs_screen.dart';
import 'screens/chat/chat_list_screen.dart';
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
        primaryColor: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(), // Chạy vào AuthGate đầu tiên
      initialRoute: '/',
      routes: {
        '/recruiter-home': (context) => const RecruiterHomeScreen(),
        '/manage-jobs': (context) => const RecruiterManageJobsScreen(),
        '/chat': (context) => const ChatListScreen(),
      },
      // Thêm dưới đây để sửa lỗi DatePicker / localization:
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
    );
  }
}
