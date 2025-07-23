// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for SystemChrome
import 'package:job_finder_app/screens/home/user_home_screen.dart';
import 'package:job_finder_app/screens/chat/chat_list_screen.dart';
import 'package:job_finder_app/screens/choose_area/choose_area_screen.dart';
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
      title: 'Job Finder App',
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
      initialRoute: '/',
      routes: {
        '/': (context) => const UserHomeScreen(), // Use HomeScreen here
        '/chat': (context) => const ChatListScreen(),
        '/choose-area': (context) => const ChooseAreaScreen() // 2. Thêm route mới tại đây
      },
    );
  }
}
