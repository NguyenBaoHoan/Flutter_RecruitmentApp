import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  // Sửa lỗi chính tả từ 'createaState' thành 'createState'
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Text(
          'Thú vị',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent, // Màu của thanh chỉ báo tab
          labelColor: Colors.blueAccent, // Màu chữ của tab được chọn
          unselectedLabelColor: Colors.grey, // Màu chữ của tab không được chọn
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Vị trí'),
            Tab(text: 'Công ty'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Nội dung cho tab "Vị trí"
          _NoDataContent(
            message: 'Chưa có dữ liệu',
            imagePath: 'https://placehold.co/200x200/white/grey?text=No+Data', // Placeholder image
          ),
          // Nội dung cho tab "Công ty"
          _NoDataContent(
            message: 'Chưa có dữ liệu',
            imagePath: 'https://placehold.co/200x200/white/grey?text=No+Data', // Placeholder image
          ),
        ],
      ),
    );
  }
}

// Widget hiển thị khi không có dữ liệu
class _NoDataContent extends StatelessWidget {
  final String message;
  final String imagePath; // Đường dẫn đến hình ảnh

  const _NoDataContent({
    required this.message,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sử dụng Image.network cho placeholder hoặc Image.asset nếu bạn có hình ảnh cục bộ
          Image.network(
            imagePath,
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported_outlined,
                size: 100,
                color: Colors.grey.shade400,
              ); // Fallback icon if image fails to load
            },
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
