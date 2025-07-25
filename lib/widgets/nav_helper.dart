import 'package:flutter/material.dart';
import 'package:job_finder_app/screens/profile/home_page.dart';
import 'package:job_finder_app/widgets/main_bottom_nav_bar.dart';
import 'package:job_finder_app/widgets/nav_helper.dart';

void handleMainNavTap(BuildContext context, int index) {
  if (index == 0) {
    Navigator.pushNamed(context, '/');
  } else if (index == 1) {
    Navigator.pushNamed(context, '/chat');
  }
  if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePageProfile()),
    );
  }
}
// Add more cases for other indices if needed