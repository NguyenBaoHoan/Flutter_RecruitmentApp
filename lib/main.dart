import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_finder_app/screens/profile/home_profile_screen.dart';

// Import sang, toi
import 'package:provider/provider.dart'; // <<< THÊM MỚI >>>
import 'package:job_finder_app/providers/theme_provider.dart'; // <<< THÊM MỚI >>>

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

    // <<< THÊM MỚI >>> Bọc ứng dụng bằng ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Dùng Consumer để lắng nghe thay đổi từ ThemeProvider
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Recruitment App',
          
          // <<< SỬA ĐỔI >>> Sử dụng themeMode từ provider
          themeMode: themeProvider.themeMode,

          // <<< GIỮ NGUYÊN >>> Đây là theme sáng của bạn
          theme: ThemeData(
            brightness: Brightness.light, // Chỉ định đây là theme sáng
            primaryColor: const Color(0xFF0D47A1),
            scaffoldBackgroundColor: const Color(0xFFF5F5F7),
            fontFamily: 'Inter',
            useMaterial3: true,
            // Bạn có thể tùy chỉnh thêm màu sắc cho các thành phần khác ở đây
          ),

          // <<< THÊM MỚI >>> Định nghĩa theme tối
          darkTheme: ThemeData(
            brightness: Brightness.dark, // Chỉ định đây là theme tối
            primaryColor: Colors.tealAccent,
            scaffoldBackgroundColor: const Color(0xFF121212), // Màu nền tối phổ biến
            fontFamily: 'Inter',
            useMaterial3: true,
            // Bạn có thể tùy chỉnh thêm màu sắc cho các thành phần khác ở đây
            // Ví dụ: màu chữ, màu button...
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ),

          debugShowCheckedModeBanner: false,
          home: const AuthGate(),
          initialRoute: '/',
          routes: {
            '/recruiter-home': (context) => const RecruiterHomeScreen(),
            '/manage-jobs': (context) => const RecruiterManageJobsScreen(),
            '/chat': (context) => const ChatListScreen(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('vi')],
        );
      },
    );
  }
}
