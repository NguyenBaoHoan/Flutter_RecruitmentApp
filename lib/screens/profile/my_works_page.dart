import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/portfolio_service.dart';

class MyWorksPage extends StatefulWidget {
  const MyWorksPage({super.key});

  @override
  State<MyWorksPage> createState() => _MyWorksPageState();
}

class _MyWorksPageState extends State<MyWorksPage> {
  int? userId;
  bool loading = true;
  bool savingDesc = false;
  bool uploading = false;
  String description = '';
  final TextEditingController descController = TextEditingController();
  List<dynamic> images = [];
  final int maxImages = 12;

  // Getter để tính số lượng ảnh hiện tại
  int get currentCount => images.length;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ SỬA: Chỉ dùng getInt vì user_id được lưu dưới dạng int
    userId = prefs.getInt('user_id');

    print('DEBUG: userId from prefs: $userId');

    if (userId != null) {
      await _loadPortfolio();
    }
    setState(() {
      loading = false;
    });
  }

  String _buildImageUrl(dynamic item) {
    final relative = (item['filePath'] ?? '').toString(); // portfolio/3/xxx
    if (relative.isEmpty) return '';
    // Không encode toàn bộ thư mục, chỉ encode tên file
    final parts = relative.split('/');
    if (parts.length < 3) return '';
    final fileName = Uri.encodeComponent(parts.sublist(2).join('/'));
    return 'http://192.168.1.2:8080/uploads/${parts[0]}/${parts[1]}/$fileName';
  }

  Future<void> _loadPortfolio() async {
    if (userId == null) return;
    final data = await PortfolioService.fetchPortfolio(userId!);
    if (data != null) {
      description = data['description'] ?? '';
      descController.text = description;
      images = List<dynamic>.from(data['images'] ?? []);
      if (mounted) setState(() {});
    }
  }

  Future<void> _saveDescription() async {
    if (userId == null) return;
    setState(() => savingDesc = true);
    final ok = await PortfolioService.saveDescription(
      userId!,
      descController.text.trim(),
    );
    if (ok) {
      description = descController.text.trim();
      _showSnack('Đã lưu mô tả');
    } else {
      _showSnack('Lưu mô tả thất bại');
    }
    setState(() => savingDesc = false);
  }

  Future<void> _addImages() async {
    if (userId == null) return;
    if (images.length >= maxImages) {
      _showSnack('Đã đạt tối đa $maxImages ảnh');
      return;
    }
    setState(() => uploading = true);
    final newImgs = await PortfolioService.uploadImages(userId!, images.length);
    if (newImgs.isEmpty) {
      _showSnack('Không thêm được ảnh');
    } else {
      images.addAll(newImgs);
      _showSnack('Đã thêm ${newImgs.length} ảnh');
    }
    setState(() => uploading = false);
  }

  Future<void> _deleteImage(int imageId) async {
    if (userId == null) return;
    final ok = await PortfolioService.deleteImage(userId!, imageId);
    if (ok) {
      images.removeWhere((e) => e['id'] == imageId);
      setState(() {});
      _showSnack('Đã xóa ảnh');
    } else {
      _showSnack('Xóa thất bại');
    }
  }

  void _openImageViewer(int startIndex) {
    final urls = images.map((e) => _buildImageUrl(e)).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _FullImageViewer(images: urls, initialIndex: startIndex),
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy theme hiện tại để sử dụng
    final theme = Theme.of(context);

    return Scaffold(
      // AppBar sẽ tự động đổi màu theo theme
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cập nhật sản phẩm cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: (currentCount < maxImages)
          ? FloatingActionButton(
              onPressed: uploading ? null : _addImages,
              child: uploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.add_photo_alternate),
            )
          : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông báo về nội dung tải lên
                  const Text(
                    'Nội dung tải lên không được chứa thông tin nhạy cảm và thông tin liên hệ cá nhân, chẳng hạn như mã QR, số điện thoại hoặc địa chỉ email, v.v.',
                    // Text sẽ tự động đổi màu
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Phần thông tin tác phẩm
                  const Text(
                    'Thông tin tác phẩm',
                    // Text sẽ tự động đổi màu
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    // Card sẽ tự động đổi màu
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: descController,
                        maxLines: 5,
                        maxLength: 2000,
                        decoration: InputDecoration(
                          hintText:
                              'Giới thiệu ngắn gọn về các dự án / tác phẩm...',
                          // hintStyle sẽ tự động đổi màu
                          hintStyle: TextStyle(color: theme.hintColor),
                          border: InputBorder.none,
                          counterText: '${descController.text.length}/2000',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: savingDesc ? null : _saveDescription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: savingDesc
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Lưu mô tả'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Phần tải hình ảnh lên
                  Text(
                    'Tải hình ảnh lên ($currentCount/$maxImages)',
                    // Text sẽ tự động đổi màu
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildImageGrid(theme),
                  const SizedBox(height: 90),
                ],
              ),
            ),
    );
  }

  Widget _buildImageGrid(ThemeData theme) {
    if (images.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        // Card sẽ tự động đổi màu
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Nút thêm ảnh
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  // Dùng màu viền từ theme
                  border: Border.all(
                    color: theme.dividerColor,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  // Icon sẽ tự động đổi màu
                  icon: const Icon(Icons.add, size: 40),
                  onPressed: _addImages,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Chưa có hình ảnh nào',
                style: TextStyle(color: theme.hintColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Nhấn nút dấu + để thêm ảnh',
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (ctx, i) {
        final item = images[i];
        final imgUrl = _buildImageUrl(item);
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onTap: () => _openImageViewer(i),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'pf_$i',
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      final id = item['id'];
                      if (id != null) _deleteImage(id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FullImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const _FullImageViewer({required this.images, required this.initialIndex});

  @override
  State<_FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<_FullImageViewer> {
  late PageController _page;
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.initialIndex;
    _page = PageController(initialPage: current);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('${current + 1}/${widget.images.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _page,
        onPageChanged: (i) => setState(() => current = i),
        itemCount: widget.images.length,
        itemBuilder: (ctx, i) {
          final url = widget.images[i];
          return InteractiveViewer(
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
