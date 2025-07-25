// lib/screens/user_home_screen.dart

import 'package:flutter/material.dart';
import 'package:job_finder_app/widgets/main_bottom_nav_bar.dart';
import 'package:job_finder_app/widgets/nav_helper.dart';
import '../../../models/job_model.dart';
import '../../../widgets/job_card.dart';
import '../choose_area/choose_area_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // Dữ liệu mẫu
  final List<Job> jobs = [
    Job(
      title: 'Nhân Viên Lễ Tân Kiêm Sale',
      company: 'CÔNG TY CỔ PHẦN ĐẦU TƯ XÂY DỰNG BẤT ĐỘNG SẢN HOÀNG TRIỀU',
      salary: '10-12 Triệu',
      location: 'Bình Thạnh - Hồ Chí Minh',
      postDate: 'Hôm nay',
      iconUrl: '',
    ),
    Job(
      title: 'Chuyên Viên Kế Toán Tổng Hợp',
      company: 'CÔNG TY CỔ PHẦN CÔNG NGHỆ VÀ DỊCH VỤ DỮ LIỆU SỐ TDS',
      salary: '18-20 Triệu',
      location: 'Cầu Giấy - Hà Nội',
      postDate: 'Hôm nay',
      iconUrl: '',
    ),
    Job(
      title: 'Nhân Viên Kinh Doanh Thuốc Thủy Sản',
      company: 'CÔNG TY TNHH HÓA CHẤT THỊNH THỊNH',
      salary: 'Thỏa thuận',
      location: 'Thủ Đức - Hồ Chí Minh',
      postDate: 'Hôm nay',
      iconUrl: '',
    ),
    Job(
      title: 'Nhân Viên Kinh Doanh',
      company: 'CÔNG TY TNHH FLUMA TECH',
      salary: 'Thỏa thuận',
      location: 'Quận 7 - Hồ Chí Minh',
      postDate: 'Hôm qua',
      iconUrl: '',
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    handleMainNavTap(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildResumeAlert(),
            _buildFilterChips(),
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return JobCard(job: jobs[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseAreaScreen(),
                  ),
                );
              },
              child: Row(
                children: const [
                  Icon(Icons.location_on_outlined, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('Khu vực'),
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildIconButton(Icons.search),
          _buildIconButton(Icons.add),
          _buildIconButton(Icons.filter_list),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black54),
        onPressed: () {},
      ),
    );
  }

  Widget _buildResumeAlert() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 13),
                children: [
                  TextSpan(
                    text:
                        'Sơ yếu lý lịch đã được ẩn. Mở nó ra có thể cải thiện hiệu quả tìm kiếm việc làm. ',
                  ),
                  TextSpan(
                    text: 'CV mở',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ActionChip(
            label: const Text('Việc làm hấp dẫn'),
            onPressed: () {},
            backgroundColor: Colors.blue.withOpacity(0.1),
            labelStyle: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          ActionChip(
            label: const Text('Fullstack Developer'),
            onPressed: () {},
            backgroundColor: Colors.grey[200],
            labelStyle: TextStyle(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
