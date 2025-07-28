import 'package:flutter/material.dart';
import 'package:job_finder_app/screens/profile/home_profile_screen.dart';
import 'package:job_finder_app/screens/home/user_home_screen.dart';
import 'package:job_finder_app/screens/chat/chat_list_screen.dart';

void handleMainNavTap(BuildContext context, int index) {
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserHomeScreen()),
    );
  } else if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChatListScreen()),
    );
  } else if (index == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePageProfile()),
    );
  }
}
// Add more cases for other indices if needed