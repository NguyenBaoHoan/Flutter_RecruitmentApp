import 'package:flutter/material.dart';

void handleMainNavTap(BuildContext context, int index) {
  if (index == 0) {
    Navigator.pushNamed(context, '/');
  } else if (index == 1) {
    Navigator.pushNamed(context, '/chat');
  }
}
