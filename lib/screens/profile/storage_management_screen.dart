import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StorageManagementScreen extends StatefulWidget {
  const StorageManagementScreen({super.key});

  @override
  State<StorageManagementScreen> createState() => _StorageManagementScreenState();
}

class _StorageManagementScreenState extends State<StorageManagementScreen> {
  bool _isLoading = true;
  String _cacheSize = 'Đang tính toán...';

  @override
  void initState() {
    super.initState();
    _calculateCacheSize();
  }

  // Hàm tính toán dung lượng thư mục cache
  Future<void> _calculateCacheSize() async {
    setState(() {
      _isLoading = true;
      _cacheSize = 'Đang tính toán...';
    });
    // Lấy thư mục cache
    final cacheDir = await getTemporaryDirectory();
    // Tính tổng dung lượng
    final dirSize = await _getDirSize(cacheDir);
    setState(() {
      _cacheSize = _formatBytes(dirSize);
      _isLoading = false;
    });
  }

  // Hàm dọn dẹp cache
  Future<void> _clearCache() async {
    final cacheDir = await getTemporaryDirectory();
    final dirSize = await _getDirSize(cacheDir);

    if (dirSize == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có gì để dọn dẹp.')),
      );
      return;
    }
    
    // Hiển thị dialog xác nhận
    final bool? shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có muốn xóa ${_formatBytes(dirSize)} dữ liệu tạm không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (shouldClear == true) {
      setState(() => _isLoading = true);
      // Xóa các file bên trong thư mục
      final files = await cacheDir.list().toList();
      for (var file in files) {
        await file.delete(recursive: true);
      }
      // Tính toán lại dung lượng (bây giờ sẽ là 0)
      await _calculateCacheSize();
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã dọn dẹp thành công!')),
        );
      }
    }
  }

  // Helper: Lấy dung lượng của một thư mục (tính bằng bytes)
  Future<int> _getDirSize(Directory dir) async {
    int size = 0;
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    }
    return size;
  }

  // Helper: Định dạng bytes thành KB, MB, GB...
  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.toString().length - 1) ~/ 3;
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(2)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý không gian lưu trữ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.cached),
              title: const Text('Dữ liệu tạm (Cache)'),
              subtitle: Text('Các tệp tạm thời, hình ảnh đã tải...'),
              trailing: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_cacheSize, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.cleaning_services_outlined),
              label: const Text('Dọn dẹp Cache'),
              onPressed: _isLoading ? null : _clearCache,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}