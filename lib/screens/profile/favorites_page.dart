// lib/screens/profile/favorites_page.dart
import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../services/favorite_job_service.dart';
import '../../services/user_preferences_service.dart';
import '../../widgets/job_detail/favorite_job_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoriteJobService _favoriteJobService = FavoriteJobService();

  List<Job> _favoriteJobs = [];
  bool _isLoading = true;
  String? _error;
  int? _userId;
  int _jobCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final userId = await UserPreferencesService.getUserId();
      setState(() => _userId = userId);
      if (userId != null) {
        await _loadFavoriteJobs();
        await _loadJobCount(); // Thêm load số lượng job
      } else {
        setState(() {
          _error = 'Vui lòng đăng nhập để xem danh sách yêu thích.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Lỗi tải dữ liệu: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteJobs() async {
    if (_userId == null) return;
    try {
      final jobs = await _favoriteJobService.getFavoriteJobs(_userId!);
      setState(() {
        _favoriteJobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst("Exception: ", "");
        _isLoading = false;
      });
    }
  }

  // Thêm method để load số lượng job yêu thích
  Future<void> _loadJobCount() async {
    if (_userId == null) return;
    try {
      final count = await _favoriteJobService.countFavoriteJobs(_userId!);
      setState(() {
        _jobCount = count;
      });
    } catch (e) {
      print('[FAVORITES PAGE] Error loading job count: $e');
      // Không set error vì đây không phải lỗi nghiêm trọng
    }
  }

  // This callback is passed to the card to refresh the list after removing an item.
  void _onJobRemoved() {
    // Refresh cả danh sách và số lượng
    _loadFavoriteJobs();
    _loadJobCount();
  }

  @override
  Widget build(BuildContext context) {
    // <<< THÊM MỚI >>> Lấy theme hiện tại
    final theme = Theme.of(context);
    
    return Scaffold(
      // <<< SỬA ĐỔI >>> AppBar sẽ tự động đổi màu theo theme
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            const Text(
              'Thú vị',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!_isLoading && _userId != null)
              Text(
                '$_jobCount công việc',
                style: TextStyle(
                  // <<< SỬA ĐỔI >>> Lấy màu phụ từ theme
                  color: theme.textTheme.bodySmall?.color,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        centerTitle: true,
        // <<< SỬA ĐỔI >>> TabBar sẽ tự động đổi màu theo theme
        bottom: TabBar(
          controller: _tabController,
          // Lấy màu từ colorScheme của theme để đảm bảo tương thích
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.unselectedWidgetColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Vị trí'),
            Tab(text: 'Công ty'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoriteJobsTab(),
          const Center(child: Text('Chưa có dữ liệu')),
        ],
      ),
    );
  }

  Widget _buildFavoriteJobsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Lỗi: $_error'));
    }

    if (_favoriteJobs.isEmpty) {
      return const Center(child: Text('Bạn chưa lưu công việc nào.'));
    }

    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _favoriteJobs.length,
        itemBuilder: (context, index) {
          return FavoriteJobCard(
            job: _favoriteJobs[index],
            userId: _userId!,
            onRemoved: _onJobRemoved,
          );
        },
      ),
    );
  }
}