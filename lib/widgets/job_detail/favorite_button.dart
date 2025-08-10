// lib/widgets/job_detail/favorite_button.dart
import 'package:flutter/material.dart';
import '../../services/favorite_job_service.dart';

class FavoriteButton extends StatefulWidget {
  final int userId;
  final int jobId;
  final VoidCallback? onFavoriteChanged;

  const FavoriteButton({
    super.key,
    required this.userId,
    required this.jobId,
    this.onFavoriteChanged,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoriteJobService _service = FavoriteJobService();
  bool _isFavorited = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    setState(() => _isLoading = true);
    try {
      final status = await _service.checkIfFavorited(
        widget.userId,
        widget.jobId,
      );
      if (!mounted) return;
      setState(() {
        _isFavorited = status;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoading = true);
    try {
      if (_isFavorited) {
        await _service.removeFromFavorites(widget.userId, widget.jobId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa khỏi danh sách yêu thích.')),
          );
        }
      } else {
        await _service.addToFavorites(widget.userId, widget.jobId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm vào danh sách yêu thích!')),
          );
        }
      }
      if (!mounted) return;
      setState(() => _isFavorited = !_isFavorited);
      widget.onFavoriteChanged?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return IconButton(
      tooltip: _isFavorited ? 'Bỏ yêu thích' : 'Thêm yêu thích',
      icon: Icon(
        _isFavorited ? Icons.favorite : Icons.favorite_border,
        color: _isFavorited ? Colors.red : null,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
